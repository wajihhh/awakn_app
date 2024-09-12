import 'package:awakn/widgets/customappbar.dart';
import 'package:awakn/widgets/feature_tour_icon.dart';
import 'package:awakn/widgets/loader_widget.dart';
import 'package:awakn/widgets/objective_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tcard/tcard.dart';

import '../objectives/objectives_view_model.dart';
import '../theming/theme.dart';

class LikeView extends StatelessWidget {
  const LikeView({super.key});

  @override
  Widget build(BuildContext context) {
    // final ObjectivesViewModel controller = Get.put(ObjectivesViewModel());

    final model = Get.put(ObjectivesViewModel());

    return Obx(
      () => CustomLoaderWidget(
        isTrue: model.isLoading.value,
        child: Container(
          decoration:
              BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: ReusableAppBar(
              actions: const [
                FeatureTour(),
                SizedBox(
                  width: 10,
                )
              ],
              title: 'Likes And Interests',
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 20.sp,
                ),
                model.objectivesList.isEmpty
                    ? const Text("No Objective Found")
                    : TCard(
                        // slideSpeed: 100,
                        // size: Size(
                        //   400,500
                        // ),
                        cards: model.objectivesList.map((objective) {
                          return ObjectiveCard(objective: objective);
                        }).toList(),
                        controller: model.tCardController,
                      ),

                // TCard(
                //   cards: model.objectivesList.map((objective){
                //         return ObjectiveCard(
                //             objective: objective,
                //           // onTap: (){
                //           //     controller.updateFavoriteStatus(objective);
                //           // },
                //         );
                //   }).toList(),
                //   controller: model.tCardController,
                // ),
                // SizedBox(height: 20.sp),
                const Spacer(
                  flex: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        model.tCardController
                            .forward(direction: SwipDirection.Left);
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset("assets/images/dislike.svg"),
                          Text(
                            "Swipe card Left",
                            style:
                                TextStyle(color: Colors.grey.withOpacity(0.2)),
                          ),
                          SvgPicture.asset("assets/images/left.svg"),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        model.tCardController
                            .forward(direction: SwipDirection.Right);
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset("assets/images/like.svg"),
                          Text(
                            "Swipe card Right",
                            style:
                                TextStyle(color: Colors.grey.withOpacity(0.2)),
                          ),
                          SvgPicture.asset("assets/images/right.svg"),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
