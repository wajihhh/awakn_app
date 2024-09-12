import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  ReusableAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(20.0),  // Adjust the radius as needed
      ),
      child: AppBar(
        flexibleSpace: Theme.of(context).brightness == Brightness.dark
            ? Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/sky.png'),
              fit: BoxFit.fill,
            ),
          ),
        )
            : Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/skylight.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            title,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        actions: actions != null
            ? [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              children: actions!,
            ),
          ),
        ]
            : null,        iconTheme: Theme.of(context).iconTheme,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}
