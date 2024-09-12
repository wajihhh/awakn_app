import 'package:awakn/models/objectives_response.dart';
import 'package:awakn/views/objectives/objectives_view_model.dart';
import 'package:awakn/widgets/favorite_icon_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';

class ObjectiveCard extends StatelessWidget {
  const ObjectiveCard({
    required this.objective,
    this.onTap,
    this.onFavouriteTap,
    super.key,
  });

  final Objective objective;
  final void Function()? onTap;
  final void Function()? onFavouriteTap;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ObjectivesViewModel>(
      builder: (_) {
        return GestureDetector(
          onTap: onTap,
          child: Card(
            margin: const EdgeInsets.all(8),
            child: Container(
              decoration: Theme.of(context).brightness == Brightness.light
                ?BoxDecoration(
                  border: Border.all(color: const Color(0x4D6B46F6)),
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    // begin: Alignment.topLeft,
                    // end: Alignment.topRight,
                    colors: [
                      Color(0xff663BFF),
                      // Color(0xff9B9EE7),
                      Color(0xff663BFF),

                    ]
                  )

              )
              : BoxDecoration(
                  border: Border.all(color: const Color(0x4D6B46F6)),
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xF2040112))
               ,
              height: 320.sp,
              width: 250.sp,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                      height: 162.sp,
                      width: 240.sp,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      // child: Hero(
                      //   tag: objective.sId!,
                      child: CachedNetworkImage(
                        cacheKey: objective.sId!,
                        imageUrl: objective.coverImage ?? '',
                      ),
                      // ),
                      //  Image.network(
                      //   objective.coverImage ?? '',
                      //   fit: BoxFit.fill,
                      // )
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 200.sp,
                              child: Text(
                                objective.title ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style:
                                    const TextStyle(color: Colors.white),
                              ),
                            ),
                            FavoriteIconWidget(
                                onTap: onFavouriteTap,
                                value: objective.isFavourite ?? false),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          objective.overview ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          )
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              radius: 20,


                              backgroundImage: NetworkImage(
                                 objective.userImage ?? '',
                               ),

                            ),
                            SizedBox(
                              width: 120,
                              child: Text(
                                objective.title ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: const Color(0xff8F83FF),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            const Icon(
                              CupertinoIcons.star_fill,
                              color: Color(0xFFFFB800),
                            ),
                            Text(
                              // objective.currentRating.toString(),
                              '${objective.rating}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                            const Text("/ 5",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
