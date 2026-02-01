import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:money_mate/l10n/app_localizations.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String? content;
  final VoidCallback onConfirm;
  final String? confirmText; // Optional specific text (e.g., "Delete")
  final String? cancelText;

  const ConfirmDeleteDialog({
    super.key,
    required this.title,
    this.content,
    required this.onConfirm,
    this.confirmText,
    this.cancelText,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    String? content,
    required VoidCallback onConfirm,
    String? confirmText,
    String? cancelText,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ConfirmDeleteDialog(
        title: title,
        content: content,
        onConfirm: onConfirm,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20), // STYLE_GUIDE: Radius 20
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.2,
                ), // STYLE_GUIDE: Shadow
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              // Icon Layer
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFFF3D00,
                  ).withValues(alpha: 0.15), // STYLE_GUIDE: Icon Layer
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.delete_rounded,
                    color: Color(0xFFFF3D00), // STYLE_GUIDE: Expense Red
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (content != null) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    content!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              // Buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isDark
                                  ? Colors.white24
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                        child: Text(
                          cancelText ?? AppLocalizations.of(context)!.cancel,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          onConfirm();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(
                            0xFFFF3D00,
                          ), // STYLE_GUIDE: Expense Red
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          confirmText ??
                              AppLocalizations.of(context)!.slideDelete,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
