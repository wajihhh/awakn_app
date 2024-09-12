import 'package:awakn/views/objectives/objectives_view_model.dart';
import 'package:awakn/widgets/customappbar.dart';
import 'package:awakn/widgets/loader_widget.dart';
import 'package:awakn/widgets/recommendation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../widgets/feature_tour_icon.dart';
import '../theming/theme.dart';

class FavouriteObjectivesView extends StatelessWidget {
  const FavouriteObjectivesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ObjectivesViewModel>(
      init: Get.find<ObjectivesViewModel>(),
      initState: (state) {
        state.controller?.getFavouriteObjectsList();
      },
      builder: (model) {
        return CustomLoaderWidget(
          isTrue: model.isLoading.value,
          child: Container(
            decoration: BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),

            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: ReusableAppBar(
                title: "My Favourites",
                actions: const [
                  FeatureTour(),
                  SizedBox(
                    width: 10,
                  ),

                ],
              ),
              body: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: model.favouriteObjectivesList.length,
                itemBuilder: (context, index) {
                  final objective = model.favouriteObjectivesList[index];
                  return RecommendationCard(

                    objective: objective,
                    onTap: () => model.navigateToObjective(objective),
                    onFavouriteTap: () => model.updateFavoriteStatus(objective),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
