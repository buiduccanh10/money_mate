import 'package:flutter/material.dart';

class CategoryGridItem extends StatelessWidget {
  final String icon;
  final String name;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const CategoryGridItem({
    super.key,
    required this.icon,
    required this.name,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.5,
            color: isSelected
                ? (isDark ? Colors.orange : Colors.amber)
                : Colors.transparent,
          ),
          color: Colors
              .primaries[name.hashCode % Colors.primaries.length]
              .shade100
              .withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
