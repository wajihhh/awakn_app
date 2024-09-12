import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum LastPosition {
  topBottom,
  leftRight,
}

enum ShapeType {
  circle,
  rectangle,
  diamond,
}

class SlideAnimation extends StatefulWidget {
  const SlideAnimation({Key? key}) : super(key: key);

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with TickerProviderStateMixin {
  late AnimationController zoomController;
  late Animation<double> zoomAnimation;
  late AnimationController slideController;
  late AnimationController zoomYellowController;
  late Animation<double> zoomYellowAnimation;

  late Animation<Offset> slideAnimation;
  late AnimationController animationController;
  late Animation<double> widthAnimation;
  late Animation<double> heightAnimation;
  late AnimationController textSlideController;
  late AnimationController _opacityController;

  late Animation<Offset> textSlideAnimation;
  late Color randomColor;
  late double randomTop;
  late double randomBottom;
  late bool _textVisible = false; // Define the boolean variable


  double yellowContainer = 130;
  // late ImageProvider _backgroundImage;
  bool showAnimatedBuilder = false;
  // bool showText = false;
  late double screenWidth;
  late double screenHeight;
  late ShapeType currentShape;

  LastPosition lastPosition = LastPosition.topBottom;

  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Set the duration of the opacity animation
    );
    _opacityController.forward();
    _opacityController.addListener(() {
      setState(() {
        // Update the visibility of the text based on the opacity animation value
        _textVisible = _opacityController.value == 1.0;
      });
    });
    randomColor = _generateRandomColor();
    randomTop = Random().nextDouble();
    randomBottom = Random().nextDouble();
    textSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    // Offset randomOffset = _getRandomOffset();

