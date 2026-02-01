import 'package:flutter/material.dart';

class CategoryGridItem extends StatelessWidget {
  final String icon;
  final String name;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  final bool showError;

  const CategoryGridItem({
    super.key,
    required this.icon,
    required this.name,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // STYLE_GUIDE: Radius 20
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF0F2027), const Color(0xFF2C5364)]
                      : [const Color(0xFF4364F7), const Color(0xFF6FB1FC)],
                )
              : null,
          color: isSelected
              ? null
              : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? (isDark
                        ? Colors.black45
                        : const Color(0xFF4364F7).withValues(alpha: 0.3))
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: isSelected ? 10 : 5,
              offset: const Offset(0, 4),
            ),
          ],
          border: isSelected
              ? null
              : Border.all(
                  color: showError
                      ? Colors.red
                      : (isDark ? Colors.grey[800]! : Colors.grey[200]!),
                  width: showError ? 1.5 : 1,
                ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: TextStyle(
                fontSize: 24,
                shadows: isSelected
                    ? [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.grey[300] : Colors.grey[800]),
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
