import 'package:awakn/views/objectives/objectives_view_model.dart';
import 'package:awakn/views/objectives/rate_objective.dart';
import 'package:awakn/widgets/custom_button.dart';
import 'package:awakn/widgets/favorite_icon_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../widgets/reviewcard.dart';
import '../theming/theme.dart';

class ObjectiveDetail extends StatelessWidget {
  const ObjectiveDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ObjectivesViewModel>(
      init: Get.find<ObjectivesViewModel>(),
      builder: (model) {
        return Container(
          decoration:
          BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Theme.of(context).brightness == Brightness.light
                    ? 'assets/images/bg main l.png'
                    : 'assets/images/bg main d.png',
              ),
              fit: BoxFit.fill,
            ),
          ),          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  headerSection(model, context),
                  middleSection(model, context),
                  bottomSection(model, context),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              surfaceTintColor: Colors.white,
              elevation: 10,
              shadowColor: Theme.of(context).bottomAppBarTheme.shadowColor,
              height: 105.sp,
              color: Theme.of(context).bottomAppBarTheme.color,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomButton(
                    text: "Select This Objective",
                    width: 300.sp,
                    height: 40.sp,
                    textFont: 16,
                    fontWeight: FontWeight.w500,
                    onTap: () {
                      model.selectObjective();
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Stack headerSection(ObjectivesViewModel model, BuildContext context) {
    final objective = model.selectedObjective!;
    return Stack(
      //
      children: <Widget>[
        Hero(
          tag: objective.sId!,
          child: CachedNetworkImage(
            cacheKey: objective.sId,
            imageUrl: objective.coverImage ?? '',
            fit: BoxFit.fill,
            width: double.infinity,
            // width: ,
          ),
        ),
        Positioned(
            height: 150.sp,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            )),
        Positioned(
          width: MediaQuery.of(context).size.width,
          height: 430.sp,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    // maxLines: 2,
                    objective.title ?? '',
                    style: const TextStyle(

                        // overflow: TextOverflow.ellipsis,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0),
                  ),
                ),
                Container(
                  height: 30,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Text(
                        objective.duration ?? '',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
    // return
  }

  Widget middleSection(ObjectivesViewModel model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  model.selectedObjective!.userImage ?? '',
                ),
              ),
              // Container(
              //     height: 55.sp,
              //     width: 55.sp,
              //     decoration: BoxDecoration(
              //       color: Colors.amber,
              //       borderRadius: BorderRadius.circular(60),
              //     ),
              //     child: Image.network(
              //         model.selectedObjective!.userImage ?? '',
              //
              //       height: 10,
              //       fit: BoxFit.fill,
              //     ),
              // ),
              SizedBox(
                width: 20.sp,
              ),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Wisteria Ravenclaw",
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                      Text("Yoga Coasch",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  )),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Icon(
                            CupertinoIcons.star_fill,
                            size: 20,
                            color: Color(0xffFFB800),
                          ),
                          Icon(
                            CupertinoIcons.star_fill,
                            size: 20,
                            color: Color(0xffFFB800),
                          ),
                          Icon(
                            CupertinoIcons.star_fill,
                            size: 20,
                            color: Color(0xffFFB800),
                          ),
                          Icon(
                            CupertinoIcons.star_fill,
                            size: 20,
                            color: Color(0xffFFB800),
                          ),
                          Icon(
                            CupertinoIcons.star_fill,
                            size: 20,
                            color: Color(0xffFFB800),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset("assets/images/Group 48189 (2).svg"),
                  const SizedBox(
                    width: 5,
                  ),
                  FavoriteIconWidget(
                      onTap: () =>
                          model.updateFavoriteStatus(model.selectedObjective!),
                      value: model.selectedObjective?.isFavourite ?? false),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              const Text("")
            ],
          )
        ],
      ),
    );
  }

  Widget bottomSection(ObjectivesViewModel model, BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
            labelColor: Theme.of(context).tabBarTheme.labelColor,
            unselectedLabelColor:
                Theme.of(context).tabBarTheme.unselectedLabelColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2.0,
            labelPadding: const EdgeInsets.symmetric(horizontal: 0),
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Examples'),
              Tab(text: 'Reviews & Rating'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: SizedBox(
              // color: Colors.black,
              height: 320.sp,
              // width: double.infinity,

              child: TabBarView(
                children: [
                  //tab 1 content
                  overviewTab(model, context),
                  //tab 2 content
                  exampleTab(model),
                  //tab 3 content
                  reviewRatings(context)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewRatings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(const RateObjective());
            },
            child: Container(
              height: 44.sp,
              width: 293.sp,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xff9B9EE7)),
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xff302B4a)
                    : Color(0xff4023AB),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.white,
                  ),
                  Text(
                    "Write A Review",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? const TextStyle(color: Colors.white, fontSize: 15)
                        : const TextStyle(
                            color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.sp,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Reviews and ratings",
                style: Theme.of(context).brightness == Brightness.dark
                    ? TextStyle(color: Colors.white.withOpacity(0.4))
                    : const TextStyle(color: Colors.white),
                // style: TextStyle(color: Colors.white.withOpacity(0.4)),
              )),
          ReviewCardList()
        ],
      ),
    );
  }

  Widget overviewTab(ObjectivesViewModel model, BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(model.selectedObjective!.overview ?? '',
            style: Theme.of(context).brightness == Brightness.dark
                ? const TextStyle(fontSize: 14, color: Colors.white)
                : const TextStyle(fontSize: 14, color: Colors.white)),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SizedBox(
              height: 22.sp, // Set a fixed height for the container
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: model.selectedObjective?.tags?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: const Color(0xff9B9EE7)),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xF2040112)
                              : Colors.transparent),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Text(
                          model.selectedObjective!.tags![index],
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  :  Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              )
              // children: [
              //   Container(
              //
              //
              //       decoration: BoxDecoration(
              //           // color: Color(0xff6B46F6),
              //           borderRadius: BorderRadius.circular(25),
              //           border: Border.all(color: const Color(0xff9B9EE7)),
              //           color: Theme.of(context).brightness==Brightness.dark?Color(0xF2040112):Colors.transparent
              //
              //       ),
              //       child:  Padding(
              //         padding: EdgeInsets.only(left: 20, right: 20),
              //         child: Text(
              //           "Free",
              //           style: TextStyle(
              //               color: Theme.of(context).brightness==Brightness.dark?Colors.white:Color(0xff6B46F6)
              //           ),
              //         ),
              //       )),
              //   const SizedBox(
              //     width: 10,
              //   ),
              //   Container(
              //       // height:5,
              //       // width: 10,
              //
              //       decoration: BoxDecoration(
              //           // color: Color(0xff6B46F6),
              //           borderRadius: BorderRadius.circular(25),
              //           border: Border.all(color: const Color(0xff9B9EE7)),
              //           color: Theme.of(context).brightness==Brightness.dark?Color(0xF2040112):Colors.transparent
              //
              //       ),
              //       child:  Padding(
              //         padding: EdgeInsets.only(left: 20, right: 20),
              //         child: Text(
              //           "Calmness",
              //           style: TextStyle(
              //               color: Theme.of(context).brightness==Brightness.dark?Colors.white:Color(0xff6B46F6)
              //           ),
              //         ),
              //       )),
              //   const SizedBox(
              //     width: 10,
              //   ),
              //   Container(
              //       // height:5,
              //       // width: 10,
              //
              //       decoration: BoxDecoration(
              //           // color: Color(0xff6B46F6),
              //           borderRadius: BorderRadius.circular(25),
              //           border: Border.all(color: const Color(0xff9B9EE7)),
              //           color: Theme.of(context).brightness==Brightness.dark?Color(0xF2040112):Colors.transparent
              //       ),
              //       child:  Padding(
              //         padding: EdgeInsets.only(left: 20, right: 20),
              //         child: Text(
              //           "Objectives",
              //           style: TextStyle(
              //               color: Theme.of(context).brightness==Brightness.dark?Colors.white:Color(0xff6B46F6)
              //           ),
              //         ),
              //       )),
              //   const SizedBox(
              //     width: 10,
              //   ),
              //   Container(
              //       // height:5,
              //       // width: 10,
              //
              //       decoration: BoxDecoration(
              //           // color: Color(0xff6B46F6),
              //           borderRadius: BorderRadius.circular(25),
              //           border: Border.all(color: const Color(0xff9B9EE7)),
              //           color: Theme.of(context).brightness==Brightness.dark?Color(0xF2040112):Colors.transparent
              //       ),
              //       child:  Padding(
              //         padding: EdgeInsets.only(left: 20, right: 20),
              //         child: Text(
              //           "Calmness",
              //           style: TextStyle(
              //               color: Theme.of(context).brightness==Brightness.dark?Colors.white:Color(0xff6B46F6)
              //           ),
              //         ),
              //       )),
              //
              //   // Add more SmallContainerWithText widgets as needed
              // ],

              ),
        ),
      ],
    );
  }

  Widget exampleTab(ObjectivesViewModel model) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns in the grid
        crossAxisSpacing: 20.0, // Spacing between columns

        mainAxisSpacing: 20.0, // Spacing between rows
      ),
      itemCount: model.selectedObjective!.examples!.length,
      itemBuilder: (context, index) {
        if (model.selectedObjective!.examples!.isEmpty ||
            (model.selectedObjective!.mainPhrases != null &&
                index >= model.selectedObjective!.mainPhrases!.length)) {
          return const Text(
              "No Examples"); // Return an empty SizedBox if there are no examples or main phrases
        }
        final item = model.selectedObjective!.examples![index];
        final phrase = model.selectedObjective?.mainPhrases?[index] ??
            model.selectedObjective?.overview ??
            '';
        return GridItem(
          text: phrase,
          image: item,
        );
      },
    );
  }
}

class GridItem extends StatelessWidget {
  final String text;
  final String image;

  const GridItem({super.key, required this.text, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child:
                // Image.network(
                //   image,
                //   fit: BoxFit.cover,
                // ),

                ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(
                    0.4), // Adjust opacity and color to control dullness
                BlendMode.darken,
              ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                // cacheKey: objective.sId,
                imageUrl: image,
                //
              ),
            ),
          ),
          Positioned.fill(
            top: 10,
            left: 5,
            right: 5,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              // color: Colors.black.withOpacity(0.5), // Adjust the overlay color and opacity
              child: Text(
                text,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // Adjust the text color
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
