import 'package:awakn/views/alarm_trigger/alarm_trigger_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ScreenMode {
  liveFeed,
}

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  // final String title;

  // final Function(InputImage inputImage) onImage;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final ScreenMode _mode = ScreenMode.liveFeed;
  // late AlarmTriggerViewModel alarmTriggerModel;
  final alarmTriggerModel = Get.find<AlarmTriggerViewModel>();

  @override
  void initState() {
    super.initState();

    alarmTriggerModel.startLiveFeed();
  }

  @override
  void dispose() {
    // alarmTriggerModel.canProcess = true;
    alarmTriggerModel.stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return GetBuilder<AlarmTriggerViewModel>(
    //   // init: Get.find<AlarmTriggerViewModel>(),
    //   initState: (_) {},
    //   builder: (_) {
    // alarmTriggerModel = model;
    return Scaffold(
      body: _body(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              alarmTriggerModel.text,
              style: const TextStyle(
                fontSize: 24,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
    //   },
    // );
  }

  Widget _body() {
    Widget body;
    if (_mode == ScreenMode.liveFeed) {
      body = alarmTriggerModel.liveFeedBody(context);
    } else {
      body = Container();
    }
    return body;
  }

  // Widget _liveFeedBody() {
  //   if (_controller?.value.isInitialized == false) {
  //     return Container();
  //   }

  //   final size = MediaQuery.of(context).size;
  //   if (_controller == null) return Container();
  //   var scale = size.aspectRatio * _controller!.value.aspectRatio;
  //   if (scale < 1) scale = 1 / scale;

  //   return Container(
  //     color: Colors.black,
  //     child: Stack(
  //       fit: StackFit.expand,
  //       children: <Widget>[
  //         Transform.scale(
  //           scale: scale,
  //           child: Center(
  //             child: CameraPreview(_controller!),
  //           ),
  //         ),
  //         if (alarmTriggerModel.customPaint != null)
  //           alarmTriggerModel.customPaint!,
  //       ],
  //     ),
  //   );
  // }

  // Future _startLiveFeed() async {
  //   _controller = CameraController(
  //     alarmTriggerModel.getCameraIndex(),
  //     ResolutionPreset.high,
  //     enableAudio: false,
  //   );
  //   _controller?.initialize().then((_) {
  //     if (!mounted) {
  //       return;
  //     }
  //     _controller?.startImageStream(_processCameraImage);
  //     setState(() {});
  //   });
  // }

  // Future stopLiveFeed() async {
  //   await _controller?.stopImageStream();
  //   await _controller?.dispose();
  //   _controller = null;
  // }

  // Future _processCameraImage(CameraImage image) async {
  //   final WriteBuffer allBytes = WriteBuffer();
  //   for (final plane in image.planes) {
  //     allBytes.putUint8List(plane.bytes);
  //   }
  //   final bytes = allBytes.done().buffer.asUint8List();

  //   final Size imageSize =
  //       Size(image.width.toDouble(), image.height.toDouble());

  //   final camera = alarmTriggerModel.getCameraIndex();
  //   final imageRotation =
  //       InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
  //           InputImageRotation.rotation0deg;

  //   final inputImageFormat =
  //       InputImageFormatValue.fromRawValue(image.format.raw) ??
  //           InputImageFormat.nv21;

  //   final planeData = image.planes.map(
  //     (Plane plane) {
  //       return InputImageMetadata(
  //         bytesPerRow: plane.bytesPerRow,
  //         // height: plane.height,
  //         // width: plane.width,
  //         size: imageSize,
  //         rotation: imageRotation,
  //         format: inputImageFormat,
  //       );
  //     },
  //   ).toList();

  //   final inputImageMetaData = InputImageMetadata(
  //     size: imageSize,
  //     // imageRotation: imageRotation,
  //     // inputImageFormat: inputImageFormat,
  //     // planeData: planeData,
  //     rotation: imageRotation,
  //     format: inputImageFormat,
  //     bytesPerRow: alarmTriggerModel.cameraIndex,
  //   );

  //   final inputImage = InputImage.fromBytes(
  //     bytes: bytes,
  //     metadata: inputImageMetaData,
  //   );

  //   // if (widget.eyeBlinked) {
  //   //   _finishDetector();
  //   // }
  //   alarmTriggerModel.processImage(inputImage);
  //   // widget.onImage(inputImage);
  // }

//_finishDetector() {
//     if(widget.eyeBlinked && widget.smile)
//     _stopLiveFeed().then((value) {
//       Future.delayed(const Duration(seconds: 0), () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (_) => const ResultPage(),
//           ),
//         );
//       });
//     });
//   }
//
  // _finishDetector() {
  //   _stopLiveFeed().then((value) {
  //     Future.delayed(const Duration(seconds: 0), () {
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (_) => StoriesPage(
  //             //TODO (Junaid): set alarm ID
  //             alarmId: 232,
  //           ),
  //         ),
  //       );
  //     });
  //   });
  // }
}
