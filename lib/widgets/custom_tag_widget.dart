import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

class CustomTagWidget extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final String firstColor;
  final String secondColor;
  final bool isSelected;

  const CustomTagWidget({
    this.onTap,
    required this.text,
    required this.firstColor,
    required this.secondColor,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: isSelected
                ? Border.all(width: 2, color: Colors.blueAccent)
                : null,
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(colors: [
              HexColor(firstColor),
              HexColor(secondColor),
            ])),
        height: 30.sp,
        width: 70.sp,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 10.sp),
          ),
        )),
      ),
    );
  }
}
