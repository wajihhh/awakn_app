import 'package:alarm/model/alarm_settings.dart';
import 'package:awakn/views/alarm_trigger/reels/reel_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlarmTrigger extends StatefulWidget {
  final AlarmSettings alarmSettings;

  const AlarmTrigger({required this.alarmSettings, super.key});

  @override
  State<AlarmTrigger> createState() => _AlarmTriggerState();
}

class _AlarmTriggerState extends State<AlarmTrigger>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 200, end: 240).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Easing.emphasizedAccelerate,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {},
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                "assets/images/1.png",
              ),
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              // const SizedBox(height: 100,),
              const Positioned(
                top: 150,
                left: 90,
                right: 90,
                child: SizedBox(
                  child: Center(
                    child: Text(
                      "Good Morning",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 190,
                left: 90,
                right: 90,
                child: SizedBox(
                  child: Center(
                    child: Text(
                      "Steven!",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 600,
                left: 40,
                right: 40,
                child: SizedBox(
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          "Its bright shiny morning waiting for you to get up and enjoy.",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => const ReelsPage());
                          },
                          child: const Text(
                            "Start Reels",
                            style: TextStyle(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      width: _animation.value,
                      height: _animation.value,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        shape: BoxShape.circle,
                        color: Colors.white10,
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: Container(
                  height: 165,
                  width: 165,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/Subtract.png")),
                    borderRadius: BorderRadius.circular(90),
                    // color: Colors.yellow
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    color: const Color(0xff171132),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "9:00 am",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("Wake up", style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
