import 'dart:async';
import 'dart:math';
import 'package:awakn/views/alarm_trigger/reels/slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DotAnimationController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController zoomController;
  late AnimationController zoomYellowController;
  late AnimationController zoomTextController;
  late Animation<double> zoomAnimation;
  late Animation<double> zoomYellowAnimation;
  late Animation<double> zoomTextAnimation;
  late Animation<double> widthAnimation;
  late Color randomColor;
  late Animation<double> heightAnimation;
  late Animation<double> opacityAnimation;
  late AnimationController textSlideController;
  late Animation<Offset> textSlideAnimation;
  late Animation<double> textSizeAnimation;
  late double randomTop;
  late double randomBottom;
  var textVisible = true.obs;
  late AnimationController slideController;
  late Animation<Offset> slideAnimation;
  late AnimationController animationController;
  late double screenWidth;
  late double screenHeight;
  double yellowContainer = 130;
  double textSize = 30.0;
  bool showAnimatedBuilder = false;
  bool showText = false;
  LastPosition lastPosition = LastPosition.topBottom;
  late ShapeType shapeType;

  @override
  void onInit() {
    super.onInit();
    textSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    textSlideAnimation = Tween<Offset>(
      begin: _getRandomOffset(),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: textSlideController,
        curve: Curves.easeInOut,
      ),
    );
    zoomController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 2),
    );
    zoomAnimation = Tween<double>(begin: 1.9, end: 1.0).animate(
      CurvedAnimation(
        parent: zoomController,
        curve: Curves.decelerate,
      ),
    );
    zoomYellowController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 2),
    );

    zoomYellowAnimation = Tween<double>(begin: 1.0, end: 2.5).animate(
      CurvedAnimation(
        parent: zoomYellowController,
        curve: Curves.decelerate,
      ),
    );
    zoomTextController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    zoomTextAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: zoomTextController,
        curve: Curves.easeInOut,
      ),
    );
    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: slideController,
        curve: Curves.easeInOut,
      ),
    );

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    textSizeAnimation = Tween<double>(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    animationController.addListener(() {
      update();
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // showAnimatedBuilder = false;

        textSize = 60.0;
        Future.delayed(const Duration(seconds: 1), () {
          showAnimatedBuilder = true;
          animationController.reverse();
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          showText = true;
        });
      } else if (status == AnimationStatus.dismissed) {
        animationController.stop();
        showAnimatedBuilder = false;
      }
    });
  }

  void initiate() {
    randomTop = Random().nextDouble();
    randomBottom = Random().nextDouble();
    randomColor = _generateRandomColor();
    shapeType = _getRandomShape();

    // Reset animation controllers
    textSlideController.reset();
    zoomController.reset();
    // zoomYellowController.reset();
    zoomTextController.reset();
    // slideController.reset();
    // animationController.reset();

    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      textVisible.value = !textVisible.value;
    });

    textSlideController.forward();

    zoomYellowController.forward();

    zoomTextController.forward();

    slideController.forward().then((_) {
      zoomController.forward().then((_) {
        textVisible.value = false;
      });
    });

    Future.delayed(const Duration(seconds: 5), () {
      showAnimatedBuilder = true;
      animationController.forward();
    });
  }

  void setAnimations(double screenWidth, double screenHeight) {
    widthAnimation =
        Tween<double>(begin: 0, end: screenWidth).animate(animationController);
    heightAnimation =
        Tween<double>(begin: 0, end: screenHeight).animate(animationController);
  }

  @override
  void onClose() {
    zoomTextController.dispose();
    zoomController.dispose();
    slideController.dispose();
    zoomYellowController.dispose();
    animationController.dispose();
    super.onClose();
  }

  Color _generateRandomColor() {
    return Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      1,
    );
  }

  Offset _getRandomOffset() {
    Random random = Random();
    int randomNumber = random.nextInt(4);
    switch (randomNumber) {
      case 0:
        lastPosition = LastPosition.leftRight;
        return const Offset(-1.0, 0.0);
      case 1:
        lastPosition = LastPosition.leftRight;
        return const Offset(1.0, 0.0);
      case 2:
        lastPosition = LastPosition.topBottom;
        return const Offset(0.0, -1.0);
      case 3:
        lastPosition = LastPosition.topBottom;
        return const Offset(0.0, 1.0);
      default:
        return Offset.zero;
    }
  }

  ShapeType _getRandomShape() {
    Random random = Random();
    int randomNumber = random.nextInt(3);
    switch (randomNumber) {
      case 0:
        return ShapeType.circle;
      case 1:
        return ShapeType.rectangle;
      case 2:
        return ShapeType.diamond;
      default:
        return ShapeType.circle;
    }
  }
}

class DiamondBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0.0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final double w = rect.width;
    final double h = rect.height;
    return Path()
      ..moveTo(w / 2, 0)
      ..lineTo(w, h / 2)
      ..lineTo(w / 2, h)
      ..lineTo(0, h / 2)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => DiamondBorder();
}
