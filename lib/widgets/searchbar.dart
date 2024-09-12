import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: Theme.of(context).brightness == Brightness.light
          ? BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(40),
              color: Colors.transparent)
          : BoxDecoration(
              border: Border.all(color: const Color(0x4D6B46F6)),
              borderRadius: BorderRadius.circular(40),
              color: const Color(0xF2040112)),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.search,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                  hintText: 'Search for article...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
