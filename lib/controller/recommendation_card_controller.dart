import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class RecommendationCardController extends GetxController {
  // Your data model class (replace with your actual data model)

  // List to store your data
  final RxList<RecommendationDataModel> dataList = <RecommendationDataModel>[].obs;

  @override
  void onInit() {
    // Initialize your data here (replace with your data)
    dataList.addAll([
      RecommendationDataModel(
          title: 'Anxiety',
          description: 'Yoga is very good for flexibility of muscles an...',
          imageUrl:
          'https://s3-alpha-sig.figma.com/img/d661/4843/59d199ed65547de2caea69a033ccb294?Expires=1704067200&Signature=Cq8~4BrjzSQdl1SQwQn56eaGlaJXqD8vGur7EXUu8cCDYpHbUCeHefRK04fRXuxEyP0NSFjQcxxhfV1Affw-lwzCm9hpAaWLc8M2YCGnHJ3PIVjguYs6fAYyJjNogZ08Qbv4B62RQXGRx-rmC40lSUmNI0ukwgGn7tV2CxluL~ih6e~8pDAc6w~JYCpDg-5tm-yNjZ7vtYxyAcv7e~3S-v6AsObNFSDMSlHOZNkXmYBf-wwm9SgP29y0sVDuAy2niK1HhOMaP1brZaPwGAfhuAq9g8Gtl3SX62qnoSQyRJ4RUKOjLJmam5H~ps7XdiCljSIxtsq5n2ouR6AAnTghbQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
          iconData: Icons.favorite,
          currentRating: 4.5,
          totalRating: 5,
          isFavorite: true,
          // Replace with your desired icon

      ),
      RecommendationDataModel(
        title: 'Sleep',
        description: 'Yoga is very good for flexibility of muscles an...',
        imageUrl:
        'https://s3-alpha-sig.figma.com/img/d661/4843/59d199ed65547de2caea69a033ccb294?Expires=1704067200&Signature=Cq8~4BrjzSQdl1SQwQn56eaGlaJXqD8vGur7EXUu8cCDYpHbUCeHefRK04fRXuxEyP0NSFjQcxxhfV1Affw-lwzCm9hpAaWLc8M2YCGnHJ3PIVjguYs6fAYyJjNogZ08Qbv4B62RQXGRx-rmC40lSUmNI0ukwgGn7tV2CxluL~ih6e~8pDAc6w~JYCpDg-5tm-yNjZ7vtYxyAcv7e~3S-v6AsObNFSDMSlHOZNkXmYBf-wwm9SgP29y0sVDuAy2niK1HhOMaP1brZaPwGAfhuAq9g8Gtl3SX62qnoSQyRJ4RUKOjLJmam5H~ps7XdiCljSIxtsq5n2ouR6AAnTghbQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
        iconData: Icons.favorite,
        // Replace with your desired icon
        currentRating: 4.5,
        totalRating: 5,
        isFavorite: false,


      ),
      RecommendationDataModel(
        title: 'Sleep',
        description: 'Yoga is very good for flexibility of muscles an...',
        imageUrl:
        'https://s3-alpha-sig.figma.com/img/d661/4843/59d199ed65547de2caea69a033ccb294?Expires=1704067200&Signature=Cq8~4BrjzSQdl1SQwQn56eaGlaJXqD8vGur7EXUu8cCDYpHbUCeHefRK04fRXuxEyP0NSFjQcxxhfV1Affw-lwzCm9hpAaWLc8M2YCGnHJ3PIVjguYs6fAYyJjNogZ08Qbv4B62RQXGRx-rmC40lSUmNI0ukwgGn7tV2CxluL~ih6e~8pDAc6w~JYCpDg-5tm-yNjZ7vtYxyAcv7e~3S-v6AsObNFSDMSlHOZNkXmYBf-wwm9SgP29y0sVDuAy2niK1HhOMaP1brZaPwGAfhuAq9g8Gtl3SX62qnoSQyRJ4RUKOjLJmam5H~ps7XdiCljSIxtsq5n2ouR6AAnTghbQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
        iconData: Icons.favorite,
        // Replace with your desired icon
        currentRating: 4.5,
        totalRating: 5,
        isFavorite: false,


      ),

    ]);

    super.onInit();
  }
}

class RecommendationDataModel {
  final String title;
  final String imageUrl;
  final String description;
  final IconData iconData;
  final double currentRating;
  final double totalRating;
  bool isFavorite;


  RecommendationDataModel(
      {required this.title,
        required this.description,
        required this.imageUrl,
        required this.iconData,
        required this.currentRating,
        required this.totalRating,
        required this.isFavorite,

      });

}
