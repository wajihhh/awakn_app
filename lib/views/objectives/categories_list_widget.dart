import 'package:awakn/models/category_response.dart';
import 'package:awakn/views/objectives/objectives_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class CategoriesListWidget extends StatelessWidget {
  const CategoriesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ObjectivesViewModel model = Get.find<ObjectivesViewModel>();
    return SizedBox(
      height: 50.sp,
      // width: 70,
      child: GetBuilder<ObjectivesViewModel>(
        init: model,
        builder: (_) {
          return model.categoryList.length < 2
              ? const SizedBox.shrink()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: model.categoryList.length,
                  itemBuilder: (context, index) {
                    CategoryDto category = model.categoryList[index];
                    bool isSelected = category == model.selectedCategory;
                    return GestureDetector(
                      onTap: () {
                        // Handle card tap
                        // controller.handleCardTap(index);
                        model.handleSelectCategory(category);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).brightness==Brightness.dark?Colors.white:const Color(0xff6B46F6)
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).brightness == Brightness.dark
                              ?isSelected
                              ? const Color(0xff6B46F6)
                              : const Color(0xF2040112)
                              :isSelected
                              ? const Color(0xff4023AB)
                              : Colors.transparent,

                        ),
                        height: 60,

                        // width: 100,
                        padding: const EdgeInsets.only(left: 8, right: 8),

                        margin: const EdgeInsets.all(8),
                        child: Center(
                          child: Text(
                            category.name!,
                            style: Theme.of(context).brightness==Brightness.dark
                                ?const TextStyle(color: Colors.white)
                                : TextStyle(color: isSelected ? Colors.white:Colors.white)
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
