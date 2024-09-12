import 'package:awakn/models/objectives_response.dart';
import 'package:awakn/widgets/favorite_icon_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    required this.objective,
    this.onTap,
    this.onFavouriteTap,
    this.onRemoveTap,
    super.key,
  });

  final Objective objective;
  final void Function()? onTap;
  final void Function()? onFavouriteTap;
  final void Function()? onRemoveTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: Theme.of(context).brightness == Brightness.light
              ? BoxDecoration(
                  border: Border.all(color: const Color(0x4D6B46F6)),
                  borderRadius: BorderRadius.circular(6),
                  color: Color(0xff663BFF))
              : BoxDecoration(
                  border: Border.all(color: const Color(0x4D6B46F6)),
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xF2040112)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  // child: Hero(
                  //   tag: objective.sId!,
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    // cacheKey: objective.sId!,
                    imageUrl: objective.coverImage ?? '',
                  ),
                  // ),
                ),
                const Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            // color: Colors.grey,
                            width: 135,
                            child: Text(
                              objective.title ?? '',
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 12,
                                  color: Colors.white),
                            ),
                          ),
                          // if (objective.isFavourite != null &&
                          //     onRemoveTap == null)
                            FavoriteIconWidget(
                                onTap: onFavouriteTap,
                                value: objective.isFavourite ?? false),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(objective.overview ?? '',
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.star_fill,
                            color: Color(0xFFFFB800),
                            size: 10,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            '${objective.rating ?? 0}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                          const Text("/5",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ),
                if (onRemoveTap != null)
                  IconButton(
                    onPressed: onRemoveTap,
                    icon: const Icon(
                      CupertinoIcons.clear_thick_circled,
                      color: Colors.red,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
