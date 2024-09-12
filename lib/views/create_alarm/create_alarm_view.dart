import 'package:awakn/models/alarm_response.dart';
import 'package:awakn/views/create_alarm/create_alarm_view_model.dart';
import 'package:awakn/views/objectives/objectives_list_view.dart';
import 'package:awakn/views/objectives/objectives_view_model.dart';
import 'package:awakn/widgets/custom_alarm_switch.dart';
import 'package:awakn/widgets/custom_button.dart';
import 'package:awakn/widgets/custom_switch.dart';
import 'package:awakn/widgets/loader_widget.dart';
import 'package:awakn/widgets/recommendation_card.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../widgets/feature_tour_icon.dart';
import '../theming/theme.dart';

class CreateAlarmView extends StatelessWidget {
  final AlarmObject? alarm;

  const CreateAlarmView({
    this.alarm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isEditMode = alarm != null;
    return GetX<CreateAlarmViewModel>(
        init: Get.put(CreateAlarmViewModel()),
        initState: (state) {
          // await Future.delayed(const Duration(milliseconds: 250));
          final model = state.controller;
          model?.isEditMode = isEditMode;
          if (model != null && alarm != null) {
            model.setAlarmObjects(alarm!);
          }
        },
        dispose: (state) => state.controller?.onClose(),
        builder: (m) {
          return CustomLoaderWidget(
            isTrue: m.isLoading.value,
            child: Container(
              decoration:
                  BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  flexibleSpace: Theme.of(context).brightness == Brightness.dark
                      ? Container(
                          decoration: const BoxDecoration(
                               image: DecorationImage(image: AssetImage('assets/images/sky.png'),fit: BoxFit.fill)

                ),
                        )
                      : Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(image: AssetImage('assets/images/skylight.png'),fit: BoxFit.fill)

                          ),
                        ),
                  backgroundColor: Colors.transparent,
                  // shadowColor: Colors.black12,
                  // elevation: 2,
                  shape:  RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(19))),
                  centerTitle: true,
                  title: Text(
                    isEditMode ? "Edit Alarm" : "Create New Alarm",
                    style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                      color: Colors.white
                    ),
                  ),
                  leading: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back,
                          color:Colors.white)
                  ),
                  actions: const [
                    FeatureTour(),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GetBuilder<CreateAlarmViewModel>(
                              init: m,
                              builder: (_) {
                                return SizedBox(
                                  width: Get.size.width * 0.7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: Text(m.getTitle,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                      ),
                                      GestureDetector(
                                        onTap: () => m.selectTime(context),
                                        child: Text(
                                            m.selectedTime.format(context),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            CustomSwitchWithText(
                              value: m.isAlarmActive.value,
                              onTap: () => m.isAlarmActive.toggle(),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    m.isRepeatAlarm.toggle();
                                  },
                                  child: Icon(
                                    m.isRepeatAlarm.value
                                        ? Icons.check_circle
                                        : Icons.check_circle_outline,
                                    // size: 50,
                                    color: const Color(0xff6B46F6),
                                    // color: Colors.red, // Set the color of the icon
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Repeat Alarm",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15)),
                              ],
                            ),
                            // if (isEditMode)
                            //   Icon(Icons.delete_outline,
                            //       color: Theme.of(context).brightness ==
                            //               Brightness.light
                            //           ? Colors.black
                            //           : const Color(0xff697CAC))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (m.isRepeatAlarm.value)
                          GetBuilder<CreateAlarmViewModel>(
                            init: m,
                            builder: (_) {
                              return SizedBox(
                                height: 45.sp,
                                width: 325.sp,
                                child: SizedBox(
                                  height: 50.0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: m.days.length,
                                    itemBuilder: (context, index) {
                                      final day = m.days[index];
                                      final isSelectedDay =
                                          m.repeatDays.contains(day);
                                      return GestureDetector(
                                        onTap: () {
                                          m.selectDay(day);
                                        },
                                        child: Container(
                                          width: 30,
                                          margin: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : const Color(0xff6B46F6)),
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? isSelectedDay
                                                    ? const Color(0xff6B46F6)
                                                    : const Color(0xff040112)
                                                : isSelectedDay
                                                    ? const Color(0xff6B46F6)
                                                    : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              day.substring(0, 1),
                                              style: TextStyle(
                                                fontSize: 16,
                                                overflow: TextOverflow.ellipsis,
                                                color: isSelectedDay
                                                    ? Colors.white
                                                    : const Color(0xff949FBB),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Divider(
                          thickness: 2,
                          color: Color(0xff9B9EE7),
                        ),
                        // const SizedBox(
                        //   height: 30,
                        // ),
                        // Text("Select Type",
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .titleLarge!
                        //         .copyWith(
                        //             fontWeight: FontWeight.w500, fontSize: 14)),
                        // const SizedBox(
                        //   height: 7,
                        // ),
                        // Container(
                        //   height: 70,
                        //   decoration: Theme.of(context).brightness ==
                        //           Brightness.dark
                        //       ? BoxDecoration(
                        //           color: const Color(0xff040112),
                        //           border: Border.all(color: Colors.transparent),
                        //           borderRadius: BorderRadius.circular(12),
                        //         )
                        //       : BoxDecoration(
                        //           color: Colors.white,
                        //           border: Border.all(
                        //               color: const Color(0xff9B9EE7)),
                        //           borderRadius: BorderRadius.circular(12),
                        //         ),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Text(
                        //           "Alarm/exercise",
                        //           style: Theme.of(context)
                        //               .textTheme
                        //               .titleLarge!
                        //               .copyWith(fontSize: 16),
                        //         ),
                        //       ),
                        //
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: 25.sp,
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Title",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        TextFormField(

                          cursorColor: Colors.white,
                          controller: m.alarmTitleController,
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(top: 15, right: 8),
                              child: CustomAlarmSwitch(
                                value: m.isWakeUpAlarm.value,
                                onTap: () => m.isWakeUpAlarm.toggle(),
                              ),
                            ),
                            filled: true,

                            fillColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xff040112)
                                    : Color(0xff4023AB),
                            hintText: "Wake Up Steven",
                            hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                            // filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const BorderSide(
                                      color: Colors.transparent,
                                    )
                                  : const BorderSide(
                                      color: Color(0xff9B9EE7),
                                    ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xff9B9EE7),
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          style: Theme.of(context).brightness == Brightness.dark
                              ?  TextStyle(color: Colors.white,decoration: TextDecoration.none,decorationThickness: 0)
                              : const TextStyle(color: Colors.white,decoration: TextDecoration.none,decorationThickness: 0),
                        ),

                        // const SizedBox(
                        //   height: 25,
                        // ),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text("Note",
                        //       style: Theme.of(context)
                        //           .textTheme
                        //           .titleLarge!
                        //           .copyWith(
                        //               fontWeight: FontWeight.w500,
                        //               fontSize: 14)),
                        // ),
                        // const SizedBox(
                        //   height: 7,
                        // ),
                        // TextField(
                        //   controller: m.alarmNoteController,
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //     fillColor:
                        //         Theme.of(context).brightness == Brightness.dark
                        //             ? const Color(0xff040112)
                        //             : Colors.white,
                        //     prefixIcon: Padding(
                        //       padding: const EdgeInsets.all(1),
                        //       child: Image.asset(
                        //         "assets/images/assignment-removebg-preview.png",
                        //         color: const Color(0xff9B9EE7),
                        //       ),
                        //     ),
                        //     hintText:
                        //         "Prepare for go to airport, Annie will be waiting for you!",
                        //     hintStyle: const TextStyle(
                        //         color: Colors.grey,
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.w400),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(12),
                        //       borderSide: Theme.of(context).brightness ==
                        //               Brightness.dark
                        //           ? const BorderSide(
                        //               color: Colors.transparent,
                        //             )
                        //           : const BorderSide(
                        //               color: Color(0xff9B9EE7),
                        //             ),
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderSide: const BorderSide(
                        //         color: Color(0xff9B9EE7),
                        //       ),
                        //       borderRadius: BorderRadius.circular(12.0),
                        //     ),
                        //   ),
                        //   style: Theme.of(context).brightness == Brightness.dark
                        //       ? const TextStyle(color: Colors.white)
                        //       : const TextStyle(color: Colors.black),
                        // ),

                        // const SizedBox(
                        //   height: 20,
                        // ),
                        //
                        // Text("Color Tags",
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .titleLarge!
                        //         .copyWith(
                        //             fontWeight: FontWeight.w500, fontSize: 14)),
                        // // TextBox()
                        // SizedBox(
                        //   height: 7.sp,
                        // ),
                        // if (m.alarmSetup.value?.colorTags != null)
                        //   SizedBox(
                        //     height: 35,
                        //     child: ListView(
                        //       scrollDirection: Axis.horizontal,
                        //       children: [
                        //         ...m.alarmSetup.value!.colorTags!.map<Widget>(
                        //             (element) => Padding(
                        //                 padding: const EdgeInsets.symmetric(
                        //                     horizontal: 4.0),
                        //                 child: CustomTagWidget(
                        //                   onTap: () {
                        //                     m.selectColor(element.title!);
                        //                   },
                        //                   text: element.title ?? '',
                        //                   firstColor: element.colors!.first,
                        //                   secondColor: element.colors!.last,
                        //                   isSelected: m.selectedColor
                        //                       .contains(element.title!),
                        //                 ))),
                        //       ],
                        //     ),
                        //   ),
                        SizedBox(
                          height: 30.sp,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Music selection",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                        ),
                        SizedBox(
                          height: 7.sp,
                        ),
                        GetBuilder<CreateAlarmViewModel>(
                            init: m,
                            initState: (_) {},
                            builder: (_) {
                              return DropdownButton2<String>(

                                underline: Container(),
                                isExpanded: true,
                                hint: Text("Select Music",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontSize: 14,color: Colors.white)),
                                items: m.alarmSetup.value?.tunes
                                    ?.map((tune) => DropdownMenuItem<String>(

                                          value: tune.name,
                                          child: Text(tune.name ?? '',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                  FontWeight.w400)),
                                        ))
                                    .toList(),
                                value: m.selectedTune,
                                onChanged: (String? value) {
                                  m.selectedTune = value;
                                  m.update();
                                },
                                buttonStyleData: ButtonStyleData(

                                  height: 50.sp,
                                  // padding: const EdgeInsets.only(left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.transparent
                                            : const Color(0xff9B9EE7)
                                    ),
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? const Color(0xff040112)
                                        : Color(0xff4023AB),
                                  ),
                                  // elevation: 2,
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, right: 8),
                                    child: Icon(
                                      CupertinoIcons.chevron_down,
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? const Color(0xff040112)
                                        : Color(0xff4023AB),
                                  ),
                                  offset: const Offset(0, 0),
                                  scrollbarTheme: const ScrollbarThemeData(
                                    radius: Radius.circular(0),
                                    // thickness: MaterialStateProperty.all<double>(6),
                                    // thumbVisibility: MaterialStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              );
                            }),

                        SizedBox(
                          height: 30.sp,
                        ),

                        Obx(() {
                          if (m.isObjectiveVisible.value) {
                            return Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Select Objective",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14)),
                                ),
                                SizedBox(
                                  height: 7.sp,
                                ),
                                GestureDetector(
                                  onTap: () => Get.to(
                                    () => const ObjectivesListView(),
                                  ),
                                  child: Container(
                                    height: 50.sp,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? const Color(0xff040112)
                                          : Color(0xff4023AB),
                                      border: Border.all(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.transparent
                                              : const Color(0xff9B9EE7)),
                                    ),
                                    // color: Colors.blue,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              m.selectedObjectives.isNotEmpty
                                                  ? "${m.selectedObjectives.length} Objective selected"
                                                  : "Please Select",
                                              style: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400)
                                                  : const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color:
                                                Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.sp,
                                ),
                                if (m.selectedObjectives.isNotEmpty)
                                  ...m.selectedObjectives.map<Widget>(
                                      (element) => RecommendationCard(
                                            objective: element,
                                            onTap: () {
                                              final model = Get.put(
                                                  ObjectivesViewModel());
                                              model
                                                  .navigateToObjective(element);
                                            },
                                            onRemoveTap: () => m
                                                .selectedObjectives
                                                .remove(element),
                                          ))
                              ],
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                        SizedBox(
                          height: 20.sp,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              _addObjectiveDialog(context);
                            },
                            child: Container(
                              width: 260.sp,
                              height: 50.sp,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                border: Border.all(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : const Color(0xff9B9EE7)),
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? const Color(0xff302B4a)
                                    : Color(0xff4023AB),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Text(
                                        m.textOnContainer ??
                                            "Write Your Own Objectives",
                                        style:const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  surfaceTintColor: Colors.white,
                  elevation: 10,
                  shadowColor: Theme.of(context).bottomAppBarTheme.shadowColor,

                  height: 80.sp,
                  color: Theme.of(context).bottomAppBarTheme.color,
                  // shape: const AutomaticNotchedShape(RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.all(
                  //     Radius.circular(25),
                  //   ),
                  // )),
                  shape: const AutomaticNotchedShape(
                      RoundedRectangleBorder(), StadiumBorder()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomButton(
                        width: 300.sp,
                        height: 40.sp,
                        onTap: () {
                          m.createAlarm();
                        },
                        text: isEditMode ? "Update Alarm" : "Create Alarm",
                        textColor: Colors.white,
                        textFont: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

// void _showTunesDropdown(BuildContext context) {
//   Get.defaultDialog(
//     content: GetBuilder<CreateAlarmViewModel>(
//       builder: (m) {
//         return Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topRight,
//               end: Alignment.bottomLeft,
//               colors: [
//                 Color(0xff1F1743),
//                 Color(0xff110D28),
//                 Color(0xff110D28),
//                 Color(0xff1F1743),
//               ],
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//
//               SizedBox(
//                 height: 10.sp,
//               ),
//               DropdownButton2<String>(
//                 isExpanded: true,
//                 hint: Text(
//                   "Select Tune",
//                   style: TextStyle(fontSize: 14, color: Colors.white),
//                 ),
//                 items: m.alarmSetup.value?.tunes
//                     ?.map((tune) => DropdownMenuItem<String>(
//                   value: tune,
//                   child: Text(
//                     tune ?? '',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ))
//                     .toList(),
//                 value: m.selectedTune,
//                 onChanged: (String? value) {
//                   m.selectedTune = value;
//                   m.update();
//                 },
//                 buttonStyleData: ButtonStyleData(
//                   height: 50,
//                   padding: const EdgeInsets.only(left: 14, right: 14),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(
//                       color: Colors.black26,
//                     ),
//                     color: Colors.redAccent,
//                   ),
//                   elevation: 2,
//                 ),
//                 iconStyleData: const IconStyleData(
//                   icon: Icon(
//                     Icons.arrow_forward_ios_outlined,
//                   ),
//                   iconSize: 14,
//                   iconEnabledColor: Colors.yellow,
//                   iconDisabledColor: Colors.grey,
//                 ),
//                 dropdownStyleData: DropdownStyleData(
//                   maxHeight: 200,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(14),
//                     color: Colors.redAccent,
//                   ),
//                   offset: const Offset(-20, 0),
//                   scrollbarTheme: ScrollbarThemeData(
//                     radius: const Radius.circular(40),
//                     thickness: MaterialStateProperty.all<double>(6),
//                     thumbVisibility: MaterialStateProperty.all<bool>(true),
//                   ),
//                 ),
//                 menuItemStyleData: const MenuItemStyleData(
//                   height: 40,
//                   padding: EdgeInsets.only(left: 14, right: 14),
//                 ),
//               ),
//               SizedBox(
//                 height: 10.sp,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       side: const BorderSide(color: Colors.white),
//                       backgroundColor: const Color(0xff302B4a),
//                     ),
//                     onPressed: () {
//                       Get.back();
//                     },
//                     child: const Text("Cancel"),
//                   ),
//                   ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(
//                         const Color(0xff6B46F6),
//                       ),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18.0),
//                           side: const BorderSide(
//                             color: Color(0xff6B46F6),
//                           ),
//                         ),
//                       ),
//                     ),
//                     onPressed: () {
//                       // Set the selected item to the Container
//                       Get.back();
//                     },
//                     child: const Text(
//                       "Select",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         );
//       },
//     ),
//   );
// }
//--------------------------------------------------------//

_addObjectiveDialog(BuildContext context) async {
  await showDialog<String>(
    context: context,
    builder: (BuildContext dialogContext) {
      return GetBuilder<CreateAlarmViewModel>(builder: (m) {
        return CustomLoaderWidget(
          isTrue: m.isObjectiveLoading.value,
          child: Container(
            decoration: Theme.of(context).brightness == Brightness.dark
                ? BoxDecoration(
                    gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.onPrimary,
                      Theme.of(context).colorScheme.onSecondary,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ))
                : const BoxDecoration(color: Color(0xff4023AB)),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.transparent
                        : Colors.grey.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(12),
              ),
              titlePadding:
                  const EdgeInsets.only(left: 4, right: 4, top: 20, bottom: 20),
              backgroundColor: Colors.transparent,
              title: SizedBox(
                width: 150.sp,
                height: 350.sp,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                                color: Colors.white,
                                Icons.arrow_back)),
                        SizedBox(
                          width: 10.sp,
                        ),
                        Text("Add Objective",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 15.sp))
                      ],
                    ),
                    SizedBox(
                      height: 20.sp,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xff040112)
                            : Colors.black12,
                      ),
                      height: 230.sp,
                      width: 250.sp,
                      child: TextField(
                        maxLines: 5,
                        cursorColor: Colors.white,
                        minLines: 1,
                        controller: m.objectiveOverviewController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          // fillColor: Theme.of(context).brightness==Brightness.dark?Color(0xff040112):Colors.white,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Image.asset(
                            "assets/images/assignment-removebg-preview.png",
                            color: const Color(0xff9B9EE7),
                          ),
                          hintText: "Write your objectives...",
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 15.sp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            backgroundColor: const Color(0xff302B4a),
                          ),
                          onPressed: () {},
                          child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xff6B46F6)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: Color(0xff6B46F6))))),
                          onPressed: () => m.addObjective(),
                          child: const Text(
                            "Select",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}