    textSlideAnimation = Tween<Offset>(
            // begin: _getRandomOffset(),
            begin: const Offset(0.0, 0.03),
            end: Offset.zero)
        .animate(
      CurvedAnimation(
        // reverseCurve: Curves.bounceIn,
        parent: textSlideController,
        curve: Curves.easeInOut,
      ),
    );
    textSlideController.forward();
    textSlideController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        textSlideController.repeat(
          reverse: true,
        ); // Reverse the animation after completing
      }
    });

    zoomController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    );
    zoomAnimation = Tween<double>(begin: 1.0, end: 2.5).animate(
      CurvedAnimation(
        parent: zoomController,
        curve: Curves.decelerate,
      ),
    );
    zoomYellowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10),
    );
    zoomYellowAnimation = Tween<double>(begin: 1.0, end: 2.5).animate(
      CurvedAnimation(
        parent: zoomYellowController,
        curve: Curves.decelerate,
      ),
    );
    zoomYellowController.forward();

    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    slideAnimation = Tween<Offset>(
      begin: _getRandomOffset(),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: slideController,
        curve: Curves.easeInOut,
      ),
    );

    slideController.forward().then((_) {
      zoomController.forward();
    });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animationController.addListener(() {
      setState(() {});
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showAnimatedBuilder = true;
        });
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.stop();
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        showAnimatedBuilder = true;
      });
      animationController.forward();
    });
    // Future.delayed(const Duration(seconds: 1), () {
    //   setState(() {
    //     showText = true;
    //   });
    //   // animationController.forward();
    // });
  }

  @override
  void dispose() {
    zoomController.dispose();
    textSlideController.dispose();
    zoomYellowController.dispose();

    slideController.dispose();
    animationController.dispose();
    super.dispose();
  }

  // Offset _getRandomOffset() {
  //   Random random = Random();
  //   int randomNumber = random.nextInt(4);
  //   switch (randomNumber) {
  //     case 0:
  //       return Offset(-1.0, 0.0); // Slide from left
  //     case 1:
  //       return Offset(1.0, 0.0); // Slide from right
  //     case 2:
  //       return Offset(0.0, -1.0); // Slide from top
  //     case 3:
  //       return Offset(0.0, 1.0); // Slide from bottom
  //     default:
  //       return Offset.zero;
  //   }
  // }

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
        return const Offset(-1.0, 0.0); // Slide from left
      case 1:
        lastPosition = LastPosition.leftRight;
        return const Offset(1.0, 0.0); // Slide from right
      case 2:
        lastPosition = LastPosition.topBottom;
        return const Offset(0.0, -1.0); // Slide from top
      case 3:
        lastPosition = LastPosition.topBottom;
        return const Offset(0.0, 1.0); // Slide from bottom
      default:
        return Offset.zero;
    }
  }

  // Offset getRandomPosition() {
  //   Random random = Random();
  //   return random.nextBool() ? Offset(0.0, 1.0) : Offset(1.0, 0.0);
  // }

  bool shouldOpenFromTop() {
    Random random = Random();
    return random.nextBool();
  }

  void _randomizeShape() {
    setState(() {
      final random = Random();
      currentShape = ShapeType.values[random.nextInt(ShapeType.values.length)];
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    // double beginWidth =
    //     MediaQuery.of(context).orientation == Orientation.portrait
    //         ? 130.0
    //         : 170.0;
    // double beginHeight =
    //     MediaQuery.of(context).orientation == Orientation.portrait ? 40 : 50;

    widthAnimation = Tween<double>(begin: 0, end: screenWidth).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    heightAnimation = Tween<double>(begin: 0, end: screenHeight).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double fontSize = isPortrait ? 28.0 : 35.0;

    return Scaffold(
      backgroundColor: const Color(0xff01061fff),
      body: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              // Adjust opacity and color to control dullness
              BlendMode.darken,
            ),
            child: AnimatedBuilder(
              animation: zoomController,
              builder: (context, child) {
                return AnimatedBuilder(
                  animation: slideController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: zoomAnimation.value,
                      child: SlideTransition(
                        position: slideAnimation,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/12.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          if (showAnimatedBuilder)
            // Center(
            //   child: AnimatedBuilder(
            //     animation: zoomYellowController,
            //     builder: (context, child) {
            //       return Transform.scale(
            //         scale: zoomYellowAnimation.value,
            //         child: CustomPaint(
            //           size: Size(widthAnimation.value, heightAnimation.value),
            //           painter: DiamondPainter(color: randomColor.withOpacity(0.8)),
            //         ),
            //       );
            //     },
            //   ),
            // ),

          Positioned(
            top: randomTop < 0.5 ? 1 : null,
            bottom: randomBottom >= 0.5 ? 1 : null,
            left: randomTop >= 0.5 ? 1 : null,
            right: randomBottom < 0.5 ? 1 : null,
            child: AnimatedBuilder(
              animation: zoomYellowController,
              builder: (context, child) {
                return Transform.scale(
                  scale: zoomYellowAnimation.value,
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: randomColor.withOpacity(0.8)),
                        width: widthAnimation.value,
                        height: heightAnimation.value,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          // if (showAnimatedBuilder)
          //   Positioned(
          //     top: randomTop < 0.5 ? 1 : null,
          //     bottom: randomBottom >= 0.5 ? 1 : null,
          //     left: randomTop >= 0.5 ? 1 : null,
          //     right: randomBottom < 0.5 ? 1 : null,
          //     child: AnimatedBuilder(
          //       animation: animationController,
          //       builder: (context, child) {
          //         return Container(
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //
          //             color: randomColor.withOpacity(0.9),
          //           ),
          //           width: widthAnimation.value,
          //           height: heightAnimation.value,
          //         );
          //       },
          //     ),
          //   ),
          // if(showText)
          Center(
            child: AnimatedBuilder(
              animation: textSlideController,
              builder: (context, child) {
                return SlideTransition(
                  position: textSlideAnimation,
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 100.0, right: 100),
                        child: AnimatedOpacity(
                          opacity: _textVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 1000), // Set the duration of the opacity animation
                          child: Text(
                            'Perfection Is Not Attainable, But If We Chase Perfection, We Can Catch Excellence.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Rowdies',
                                color: Colors.white,
                                fontSize: fontSize),
                          ),
                        )),
                  ),
                );
              },
            ),
          ),

          Positioned.fill(
            child: Column(
              children: [
                SizedBox(
                    height: isPortrait
                        ? MediaQuery.of(context).size.height * 0.8
                        : MediaQuery.of(context).size.height * 0.6,
                ),
                const Spacer(
                  flex: 1,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/like.svg'),
                      SizedBox(
                        width: isPortrait ? 20 : 40,
                      ),
                      AnimatedOpacity(
                        opacity: animationController.status ==
                                AnimationStatus.forward
                            ? 1.0
                            : 0.0,
                        duration: const Duration(milliseconds: 1000),
                        child: Text(
                          'Follow Your Dreams',
                          style: TextStyle(
                              fontFamily: 'Rowdies',
                              color: Colors.white,
                              fontSize: isPortrait ? 20 : 25),
                        ),
                      ),
                      SizedBox(
                        width: isPortrait ? 20 : 40,
                      ),
                      SvgPicture.asset('assets/dislike.svg'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DiamondPainter extends CustomPainter {
  final Color color;

  DiamondPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;

    Path path = Path();
    path.moveTo(size.width / 2, 0); // Move to top center
    path.lineTo(size.width, size.height / 2); // Line to right middle
    path.lineTo(size.width / 2, size.height); // Line to bottom center
    path.lineTo(0, size.height / 2); // Line to left middle
    path.close(); // Close the path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}



//import 'dart:async';
// import 'dart:math';
//
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:testing/animation/slide_animation.dart';
//
// import '../text.dart';
//
// enum Shape { Diamond, Circle, Rectangle }
//
// class DotAnimation extends StatefulWidget {
//   const DotAnimation({Key? key}) : super(key: key);
//
//   @override
//   State<DotAnimation> createState() => _DotAnimationState();
// }
//
// class _DotAnimationState extends State<DotAnimation>
//     with TickerProviderStateMixin {
//   // late AnimationController zoomController;
//   // late Animation<double> zoomAnimation;
//   late AnimationController zoomController;
//   late AnimationController zoomYellowController;
//   late AnimationController zoomTextController;
//   late Animation<double> zoomAnimation;
//   late Animation<double> zoomYellowAnimation;
//   late Animation<double> zoomTextAnimation;
//   late Animation<double> widthAnimation;
//   late Color randomColor;
//
//   late Animation<double> heightAnimation;
//   late Animation<double> opacityAnimation;
//   late AnimationController textSlideController;
//   late Animation<Offset> textSlideAnimation;
//
//   late Animation<double> textSizeAnimation;
//   late double randomTop;
//   late double randomBottom;
//   late bool _textVisible = true; // Define the boolean variable
//
//   // New animation for opacity
//   late AnimationController slideController;
//
//   // late AnimationController slideTextController;
//   late Shape selectedShape;
//
//   late Animation<Offset> slideAnimation;
//
//   // late Animation<Offset> slideTextAnimation;
//   late AnimationController animationController;
//   late double screenWidth;
//   late double screenHeight;
//   double yellowContainer = 130;
//   double textSize = 30.0;
//   late ImageProvider _backgroundImage;
//   bool showAnimatedBuilder = false; // Add a flag to control the visibility
//   bool showText = false; // Add a flag to control the visibility
//   LastPosition lastPosition = LastPosition.TopBottom;
//
//   @override
//   void initState() {
//     super.initState();
//     randomTop = Random().nextDouble();
//     randomBottom = Random().nextDouble();
//     randomColor = _generateRandomColor();
//     Timer.periodic(Duration(seconds: 3), (Timer timer) {
//       setState(() {
//         _textVisible = !_textVisible;
//       });
//     });
//
//
//     textSlideController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds:2000),
//     );
//     Offset randomOffset = _getRandomOffset();
//
//     textSlideAnimation = Tween<Offset>(
//             begin: _getRandomOffset(),
//             // begin: Offset(0.0, 0.1),
//             end: Offset.zero)
//         .animate(
//       CurvedAnimation(
//         // reverseCurve: Curves.bounceIn,
//         parent: textSlideController,
//         curve: Curves.easeInOut,
//       ),
//     );
//     textSlideController.forward();
//     textSlideController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         // textSlideController.repeat(
//         //   // reverse: true,
//         // ); // Reverse the animation after completing
//       }
//     });
//     // sizeAnimation = Tween<double>(begin: 10, end: 130).animate(
//     //   CurvedAnimation(
//     //     parent: animationController,
//     //     curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
//     //   ),
//     // );
//     selectedShape = _getRandomShape();
//
//     zoomController = AnimationController(
//       vsync: this,
//       duration: Duration(minutes: 3),
//     );
//     zoomAnimation = Tween<double>(begin: 1.0, end: 3.4).animate(
//       CurvedAnimation(
//         parent: zoomController,
//         curve: Curves.decelerate,
//       ),
//     );
//     zoomYellowController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 10),
//     );
//     zoomYellowAnimation = Tween<double>(begin: 1.0, end: 2.5).animate(
//       CurvedAnimation(
//         parent: zoomYellowController,
//         curve: Curves.decelerate,
//       ),
//     );
//     zoomYellowController.forward();
//
//
//
//     zoomTextController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 7),
//     );
//     zoomTextAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
//       CurvedAnimation(
//         parent: zoomTextController,
//         curve: Curves.easeIn,
//       ),
//     );
//     zoomTextController.forward();
//
//     // slideTextController = AnimationController(
//     //   vsync: this,
//     //   duration: Duration(milliseconds: 100),
//     // );
//     //
//     // slideTextAnimation = Tween<Offset>(
//     //   begin: Offset(-1.0, 0.0),
//     //   end: Offset.zero,
//     // ).animate(
//     //   CurvedAnimation(
//     //     parent: slideController,
//     //     curve: Curves.easeInOut,
//     //   ),
//     // );
//     // slideTextController.forward().then((_) {
//     //   // Start zoom animation after slide animation completes
//     //   zoomController.forward();
//     // });
//
//     slideController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1000),
//     );
//
//     slideAnimation = Tween<Offset>(
//       begin: Offset(-1.0, 0.0),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: slideController,
//         curve: Curves.easeInOut,
//       ),
//     );
//     slideController.forward().then((_) {
//       // zoomController.forward().then((_) {
//       //   // Set _textVisible to false when the zoom animation on the text ends
//       //   setState(() {
//       //     _textVisible = false;
//       //   });
//       // });
//     });
//     // zoomController.forward();
//
//     animationController =
//         AnimationController(vsync: this, duration: Duration(seconds: 2));
//     textSizeAnimation = Tween<double>(begin: 30.0, end: 60.0).animate(
//       CurvedAnimation(
//         parent: animationController,
//         curve: Curves.easeInOut, // Adjust curve as needed
//       ),
//     );
//
//     animationController.addListener(() {
//       setState(() {});
//     });
//
//     animationController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         setState(() {
//           // Increase text size after animation completes
//           textSize = 60.0;
//         });
//         Future.delayed(Duration(seconds: 1), () {
//           setState(() {
//             showAnimatedBuilder = true;
//           });
//           animationController.reverse();
//         });
//         Future.delayed(Duration(milliseconds: 100), () {
//           setState(() {
//             showText = true;
//           });
//         });
//       } else if (status == AnimationStatus.dismissed) {
//         // setState(() {
//         //   textSize = 30;
//         // });
//         animationController.stop();
//       }
//     });
//     //start animation
//     Future.delayed(Duration(seconds: 4), () {
//       setState(() {
//         showAnimatedBuilder = true;
//       });
//       animationController.forward();
//     });
//
//     // Start the animations
//
//     // Initialize opacity animation
//     // opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
//     //   CurvedAnimation(
//     //     parent: animationController,
//     //     curve: Interval(0.5, 1.0, curve: Curves.easeInOutCubicEmphasized), // Adjust timing
//     //   ),
//     // );
//     // animationController.forward();
//
//     // _backgroundImage = AssetImage('assets/cyclist-riding-on-the-rocky-riverside-2023-11-27-05-18-53-utc.jpg');
//     // precacheImage(_backgroundImage, context);
//   }
//
//   Shape _getRandomShape() {
//     final shapes = Shape.values;
//     final random = Random();
//     return shapes[random.nextInt(shapes.length)];
//   }
//
//   @override
//   void dispose() {
//     zoomTextController.dispose();
//     zoomController.dispose();
//     slideController.dispose();
//     // slideTextController.dispose();
//     zoomYellowController.dispose();
//
//     animationController.dispose();
//     super.dispose();
//   }
//
//   Color _generateRandomColor() {
//     return Color.fromRGBO(
//       Random().nextInt(256),
//       Random().nextInt(256),
//       Random().nextInt(256),
//       1,
//     );
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     screenWidth = MediaQuery.of(context).size.width;
//     screenHeight = MediaQuery.of(context).size.height;
//     double beginWidth =
//         MediaQuery.of(context).orientation == Orientation.portrait
//             ? 130.0
//             : 170.0;
//     double beginHeight =
//         MediaQuery.of(context).orientation == Orientation.portrait ? 40 : 50;
//
//     widthAnimation = Tween<double>(begin: 0, end: screenWidth).animate(
//       CurvedAnimation(
//         parent: animationController,
//         curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
//       ),
//     );
//
//     heightAnimation = Tween<double>(begin: 0, end: screenHeight).animate(
//       CurvedAnimation(
//         parent: animationController,
//         curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
//       ),
//     );
//   }
//
//   Offset _getRandomOffset() {
//     Random random = Random();
//     int randomNumber = random.nextInt(4);
//     switch (randomNumber) {
//       case 0:
//         lastPosition = LastPosition.LeftRight;
//         return const Offset(-1.0, 0.0); // Slide from left
//       case 1:
//         lastPosition = LastPosition.LeftRight;
//         return const Offset(1.0, 0.0); // Slide from right
//       case 2:
//         lastPosition = LastPosition.TopBottom;
//         return const Offset(0.0, -1.0); // Slide from top
//       case 3:
//         lastPosition = LastPosition.TopBottom;
//         return const Offset(0.0, 1.0); // Slide from bottom
//       default:
//         return Offset.zero;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool isPortrait =
//         MediaQuery.of(context).orientation == Orientation.portrait;
//     double fontSize = isPortrait ? 28.0 : 30.0;
//
//     return Scaffold(
//       backgroundColor: Color(0xff01061FFF),
//       body: Stack(
//         children: [
//           ColorFiltered(
//             colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0.4),
//               // Adjust opacity and color to control dullness
//               BlendMode.darken,
//             ),
//             child: AnimatedBuilder(
//               animation: zoomController,
//               builder: (context, child) {
//                 return AnimatedBuilder(
//                   animation: slideController,
//                   builder: (context, child) {
//                     return Transform.scale(
//                       scale: zoomAnimation.value,
//                       child: SlideTransition(
//                         position: slideAnimation,
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: MediaQuery.of(context).size.height,
//                           decoration: const BoxDecoration(
//                             image: DecorationImage(
//                               image: AssetImage(
//                                   'assets/img2.png'),
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           // Center(
//           //   child: Positioned(
//           //
//
//           if (showAnimatedBuilder)
//             Positioned(
//               top: randomTop < 0.5 ? 1 : null,
//               bottom: randomBottom >= 0.5 ? 1 : null,
//               left: randomTop >= 0.5 ? 1 : null,
//               right: randomBottom < 0.5 ? 1 : null,
//               child: AnimatedBuilder(
//                 animation: zoomYellowController,
//                 builder: (context, child) {
//                   return Transform.scale(
//                     scale: zoomYellowAnimation.value,
//                     child: AnimatedBuilder(
//                       animation: animationController,
//                       builder: (context, child) {
//                         return SizedBox(
//                             width: widthAnimation.value,
//                             height: heightAnimation.value,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: randomColor.withOpacity(0.8),
//                                   shape: BoxShape.rectangle),
//                             ));
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           //     child: AnimatedBuilder(
//           //       animation: animationController,
//           //       builder: (context, child) {
//           //         return Container(
//           //           decoration: BoxDecoration(
//           //             color: Color(0xfffdd248),
//           //             shape: BoxShape.circle,
//           //             // borderRadius: BorderRadius.circular(80)
//           //           ),
//           //           width: widthAnimation.value,
//           //           height: heightAnimation.value,
//           //         );
//           //       },
//           //     ),
//           //   ),
//           // ),
//           // if(showText)
//
//           AnimatedBuilder(
//             animation: zoomTextController,
//             builder: (context, child) {
//               return AnimatedBuilder(
//                 animation: textSlideController,
//                 builder: (context, child) {
//                   return Transform.scale(
//                     scale: zoomTextAnimation.value,
//                     child: SlideTransition(
//                       position: textSlideAnimation,
//                       child: Center(
//                     child: Padding(
//                     padding: const EdgeInsets.only(left: 100.0, right: 100),
//                     child: AnimatedOpacity(
//                       duration: Duration(milliseconds: 3000), // Set the duration of the opacity animation
//                       opacity: _textVisible ? 1.0 : 0.2,
//                       child: DefaultTextStyle(
//                         style: TextStyle(fontSize: fontSize, fontFamily: 'Rowdies'),
//                         child: AnimatedTextKit(
//                           totalRepeatCount: 1,
//                           animatedTexts: [
//                             TyperAnimatedText(
//                               'Mindset Is What Separates The Rest From The Rest',
//                               textAlign: TextAlign.center,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   ),
//
//                   ),
//                   );
//                 },
//               );
//             },
//           ),
//           // AnimatedBuilder(
//           //   animation: textSlideController,
//           //   builder: (context, child) {
//           //     return Transform.scale(
//           //       scale: zoomTextAnimation.value,
//           //       child: SlideTransition(
//           //         position: textSlideAnimation,
//           //         child: Center(
//           //           child: Padding(
//           //             padding: const EdgeInsets.only(left: 100.0, right: 100),
//           //             child: AnimatedOpacity(
//           //               duration: Duration(milliseconds: 3000), // Set the duration of the opacity animation
//           //               opacity: _textVisible ? 1.0 : 0.2,
//           //               child: DefaultTextStyle(
//           //                 style: TextStyle(fontSize: fontSize, fontFamily: 'Rowdies'),
//           //                 child: AnimatedTextKit(
//           //                   totalRepeatCount: 1,
//           //                   animatedTexts: [
//           //                     TyperAnimatedText(
//           //                       'Winners Never Quit And Quitters Never Win',
//           //                       textAlign: TextAlign.center,
//           //                     ),
//           //                   ],
//           //                 ),
//           //               ),
//           //             ),
//           //           ),
//           //         ),
//           //       ),
//           //     );
//           //   },
//           // ),
//
//           // Center(
//           //   child: Padding(
//           //     padding: const EdgeInsets.only(left: 100,right: 100),
//           //     child: DefaultTextStyle(
//           //         style: TextStyle(
//           //           fontSize: fontSize,
//           //           fontFamily: 'Bobbers',
//           //         ),
//           //         child: AnimatedTextKit(
//           //           totalRepeatCount: 1,
//           //           animatedTexts: [
//           //             RotateAnimatedText(
//           //               rotateOut: false,
//           //               'Believe In Yourself Believe In Yourself Believe In Yourself Believe In Yourself Believe In Yourself',
//           //               textAlign: TextAlign.center,
//           //             ),
//           //           ],
//           //         )),
//           //   ),
//           // ),
//           Positioned.fill(
//             child: Column(
//               children: [
//                 SizedBox(
//                     height: isPortrait
//                         ? MediaQuery.of(context).size.height * 0.8
//                         : MediaQuery.of(context).size.height * 0.6),
//                 const Spacer(
//                   flex: 1,
//                 ),
//                 Padding(
//                   padding:
//                       const EdgeInsets.only(left: 8.0, right: 8, bottom: 40),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset('assets/like.svg'),
//                       SizedBox(
//                         width: isPortrait ? 20 : 40,
//                       ),
//                       AnimatedOpacity(
//                         opacity: animationController.status ==
//                                 AnimationStatus.forward
//                             ? 1.0
//                             : 0.0,
//                         duration: const Duration(milliseconds: 1000),
//                         child: Text(
//                           'Never Give Up',
//                           style: TextStyle(
//                               fontFamily: 'Rowdies',
//                               color: Colors.white,
//                               fontSize: isPortrait ? 20 : 25),
//                         ),
//                       ),
//                       SizedBox(
//                         width: isPortrait ? 20 : 40,
//                       ),
//                       SvgPicture.asset('assets/dislike.svg'),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class DiamondPainter extends CustomPainter {
//   final Color color;
//
//   DiamondPainter({required this.color});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..color = color;
//
//     Path path = Path();
//     path.moveTo(size.width / 2, 0); // Move to top center
//     path.lineTo(size.width, size.height / 2); // Line to right middle
//     path.lineTo(size.width / 2, size.height); // Line to bottom center
//     path.lineTo(0, size.height / 2); // Line to left middle
//     path.close(); // Close the path
//
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
//
// //import 'dart:math';
// // import 'package:animated_text_kit/animated_text_kit.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// // enum LastPosition {
// //   TopBottom,
// //   LeftRight,
// // }
// //
// // class SlideAnimation extends StatefulWidget {
// //   const SlideAnimation({Key? key}) : super(key: key);
// //
// //   @override
// //   State<SlideAnimation> createState() => _SlideAnimationState();
// // }
// //
// // class _SlideAnimationState extends State<SlideAnimation>
// //     with TickerProviderStateMixin {
// //   late AnimationController zoomController;
// //   late Animation<double> zoomAnimation;
// //   late AnimationController slideController;
// //   late AnimationController zoomYellowController;
// //   late Animation<double> zoomYellowAnimation;
// //
// //
// //   late Animation<Offset> slideAnimation;
// //   late AnimationController animationController;
// //   late Animation<double> widthAnimation;
// //   late Animation<double> heightAnimation;
// //   late AnimationController textSlideController;
// //   late Animation<Offset> textSlideAnimation;
// //   late Color randomColor;
// //   late double randomTop;
// //   late double randomBottom;
// //
// //   double yellowContainer = 130;
// //   late ImageProvider _backgroundImage;
// //   bool showAnimatedBuilder = false;
// //   late double screenWidth;
// //   late double screenHeight;
// //   LastPosition lastPosition = LastPosition.TopBottom;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     randomColor = _generateRandomColor();
// //     randomTop = Random().nextDouble();
// //     randomBottom = Random().nextDouble();
// //     textSlideController = AnimationController(
// //       vsync: this,
// //       duration: Duration(milliseconds: 1000),
// //     );
// //     Offset randomOffset = _getRandomOffset();
// //
// //     textSlideAnimation = Tween<Offset>(
// //       begin: Offset(0.0, 0.06),
// //       end: Offset.zero
// //     ).animate(
// //       CurvedAnimation(
// //         parent: textSlideController,
// //         curve: Curves.easeInOut,
// //       ),
// //     );
// //     textSlideController.forward();
// //     textSlideController.addStatusListener((status) {
// //       if (status == AnimationStatus.completed) {
// //         textSlideController.repeat(reverse: true,); // Reverse the animation after completing
// //       }
// //     });
// //
// //
// //
// //
// //
// //     zoomController = AnimationController(
// //       vsync: this,
// //       duration: Duration(seconds: 50),
// //     );
// //     zoomAnimation = Tween<double>(begin: 1.0, end: 2.5).animate(
// //       CurvedAnimation(
// //         parent: zoomController,
// //         curve: Curves.decelerate,
// //       ),
// //     );
// //     zoomYellowController = AnimationController(
// //       vsync: this,
// //       duration: Duration(milliseconds: 10),
// //     );
// //     zoomYellowAnimation = Tween<double>(begin: 1.0, end: 2.5).animate(
// //       CurvedAnimation(
// //         parent: zoomYellowController,
// //         curve: Curves.decelerate,
// //       ),
// //     );
// //     zoomYellowController.forward();
// //
// //     slideController = AnimationController(
// //       vsync: this,
// //       duration: Duration(milliseconds: 1000),
// //     );
// //
// //     slideAnimation = Tween<Offset>(
// //       begin: _getRandomOffset(),
// //       end: Offset.zero,
// //     ).animate(
// //       CurvedAnimation(
// //         parent: slideController,
// //         curve: Curves.easeInOut,
// //       ),
// //     );
// //
// //     slideController.forward().then((_) {
// //       zoomController.forward();
// //     });
// //
// //     animationController = AnimationController(
// //       vsync: this,
// //       duration: Duration(seconds: 2),
// //     );
// //
// //     animationController.addListener(() {
// //       setState(() {});
// //     });
// //
// //     animationController.addStatusListener((status) {
// //       if (status == AnimationStatus.completed) {
// //         setState(() {
// //           showAnimatedBuilder = true;
// //         });
// //         animationController.reverse();
// //       } else if (status == AnimationStatus.dismissed) {
// //         animationController.stop();
// //       }
// //     });
// //
// //     Future.delayed(Duration(seconds: 1), () {
// //       setState(() {
// //         showAnimatedBuilder = true;
// //       });
// //       animationController.forward();
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     zoomController.dispose();
// //     textSlideController.dispose();
// //     zoomYellowController.dispose();
// //
// //     slideController.dispose();
// //     animationController.dispose();
// //     super.dispose();
// //   }
// //
// //   // Offset _getRandomOffset() {
// //   //   Random random = Random();
// //   //   int randomNumber = random.nextInt(4);
// //   //   switch (randomNumber) {
// //   //     case 0:
// //   //       return Offset(-1.0, 0.0); // Slide from left
// //   //     case 1:
// //   //       return Offset(1.0, 0.0); // Slide from right
// //   //     case 2:
// //   //       return Offset(0.0, -1.0); // Slide from top
// //   //     case 3:
// //   //       return Offset(0.0, 1.0); // Slide from bottom
// //   //     default:
// //   //       return Offset.zero;
// //   //   }
// //   // }
// //
// //   Color _generateRandomColor() {
// //     return Color.fromRGBO(
// //       Random().nextInt(256),
// //       Random().nextInt(256),
// //       Random().nextInt(256),
// //       1,
// //     );
// //   }
// //   Offset _getRandomOffset() {
// //     Random random = Random();
// //     int randomNumber = random.nextInt(4);
// //     switch (randomNumber) {
// //       case 0:
// //         lastPosition = LastPosition.LeftRight;
// //         return Offset(-1.0, 0.0); // Slide from left
// //       case 1:
// //         lastPosition = LastPosition.LeftRight;
// //         return Offset(1.0, 0.0); // Slide from right
// //       case 2:
// //         lastPosition = LastPosition.TopBottom;
// //         return Offset(0.0, -1.0); // Slide from top
// //       case 3:
// //         lastPosition = LastPosition.TopBottom;
// //         return Offset(0.0, 1.0); // Slide from bottom
// //       default:
// //         return Offset.zero;
// //     }
// //   }
// //
// //
// //   // Offset getRandomPosition() {
// //   //   Random random = Random();
// //   //   return random.nextBool() ? Offset(0.0, 1.0) : Offset(1.0, 0.0);
// //   // }
// //
// //   bool shouldOpenFromTop() {
// //     Random random = Random();
// //     return random.nextBool();
// //   }
// //
// //   @override
// //   void didChangeDependencies() {
// //     super.didChangeDependencies();
// //     screenWidth = MediaQuery.of(context).size.width;
// //     screenHeight = MediaQuery.of(context).size.height;
// //     double beginWidth =
// //     MediaQuery.of(context).orientation == Orientation.portrait
// //         ? 130.0
// //         : 170.0;
// //     double beginHeight =
// //     MediaQuery.of(context).orientation == Orientation.portrait ? 40 : 50;
// //
// //     widthAnimation = Tween<double>(begin: 0, end: screenWidth).animate(
// //       CurvedAnimation(
// //         parent: animationController,
// //         curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
// //       ),
// //     );
// //
// //     heightAnimation = Tween<double>(begin: 0, end: screenHeight).animate(
// //       CurvedAnimation(
// //         parent: animationController,
// //         curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     bool isPortrait =
// //         MediaQuery.of(context).orientation == Orientation.portrait;
// //     double fontSize = isPortrait ? 28.0 : 40.0;
// //
// //     return Scaffold(
// //       backgroundColor: Color(0xff01061FFF),
// //       body: Stack(
// //         children: [
// //           AnimatedBuilder(
// //             animation: zoomController,
// //             builder: (context, child) {
// //               return AnimatedBuilder(
// //                 animation: slideController,
// //                 builder: (context, child) {
// //                   return Transform.scale(
// //                     scale: zoomAnimation.value,
// //                     child: SlideTransition(
// //                       position: slideAnimation,
// //                       child: Container(
// //                         width: MediaQuery.of(context).size.width,
// //                         height: MediaQuery.of(context).size.height,
// //                         decoration: BoxDecoration(
// //                           image: DecorationImage(
// //                             image: AssetImage(
// //                                 'assets/snowboarder-is-jumping-with-snowboard-from-snowhil-2023-11-27-05-15-29-utc.png'),
// //                             fit: BoxFit.fill,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               );
// //             },
// //           ),
// //
// //           if (showAnimatedBuilder)
// //             Positioned(
// //               top: randomTop < 0.5 ? 1 : null,
// //               bottom: randomBottom >= 0.5 ? 1 : null,
// //               left: randomTop >= 0.5 ? 1 : null,
// //               right: randomBottom < 0.5 ? 1 : null,
// //               child: AnimatedBuilder(
// //                 animation: zoomYellowController,
// //                 builder: (context, child) {
// //                   return Transform.scale(
// //                     scale: zoomYellowAnimation.value,
// //                     child: AnimatedBuilder(
// //                       animation: animationController,
// //                       builder: (context, child) {
// //                         return SizedBox(
// //                             width: widthAnimation.value,
// //                             height: heightAnimation.value,
// //                             child: Container(
// //                               decoration: BoxDecoration(
// //                                   color: randomColor,
// //                                   shape: BoxShape.rectangle),
// //                             ));
// //                       },
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           // if (showAnimatedBuilder)
// //           //   Positioned(
// //           //     top: randomTop < 0.5 ? 1 : null,
// //           //     bottom: randomBottom >= 0.5 ? 1 : null,
// //           //     left: randomTop >= 0.5 ? 1 : null,
// //           //     right: randomBottom < 0.5 ? 1 : null,
// //           //     child: AnimatedBuilder(
// //           //       animation: animationController,
// //           //       builder: (context, child) {
// //           //         return Container(
// //           //           decoration: BoxDecoration(
// //           //             shape: BoxShape.circle,
// //           //
// //           //             color: randomColor.withOpacity(0.9),
// //           //           ),
// //           //           width: widthAnimation.value,
// //           //           height: heightAnimation.value,
// //           //         );
// //           //       },
// //           //     ),
// //           //   ),
// //
// //
// //           Center(
// //             child: AnimatedBuilder(
// //               animation: textSlideController,
// //               builder: (context,child){
// //                 return SlideTransition(position: textSlideAnimation,child: child);
// //               },
// //               child:Center(
// //                 child: Padding(
// //                   padding: const EdgeInsets.only(left: 100.0,right: 100),
// //                   child: DefaultTextStyle(
// //                       style: TextStyle(
// //                         fontSize: fontSize,
// //                         fontFamily: 'Bobbers',
// //                       ),
// //                       child: AnimatedTextKit(
// //                         // repeatForever: true,
// //                         totalRepeatCount: 1,
// //                         animatedTexts: [
// //
// //                           RotateAnimatedText(
// //
// //
// //                             rotateOut: false,
// //                             'Believe In Yourslef Yourslef Believe In Yourslef Believe In YourslefBelieve In YourslefBelieve In Yourslef' ,
// //                             textAlign: TextAlign.center,
// //                           ),
// //                         ],
// //                       )),
// //                 ),
// //               ),
// //             ),
// //           ),
// //
// //           Positioned.fill(
// //             child: Column(
// //               children: [
// //                 SizedBox(
// //                     height: isPortrait
// //                         ? MediaQuery.of(context).size.height * 0.8
// //                         : MediaQuery.of(context).size.height * 0.7),
// //                 AnimatedOpacity(
// //                   opacity:
// //                   animationController.status == AnimationStatus.forward
// //                       ? 1.0
// //                       : 0.0,
// //                   duration: Duration(milliseconds: 1000),
// //                   child: Text(
// //                     'Follow Your Dreams',
// //                     style: TextStyle(
// //                         color: Colors.black, fontSize: isPortrait ? 20 : 25),
// //                   ),
// //                 ),
// //                 Spacer(
// //                   flex: 1,
// //                 ),
// //                 Padding(
// //                   padding:
// //                   const EdgeInsets.only(left: 8.0, right: 8, bottom: 40),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       SvgPicture.asset('assets/like.svg'),
// //                       SizedBox(
// //                         width: MediaQuery.of(context).size.width * 0.5,
// //                       ),
// //                       SvgPicture.asset('assets/dislike.svg'),
// //                     ],
// //                   ),
// //                 )
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }