import 'package:awakn/models/category_response.dart';
import 'package:awakn/models/objectives_response.dart';
import 'package:awakn/services/alarm_service.dart';
import 'package:awakn/views/create_alarm/create_alarm_view_model.dart';
import 'package:awakn/views/objectives/objective_details.dart';
import 'package:awakn/widgets/snackbar_manager.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tcard/tcard.dart';

class ObjectivesViewModel extends GetxController {
  RxBool isLoading = true.obs;
  TextEditingController reviewController = TextEditingController();
  TCardController tCardController = TCardController();

  TextEditingController searchController = TextEditingController();
  final BehaviorSubject<String> _searchQuerySubject = BehaviorSubject<String>();
  late Stream<String> _debouncedQueryStream;

  final pageFormKey = GlobalKey<FormState>();
  ObjectivesResponse? response;
  RxList<Objective> objectivesList = RxList<Objective>([]);
  RxList<Objective> recommendationsList = RxList<Objective>([]);

  RxList<Objective> favouriteObjectivesList = RxList<Objective>([]);
  RxList<CategoryDto> categoryList =
      RxList<CategoryDto>([CategoryDto(name: 'All')]);

  CategoryDto? selectedCategory;
  Objective? selectedObjective;

  @override
  Future<void> onInit() async {
    setUpSearchDebounce();
    await Future.wait([
      fetchObjectivesList(),
      fetchCategories(),
      // getFavouriteObjectsList(),
    ]).then((value) {
      selectedCategory = categoryList.first;
      isLoading(false);
    });
    super.onInit();
  }

  void swipeLeft() {
    tCardController.forward(direction: SwipDirection.Left);
  }

  void swipeRight() {
    tCardController.forward(direction: SwipDirection.Right);
  }

  setUpSearchDebounce() {
    searchController.addListener(() {
      _searchQuerySubject.add(searchController.text);
    });
    _debouncedQueryStream = _searchQuerySubject
        .debounceTime(
            const Duration(milliseconds: 500)) // Delay after user stops typing
        .distinct(); // Ignore duplicate values

    _debouncedQueryStream.listen((query) {
      if (query.isNotEmpty) {
        // Make your API call here using the debounced query
        print('Making API call with query: $query');
        fetchObjectivesList(search: query);
      } else {
        objectivesList(response!.objectives);
        recommendationsList(response!.recommendations);
      }
    });
  }

  void handleSelectCategory(CategoryDto value) {
    // Toggle the selected state
    selectedCategory = value;
    fetchObjectivesList();
    update(); // Trigger a manual update
  }

  Future<void> fetchObjectivesList({String? search}) async {
    // try {
    // isLoading(true);
    var res = await AlarmService().getObjectivesList(
      search: search,
      categoryId: selectedCategory?.sId,
    );
    if (res != null) {
      if (search == null) {
        response = res;
      }
      objectivesList(res.objectives);
      recommendationsList(res.recommendations);
    } // } catch (error) {
    //   if (kDebugMode) {
    //     print(error);
    //   }
    // }
    // isLoading(false);
  }

  selectObjective() {
    final alarmModel = Get.find<CreateAlarmViewModel>();
    if (alarmModel.selectedObjectives
        .any((element) => element.sId == selectedObjective!.sId)) {
      showCenteredSnackBar(Get.context!, 'This Objective is already selected!');
    } else {
      alarmModel.selectedObjectives.add(selectedObjective!);
      // alarmModel.update();
      Get.until((route) => Get.currentRoute == '/CreateAlarmView');
    }
  }

  navigateToObjective(Objective objective) {
    selectedObjective = objective;
    Get.to(() => const ObjectiveDetail());
  }

  updateFavoriteStatus(Objective objective) async {
    final id = objective.sId!;
    final isFav = objective.isFavourite!;

    //mark favorite to make instant UX
    objective.isFavourite = !isFav;
    updateAllObjectiveList(objective);
    update();
    final res = objective.isFavourite!
        ? await addFavorite(id)
        : await removeFavorite(id);
  }

  void updateAllObjectiveList(Objective objective) {
    recommendationsList.value = recommendationsList.value
        .map((item) => item.sId == objective.sId ? objective : item)
        .toList();
    objectivesList.value = objectivesList.value
        .map((item) => item.sId == objective.sId ? objective : item)
        .toList();
    if (objective.isFavourite == true) {
      final list = favouriteObjectivesList.value.toList();
      list.add(objective);
      favouriteObjectivesList.value = list.toList();
    } else {
      favouriteObjectivesList.value = favouriteObjectivesList.value
          .where((item) => item.sId != objective.sId)
          .toList();
    }
  }

  Future<bool> addFavorite(String id) async {
    return await AlarmService().addFavouriteObjective(id);
  }

  Future<bool> removeFavorite(String id) async {
    final res = await AlarmService().removeFavouriteObjective(id);
    if (res && favouriteObjectivesList.isNotEmpty) {
      favouriteObjectivesList.removeWhere((element) => element.sId == id);
      return true;
    }
    return false;
  }

  Future<void> fetchCategories() async {
    var res = await AlarmService().getCategoriesList();
    categoryList.addAll(res);
  }

  Future<void> getFavouriteObjectsList() async {
    favouriteObjectivesList([]);
    var res = await AlarmService().getFavouriteObjectivesList();
    favouriteObjectivesList(
      res.map((item) {
        item.isFavourite = true;
        return item;
      }).toList(),
    );
  }
}
