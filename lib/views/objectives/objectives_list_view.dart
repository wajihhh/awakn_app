import 'package:awakn/views/objectives/favorite_objectives_view.dart';
import 'package:awakn/views/objectives/objectives_view_model.dart';
import 'package:awakn/widgets/customappbar.dart';
import 'package:awakn/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../widgets/feature_tour_icon.dart';
import 'categories_list_widget.dart';
import '../../widgets/objective_card.dart';
import '../../widgets/recommendation_card.dart';
import '../../widgets/searchbar.dart';

class ObjectivesListView extends StatelessWidget {
  const ObjectivesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Get.put(ObjectivesViewModel());
    return Obx(
      () => CustomLoaderWidget(
        isTrue: model.isLoading.value,
        child: Container(
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
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              // appBar: ReusableAppBar(
              //   title: 'All Objectives',
              //   actions: [
              //     const FeatureTour(),
              //     const SizedBox(
              //       width: 10,
              //     ),
              //     GestureDetector(
              //         onTap: () =>
              //             Get.to(() => const FavouriteObjectivesView()),
              //         child:
              //             SvgPicture.asset("assets/images/Group 33756.svg")),
              //     const SizedBox(
              //       width: 10,
              //     )
              //   ],
              // ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, bottom: 10, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('All Objectives',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                              onTap: () =>
                                  Get.to(() => const FavouriteObjectivesView()),
                              child: SvgPicture.asset(
                                  "assets/images/Group 33756.svg")),
                        ],
                      ),
                    ),
                    MySearchBar(
                      controller: model.searchController,
                    ),
                    const CategoriesListWidget(),
                    SizedBox(
                      height: 350,
                      child: model.objectivesList.isEmpty
                          ? const Text("No Objectives Found.")
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: model.objectivesList.length,
                              itemBuilder: (context, index) {
                                final objective = model.objectivesList[index];
                                return ObjectiveCard(
                                  objective: objective,
                                  onTap: () =>
                                      model.navigateToObjective(objective),
                                  onFavouriteTap: () =>
                                      model.updateFavoriteStatus(objective),
                                );
                              },
                            ),
                    ),
                    if (model.recommendationsList.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 10, right: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Recommendation",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                            // SizedBox()
                            // Text(
                            //   "See More",
                            //   style: TextStyle(
                            //       fontSize: 12, color: Color(0xff8F83FF)),
                            // ),
                          ],
                        ),
                      ),
                    ...model.recommendationsList.map<Widget>(
                      (element) => RecommendationCard(
                        objective: element,
                        onTap: () => model.navigateToObjective(element),
                        onFavouriteTap: () =>
                            model.updateFavoriteStatus(element),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
