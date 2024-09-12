
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/review_controller.dart';

class ReviewCardList extends StatelessWidget {
  final ReviewCardController controller = Get.put(ReviewCardController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // height: 150.sp,
      // width: 400,
      // color: Colors.white,
      child: Container(
        color: Colors.transparent,
        child: Obx(
          () => ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: controller.dataList.length,
            itemBuilder: (context, index) {
              final data = controller.dataList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // height: 145.sp,
                  decoration: BoxDecoration(
                      boxShadow:  [
                        BoxShadow(
                          color: Theme.of(context).brightness==Brightness.dark?Colors.transparent :Colors.grey.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 100,
                          offset: Offset(0,2),
                        )
                      ],
                      color: Theme.of(context).brightness==Brightness.dark?Color(0xff271B56):Color(0xff663BFF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.transparent)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                height: 55.sp,
                                // width: 50.sp,
                                decoration: BoxDecoration(
                                  // color: Colors.amber,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Image.asset(
                                  data.imageUrl,
                                  height: 40,
                                  fit: BoxFit.fill,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.name,
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.star_fill,
                                      size: 20,
                                      color: Color(0xffFFB800),
                                    ),
                                    const Icon(
                                      CupertinoIcons.star_fill,
                                      size: 20,
                                      color: Color(0xffFFB800),
                                    ),
                                    const Icon(
                                      CupertinoIcons.star_fill,
                                      size: 20,
                                      color: Color(0xffFFB800),
                                    ),
                                    const Icon(
                                      CupertinoIcons.star_fill,
                                      size: 20,
                                      color: Color(0xffFFB800),
                                    ),
                                    const Icon(
                                      CupertinoIcons.star_fill,
                                      size: 20,
                                      color: Color(0xffECEAF0),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(data.currentRating.toString(),
                                      style: TextStyle(
                                          color: Colors.white
                                      ),                                    ),
                                    Text(
                                      "(9.432)",
                                      style: TextStyle(
                                        color: Colors.white
                                      ),

                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        Text(
                          data.description,
                          style: TextStyle(
                              color: Colors.white
                          ),                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
//Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.green,
//                 border: Border.all(
//                   color: Color(0xff9B9EE7)
//                 )
//                   ),
//                   child: ListTile(
//                     leading: ConstrainedBox(
//                       constraints: BoxConstraints(
//                         minHeight: 55,
//                         maxHeight: 90,
//                         maxWidth: 66,
//                         minWidth: 66
//                       ),
// child: Image.network(
//   data.imageUrl,scale: 0.5,
//   // fit: BoxFit.fill,
// ),
//                     ),
//
//                     title: Text(
//                       data.title,
//                       style: TextStyle(
//                             fontSize: 10.sp,
//                           color: Color(0xff8F83FF),
//                       ),
//
//
//                     ),
//                     subtitle: Column(
//                       children: [
//                         Text(data.description,style: TextStyle(
//                           fontSize: 14.sp,
//                           color: Color(0xff424753),
//                           fontWeight: FontWeight.w500
//                         ),),
//                         Row(
//                           children: [
//                             Icon(
//                               CupertinoIcons.star_fill,
//                               color: Color(0xFFFFFB800),
//                               size: 10,
//                             ),
//                             SizedBox(width: 2,),
//                             Text(
//                               data.currentRating.toString(),
//                               style: TextStyle(
//                                   color: Color(0xff8F83FF), fontSize: 12),
//                             ),
//                             Text("/",
//                                 style: TextStyle(
//                                     color: Color(0xff8F83FF),
//                                     fontSize: 12)),
//                             Text(data.totalRating.toString(),
//                                 style: TextStyle(
//                                     color: Color(0xff8F83FF),
//                                     fontSize: 12)),
//                           ],
//                         )
//                       ],
//                     ),
//                     trailing: Icon(
//                       data.isFavorite
//                           ? Icons.favorite
//                           : Icons.favorite_border,
//                       color: data.isFavorite
//                           ? Color(0xff6B46F6)
//                           : Colors.grey,
//                     ),
//
//                   ),
//                 ),
//               )
