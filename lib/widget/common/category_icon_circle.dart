import 'package:flutter/material.dart';

class CategoryIconCircle extends StatelessWidget {
  final String icon;
  final bool isDark;
  final double radius;
  final double iconSize;

  const CategoryIconCircle({
    super.key,
    required this.icon,
    required this.isDark,
    this.radius = 28,
    this.iconSize = 38,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.3),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(-5, 5),
                ),
              ],
        borderRadius: BorderRadius.circular(50),
      ),
      child: CircleAvatar(
        backgroundColor: Colors
            .primaries[icon.hashCode % Colors.primaries.length]
            .shade100
            .withValues(alpha: 0.35),
        radius: radius,
        child: Text(icon, style: TextStyle(fontSize: iconSize)),
      ),
    );
  }
}
