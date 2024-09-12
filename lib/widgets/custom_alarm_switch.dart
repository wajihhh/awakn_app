import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAlarmSwitch extends StatelessWidget {
  const CustomAlarmSwitch(
      {required this.value, required this.onTap, super.key});

  final bool value;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 50.sp,
            height: 25.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                  color: value
                      ? const Color(0xff6B46F6)
                      : const Color(0xffF59C30)),
              color: value ? const Color(0xff6B46F6) : const Color(0xffF59C30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!value)
                  // SizedBox(width: 2,),
                  const Center(
                      child: Icon(
                    CupertinoIcons.waveform,
                    size: 20,
                    color: Colors.white,
                  )),
                Container(
                  width: 20.sp,
                  height: 20.sp,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      // color: value ? Colors.white:Colors.white,
                      color: Colors.white),
                  // child: Center(

                  // child: Text(
                  //   value ? 'ON' : 'OFF',
                  //   style: TextStyle(
                  //     color: value ? Colors.greenAccent : Colors.redAccent,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // ),
                ),
                if (value)
                  const Icon(
                    CupertinoIcons.bell,
                    size: 20,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
        ),
        Text(
          value ? "Alarm" : "Exercise",
          style: TextStyle(
              color: value ? Colors.white : const Color(0xffF59C30),
              fontSize: 10),
        ),
      ],
    );
  }
}
