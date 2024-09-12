import 'package:awakn/models/alarm_response.dart';
import 'package:awakn/utils/global.dart';
import 'package:awakn/views/create_alarm/create_alarm_view.dart';
import 'package:awakn/views/home/home_view_model.dart';
import 'package:awakn/views/theming/time_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../widgets/custom_tag_widget.dart';
import '../theming/theme.dart';

class AlarmCardWidget extends StatelessWidget {
  const AlarmCardWidget({required this.alarm, super.key});

  final AlarmObject alarm;

  @override
  Widget build(BuildContext context) {
    final model = Get.find<HomeViewModel>();
    final dateTime = DateTime.parse(alarm.time ?? '');
    bool is24HoursFormat = MediaQuery.of(context).alwaysUse24HourFormat;

    return GetBuilder(
        init: model,
        initState: (_) {},
        builder: (_) {
          return GestureDetector(
            onTap: () => Get.to(() => CreateAlarmView(alarm: alarm)),
            child: Card(
              child: Theme.of(context).brightness == Brightness.light
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: !alarm.status!
                              ? const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                      Colors.white,
                                      Colors.white,
                                      Colors.white
                                    ])
                              : const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xff6B46F6),
                                    Color(0xff8001FF)
                                  ],
                                  stops: [0.3, 0.7],
                                ),
                          image: const DecorationImage(
                              alignment: Alignment.bottomRight,
                              image:
                                  AssetImage("assets/images/Mask group.png"))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 230.sp,
                                  child: Text(
                                    alarm.repeat == false
                                        ? 'Today'
                                        // Display "Today" if no days are selected
                                        : alarm.interval!.length.isEqual(7)
                                            ? 'Everyday'
                                            : (alarm.interval is List)
                                                ? getDays(alarm.interval!)
                                                : alarm.interval
                                                    .toString()
                                                    .toUpperCase(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    // Check if no days are selected

                                    style: Theme.of(context).brightness ==
                                                Brightness.dark ||
                                            !alarm.status!
                                        ? const TextStyle(
                                            color: Color(0xff697CAC))
                                        : const TextStyle(color: Colors.white),
                                  ),
                                ),

