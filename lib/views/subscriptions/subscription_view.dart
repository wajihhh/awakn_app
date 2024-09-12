import 'package:awakn/views/subscriptions/package_details.dart';
import 'package:awakn/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../theming/theme.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            Theme.of(context).brightness == Brightness.light
                ? 'assets/images/bg main l.png'
                : 'assets/images/bg main d.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(


          actions: [
            SvgPicture.asset("assets/images/Group 48189 (2).svg",

              color: Theme.of(context).brightness==Brightness.dark?Color(0xff9B9EE7):Color(0xffFFB800),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
          // leadingWidth: 30,
          titleSpacing: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text("Pick The Plans That Right For You!",
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Text(
              "Increase your prominence on our site",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontSize: 12),
              // style: TextStyle(fontSize: 12, color: Color(0xff8990A1)),
            ),
          ),
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.sp,
            ),
            Center(
              child: Container(
                  height: 214,
                  width: 338,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xffCDD2DE),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration:
                            Theme.of(context).brightness == Brightness.dark
                                ? const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6)),
                                    color: Color(0xff201C2E),
                                  )
                                : const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6)),
                                    color: Colors.transparent,
                                  ),

                        // margin: EdgeInsets.all(20),
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Free Trial",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20)),
                                  Text("\$ 0",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 30))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("7 Days",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                  Text("\$ 0/Month",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14
                                              // fontSize: 30
                                              ))
                                ],
                              ),
                              SizedBox(height: 10,),
                              Divider(color: Colors.white,)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0,right: 15,bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Features",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                            Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Color(0xff697CAC),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 40.sp,
                        width: 293.sp,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(
                            color: const Color(0xff697CAC),
                          ),
                          color: Colors.transparent,
                        ),
                        child: Center(
                          child: Text("Already subscribed to this package",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15)),
                        ),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 20.sp,
            ),
            Center(
              child: Container(
                  height: 214,
                  width: 338,
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xffCDD2DE))),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              // stops: [0.1, 0.9,0.3,0.9 ],

                              colors: [
                                // Colors.white,
                                Color(0xff87809D),
                                Color(0xff4A406C),
                                Color(0xff0E003A),
                                // Color(0xff0361F9)
                              ]

                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6)),
                          // color: Color(0xff201C2E),
                        ),

                        // margin: EdgeInsets.all(20),
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Platinum",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                                  ),
                                  Text("\$ 59",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 30))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "1 Month",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "\$ 59/Month",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Features",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                            Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Color(0xff697CAC),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(PackageDetail());
                        },
                        child: Container(
                          height: 40.sp,
                          width: 293.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            border: Border.all(
                              color: const Color(0xff697CAC),
                            ),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: Text("Select This Plan",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15)),
                          ),
                        ),
                      ),
                      // CustomButton(
                      //     text: 'Select This Plan',
                      //     textColor: Colors.white,
                      //     fontWeight: FontWeight.w500,
                      //     height: 40.sp,
                      //     width: 293.sp,
                      //     onTap: () {
                      //       Get.to(const PackageDetail());
                      //     }),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
