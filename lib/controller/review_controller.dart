import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ReviewCardController extends GetxController {
  // Your data model class (replace with your actual data model)

  // List to store your data
  final RxList<ReviewDataModel> dataList = <ReviewDataModel>[].obs;

  @override
  void onInit() {
    // Initialize your data here (replace with your data)
    dataList.addAll([
      ReviewDataModel(
        name: "Jenna Husk",
        description:
            'A tranquil sanctuary in the palm of my hand. Highly Recommended to all.',
        imageUrl: 'assets/images/Mask-removebg-preview.png',
        // Replace with your desired icon
        currentRating: 4.5,
        totalRating: 9.432,
      ),
      ReviewDataModel(
        name: "Penny Tool",
        description:
            'This objective has transformed my daily practice, making mindfulness and flexibility accessible anytime, anywhere.',
        imageUrl: "assets/images/Mask-removebg-preview.png",
        // Replace with your desired icon
        currentRating: 4.5,
        totalRating: 9.432,
      ),
      ReviewDataModel(
        name: "Jenna Husk",
        description:
            'A tranquil sanctuary in the palm of my hand. Highly Recommended to all',
        imageUrl: 'assets/images/Mask-removebg-preview.png',
        // Replace with your desired icon
        currentRating: 4.5,
        totalRating: 9.432,
      ),
    ]);

    super.onInit();
  }
}

class ReviewDataModel {
  final String imageUrl;
  final String name;
  final String description;

  final double currentRating;
  final double totalRating;

  ReviewDataModel({
    required this.description,
    required this.imageUrl,
    required this.name,
    required this.currentRating,
    required this.totalRating,
  });
}
