import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:awakn/main.dart';
import 'package:awakn/models/alarm_response.dart';
import 'package:awakn/utils/helper.dart';
import 'package:awakn/views/alarm_trigger/face_detection/painters/face_detector_painter.dart';
import 'package:awakn/views/alarm_trigger/reels/reel_view.dart';
import 'package:awakn/views/alarm_trigger/reels/reel_view_model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class AlarmTriggerViewModel extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isWakeUpAlarm = false.obs;

  int cameraIndex = 0;
  final CameraLensDirection initialDirection = CameraLensDirection.front;
  CameraController? _controller;

  int alarmId = 2323;
  AlarmObject? alarm;
  final daytime = getCurrentDaytimeEnum();

  bool canProcess = true;
  bool isBusy = false;
  RxBool bothEyesOpen = false.obs;
  RxBool bothEyesBlinked = false.obs;
  RxBool smileDetected = false.obs;
  CustomPaint? customPaint;
  String text = "Blink your eyes";
  bool rightBlinked = false;
  bool leftBlinked = false;

  // List<CameraDescription> cameras = [];

  GetStorage box = GetStorage();
  final pageFormKey = GlobalKey<FormState>();
  late FaceDetector _faceDetector;

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  Future<void> onInit() async {
    super.onInit();

    // _requestCameraPermission();

    try {
      // cameras = await availableCameras();
      if (cameras.any((element) => element.lensDirection == initialDirection
          // &&
          // element.sensorOrientation == 90,
          )) {
        cameraIndex = cameras.indexOf(
          cameras
              .firstWhere((element) => element.lensDirection == initialDirection
                  //  &&
                  // element.sensorOrientation == 90,
                  ),
        );
      } else {
        cameraIndex = cameras.indexOf(
          cameras.firstWhere(
            (element) => element.lensDirection == initialDirection,
          ),
        );
      }
    } on CameraException catch (e) {
      debugPrint('CameraError: ${e.description}');
    }
    WakelockPlus.enable();
  }

  // Future<void> _requestCameraPermission() async {
  //   PermissionStatus status = await Permission.camera.request();
  //   if (status.isDenied) {
  //     print('Camera permission granted');
  //
  //   } else {
  //     print('Camera permission denied');
  //   }
  // }

  void initializeReelsController() {
    final model = Get.put(ReelsController());
    model.alarm = alarm;
    model.getAlarmData();
  }

  @override
  onClose() {
    canProcess = false;
    _faceDetector.close();
    WakelockPlus.disable();
  }

  Widget liveFeedBody(BuildContext context) {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    if (_controller == null) return Container();
    var scale = size.aspectRatio * _controller!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Transform.scale(
            scale: scale,
            child: Center(
              child: CameraPreview(_controller!),
            ),
          ),
          if (customPaint != null) customPaint!,
        ],
      ),
    );
  }

  Future _processCameraImage(CameraImage image) async {
    final camera = getCameraDescription();
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return;
    final plane = image.planes.first;

    // compose InputImage using bytes
    final inputImage = InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );

    processImage(inputImage);
  }

  Future startLiveFeed() async {
    canProcess = true;
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
          enableContours: true,
          enableClassification: true,
          enableLandmarks: true,
          enableTracking: true,
          minFaceSize: 0.1,
          performanceMode: FaceDetectorMode.accurate),
    );

    _controller = CameraController(
      getCameraDescription(),
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21 // for Android
          : ImageFormatGroup.bgra8888, // for iOS
    );
    _controller?.initialize().then((_) {
      if (!Get.context!.mounted) {
        return;
      }
      _controller?.startImageStream(_processCameraImage);
      update();
    });
  }

  Future stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
    canProcess = false;
    leftBlinked = false;
    rightBlinked = false;
    bothEyesBlinked.value = false;
    smileDetected.value = false;
    // showCamera = false;
    _faceDetector.close();
    update();
  }

  bool isReelStarted = false;

  startReels() {
    if (!isReelStarted) {
      Alarm.stop(alarmId).then((_) {});
      update();
      Get.to(() => const ReelsPage());
      isReelStarted = true;
    }
  }

  CameraDescription getCameraDescription() {
    return cameras[cameraIndex];
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!canProcess) return;
    if (isBusy) return;
    isBusy = true;
    final faces = await _faceDetector.processImage(inputImage);
    if (faces.isEmpty) {
      bothEyesOpen.value = false;
      // smileDetected.value = false;
    }
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
      );
      customPaint = CustomPaint(painter: painter);

      for (final face in faces) {
        double leftEyeOpenProbability = face.leftEyeOpenProbability ?? 0.0;
        double rightEyeOpenProbability = face.rightEyeOpenProbability ?? 0.0;
        double smilingProbability = face.smilingProbability ?? 0.0;

        // debugPrint("Left Eye Probability ===> ${face.leftEyeOpenProbability}");
        // debugPrint(
        //     "Right Eye Probability ===> ${face.rightEyeOpenProbability}");

        leftBlinked = leftEyeOpenProbability < 0.3;

        //   if (leftBlinked && rightBlinked) {
        //     bothEyesBlinked.value = true;
        //   } else {
        //     bothEyesBlinked.value = false;
        //   }
        // }
        rightBlinked = rightEyeOpenProbability < 0.3;

        //   if (leftBlinked && rightBlinked) {
        //     bothEyesBlinked.value = true;
        //   } else {
        //     bothEyesBlinked.value = false;
        //   }
        // }
        if (leftEyeOpenProbability > 0.3 && rightEyeOpenProbability > 0.3) {
          bothEyesOpen.value = true;
        } else {
          bothEyesOpen.value = false;
        }

        if (leftEyeOpenProbability < 0.25 && rightEyeOpenProbability < 0.25) {
          bothEyesBlinked.value = true;
        } else {
          bothEyesBlinked.value = false;
        }
        if (smilingProbability > 0.4) {
          smileDetected.value = true;
        } else {
          smileDetected.value = false;
        }
      }
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      text = text;
      customPaint = null;
    }
    isBusy = false;
    // JD Check
    // if (mounted) {
    // setState(() {});
    // }
  }
}
