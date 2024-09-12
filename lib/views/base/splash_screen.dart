import 'package:awakn/views/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../theming/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BaseController());
    return Container(
                 decoration: BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),

    child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/Asset 1 2.svg",
                // color: const Color(0xE66B46F6),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
