import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSwitchWithText extends StatelessWidget {
  const CustomSwitchWithText(
      {required this.value, required this.onTap, super.key});

  final bool value;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 51.sp,
        height: 25.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: const Color(0xff6B46F6)),
          color: !value ? const Color(0xff6B46F6) : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (value)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'on',
                  style: TextStyle(
                    color: Color(0xff6B46F6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                width: 20.sp,
                height: 20.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: !value ? Colors.white : const Color(0xff6B46F6),
                ),
              ),
            ),
            if (!value)
              const Padding(
                padding: EdgeInsets.only(right: 6.0),
                child: Text(
                  'off',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
