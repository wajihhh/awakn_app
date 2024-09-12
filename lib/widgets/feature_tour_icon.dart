import 'package:awakn/widgets/dialogUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeatureTour extends StatelessWidget {
  const FeatureTour({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          DialogUtils.showFeatureTourDialog(context);
        },
        child: SvgPicture.asset("assets/images/Group 48189 (2).svg",color: Theme.of(context).brightness==Brightness.light?Color(0xffFFB800):null,),);
  }
}