                                statusSwitch(model)
                                // SwitchButton(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    // "$_selectedTime"
                                    DateFormat(is24HoursFormat ? "HH:mm" : "hh:mm a").format(dateTime),
                                    style: Theme.of(context).brightness ==
                                                Brightness.dark ||
                                            !alarm.status!
                                        ? const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "NunitoSans",
                                            color: Color(0xff697CAC),
                                            letterSpacing: 0.75,
                                            fontSize: 28)
                                        : const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "NunitoSans",
                                            color: Colors.white,
                                            letterSpacing: 0.75,
                                            fontSize: 28)

                                    // style: const TextStyle(
                                    //   letterSpacing: 0.75,
                                    //   fontSize: 28,
                                    //   fontWeight: FontWeight.w500,
                                    //   color:
                                    //   //  isChangeColor
                                    //   //     ? Colors.white:
                                    //   Colors.white,
                                    // ),
                                    ),
                              ],
                            ),
                            Divider(
                              color: Theme.of(context).brightness ==
                                          Brightness.dark ||
                                      !alarm.status!
                                  ? const Color(0xff697CAC)
                                  : Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(alarm.type?.toUpperCase() ?? '',
                                    style: Theme.of(context).brightness ==
                                                Brightness.dark ||
                                            !alarm.status!
                                        ? const TextStyle(
                                            color: Color(0xff697CAC))
                                        : const TextStyle(color: Colors.white)),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    deleteAlarmDialog(
                                        context, model, alarm.sId!);
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 24,
                                    // color: Colors.yellow,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Image.asset(
                                          "assets/images/Icon.png",
                                          color: Theme.of(context).brightness ==
                                                      Brightness.dark ||
                                                  !alarm.status!
                                              ? const Color(0xff697CAC)
                                              : Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Image.asset("assets/images/assignment.png",
                                    color: Theme.of(context).brightness ==
                                                Brightness.dark ||
                                            !alarm.status!
                                        ? const Color(0xff697CAC)
                                        : Colors.white),
                                const SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width: Get.size.width * 0.5,
                                  child: Text(alarm.title ?? '',
                                      style: Theme.of(context).brightness ==
                                                  Brightness.dark ||
                                              !alarm.status!
                                          ? const TextStyle(
                                              color: Color(0xff697CAC),
                                              overflow: TextOverflow.ellipsis)
                                          : const TextStyle(
                                              color: Colors.white,
                                              overflow: TextOverflow.ellipsis)),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                if (globalCache.alarmSetupResponse != null)
                                  ...alarm.colorTags!.map<Widget>((colorTag) {
                                    final color = globalCache
                                        .alarmSetupResponse!.colorTags!
                                        .firstWhere((element) =>
                                            colorTag == element.title);

                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: CustomTagWidget(
                                          text: colorTag,
                                          firstColor: color.colors!.first,
                                          secondColor: color.colors!.last,
                                        ));
                                  }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: !alarm.status!
                              ? const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                      Color(0xff1F1743),
                                      Color(0xff110D28),
                                      Color(0xff110D28),
                                      Color(0xff1F1743),
                                    ])
                              : const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xff6B46F6),
                                    Color(0xff8001FF)
                                  ],
                                  stops: [0.3, 0.7],
                                ),
                          image: const DecorationImage(
                              alignment: Alignment.bottomRight,
                              image:
                                  AssetImage("assets/images/Mask group.png"))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 230.sp,
                                      child: Text(
                                        alarm.interval!.isEmpty
                                            ? 'Today'
                                            // Display "Today" if no days are selected
                                            : alarm.interval!.length.isEqual(7)
                                                ? 'Everyday'.toUpperCase()
                                                : (alarm.interval is List)
                                                    ? getDays(alarm.interval!)
                                                    : alarm.interval
                                                        .toString()
                                                        .toUpperCase(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        // Check if no days are selected

                                        style: Theme.of(context).brightness ==
                                                    Brightness.dark ||
                                                !alarm.status!
                                            ? const TextStyle(
                                                color: Colors.white)
                                            : const TextStyle(
                                                color: Colors.white),
                                      ),

                                      // Text(
                                      //                             alarm.interval!.length.isEqual(7)
                                      //                                 ? 'Everyday'
                                      //                                 : DateFormat('EEEE').format(dateTime),
                                      //                             style: TextStyle(
                                      //                               color: model.isDarkMode.value
                                      //                                   ? Colors.white
                                      //                                   : Colors.white,
                                      //                             ),
                                      //                           ),
                                    ),
                                  ],
                                ),

                                statusSwitch(model)
                                // SwitchButton(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  // "$_selectedTime"
                                  DateFormat('hh:mm a').format(dateTime),
                                  style: const TextStyle(
                                    letterSpacing: 0.75,
                                    fontSize: 28,
                                    fontFamily: "NunitoSans",
                                    fontWeight: FontWeight.bold,
                                    color:
                                        //  isChangeColor
                                        //     ? Colors.white:
                                        Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color:
                                  // isChangeColor
                                  //     ? Colors.white:
                                  Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  alarm.type?.toUpperCase() ?? '',
                                  style: const TextStyle(
                                    color:
                                        // isChangeColor
                                        //     ? Colors.white:
                                        Colors.white,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    deleteAlarmDialog(
                                        context, model, alarm.sId!);
                                  },
                                  child: Image.asset(
                                    "assets/images/Icon.png",
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/assignment.png",
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width: Get.size.width * 0.5,
                                  child: Text(alarm.title ?? '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis)),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                if (globalCache.alarmSetupResponse != null)
                                  ...alarm.colorTags!.map<Widget>((colorTag) {
                                    final color = globalCache
                                        .alarmSetupResponse!.colorTags!
                                        .firstWhere((element) =>
                                            colorTag == element.title);

                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: CustomTagWidget(
                                          text: colorTag,
                                          firstColor: color.colors!.first,
                                          secondColor: color.colors!.last,
                                        ));
                                  }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        });
  }

  Widget statusSwitch(HomeViewModel model) {
    return GestureDetector(
      onTap: () {
        alarm.status = !alarm.status!;
        model.update();
        model.toggleAlarm(alarm);
      },
      child: Container(
        width: 51.sp,
        height: 25.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: const Color(0xff6B46F6)),
          color: !alarm.status! ? const Color(0xFF697CAC) : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (alarm.status!)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'on',
                  style: TextStyle(
                    color: Color(0xff6B46F6),
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
                  color:
                      !alarm.status! ? Colors.white : const Color(0xff6B46F6),
                ),
              ),
            ),
            if (!alarm.status!)
              const Padding(
                padding: EdgeInsets.only(right: 6.0),
                child: Text(
                  'off',
                  style: TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> deleteAlarmDialog(
    BuildContext context,
    HomeViewModel model,
    String id,
  ) {
    return showDialog(
      context: context,
      builder: (context) => Container(
        decoration:BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),

        child: AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.transparent
                    : Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.transparent,
          title: Column(
            children: [
              // SizedBox(height: 10,),
              SizedBox(
                height: 60,
                child: Stack(
                  // alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset("assets/images/Union.png"),
                    ),
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset("assets/images/disable-alarm.png"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Do you wish to delete this alarm?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
              const SizedBox(
                height: 10,
              ),
              Text(
                  "Confirm your action: Do you wish to delete this alarm? Once deleted, it cannot be undone.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 12)),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        backgroundColor: const Color(0xff302B4a),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        "Decline",
                        style: TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6B46F6)),
                    onPressed: () {},
                    child: GestureDetector(
                        onTap: () {
                          model.deleteAlarm(id).then((bool value) {
                            if (value) {
                              Get.back();
                              return alarmDeleteSuccess(context);
                            }
                          });
                        },
                        child: const Text(
                          "Yes, Delete",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> alarmDeleteSuccess(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),

        child: AlertDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.transparent
                    : Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          title: Column(
            children: [
              // SizedBox(height: 10,),
              SizedBox(
                height: 60,
                // color: Colors.black12,
                child: Stack(
                  // alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset("assets/images/Union.png"),
                    ),
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                          "assets/images/disable-alarm copy 1 (1).png"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Alarm has been deleted",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
              const SizedBox(
                height: 10,
              ),
              Text("Success! The alarm has been deleted from your list",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 12)),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6B46F6)),
                onPressed: () {},
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Text(
                      "Ok",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

getDays(List<String> repeatDays) {
  var days = '';
  for (var element in repeatDays) {
    days += element.substring(0, 3);
    if (element != repeatDays.last) {
      days += ', ';
    }
  }
  return days;
}
