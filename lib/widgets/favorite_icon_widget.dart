import 'package:flutter/material.dart';

class FavoriteIconWidget extends StatelessWidget {
  const FavoriteIconWidget({
    super.key,
    required this.onTap,
    required this.value,
  });

  final void Function()? onTap;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        value ? Icons.favorite : Icons.favorite_border,
        color: value ? const Color(0xff6B46F6) : Colors.white,
      ),
    );
  }
}
