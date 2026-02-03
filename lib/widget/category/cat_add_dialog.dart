import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';

class CatAddDialog extends StatefulWidget {
  final bool isIncome;
  const CatAddDialog({super.key, required this.isIncome});

  @override
  State<CatAddDialog> createState() => _CatAddDialogState();
}

class _CatAddDialogState extends State<CatAddDialog> {
  final TextEditingController _iconController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _iconError;
  String? _nameError;

  Color get primaryColor =>
      widget.isIncome ? const Color(0xFF00C853) : const Color(0xFFFF3D00);

  @override
  void dispose() {
    _iconController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      title: Text(
        AppLocalizations.of(context)!.addCatDialogTitle,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      scrollable: true,
      content: SizedBox(
        width: 400,
        child: Column(
          children: [
            TextField(
              controller: _iconController,
              readOnly: true,
              onTap: () => _showEmojiPicker(context),
              decoration: InputDecoration(
                errorText: _iconError,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                label: Text(AppLocalizations.of(context)!.chooseAnIcon),
                labelStyle: TextStyle(
                  color: isDark ? Colors.grey : Colors.grey[600],
                ),
                prefixIcon: const Icon(
                  Icons.insert_emoticon,
                  color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                errorText: _nameError,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                label: Text(AppLocalizations.of(context)!.categoryName),
                labelStyle: TextStyle(
                  color: isDark ? Colors.grey : Colors.grey[600],
                ),
                prefixIcon: Icon(Icons.new_label, color: primaryColor),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: _onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
            AppLocalizations.of(context)!.inputVave,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _onSave() {
    setState(() {
      _iconError = _iconController.text.isEmpty
          ? AppLocalizations.of(context)!.catIconValidator
          : null;
      _nameError = _nameController.text.isEmpty
          ? AppLocalizations.of(context)!.catNameValidator
          : null;
    });

    if (_iconError == null && _nameError == null) {
      context.read<CategoryCubit>().addCategory(
        _iconController.text,
        _nameController.text,
        widget.isIncome,
        0,
        CreateCategoryDtoLimitType.monthly,
      );
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.toastAddSuccess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
    }
  }

  void _showEmojiPicker(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      useSafeArea: true,
      useRootNavigator: true,
      context: context,
      builder: (_) => SizedBox(
        height: 320,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: EmojiPicker(
            textEditingController: _iconController,
            config: Config(
              checkPlatformCompatibility: true,
              locale: Localizations.localeOf(context),
              emojiViewConfig: EmojiViewConfig(
                backgroundColor: isDark
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
                buttonMode: ButtonMode.MATERIAL,
                recentsLimit: 28,
                noRecents: Text(
                  AppLocalizations.of(context)!.noAvailable,
                  style: TextStyle(
                    fontSize: 20,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              categoryViewConfig: CategoryViewConfig(
                initCategory: Category.RECENT,
                backgroundColor: isDark
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
                indicatorColor: primaryColor,
                iconColorSelected: primaryColor,
                iconColor: Colors.grey,
              ),
              searchViewConfig: SearchViewConfig(
                backgroundColor: isDark
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
                buttonIconColor: isDark ? Colors.white : Colors.black,
                hintTextStyle: TextStyle(
                  color: isDark ? Colors.grey : Colors.grey[600],
                ),
              ),
              bottomActionBarConfig: BottomActionBarConfig(
                enabled: true,
                backgroundColor: isDark
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
                buttonColor: Colors.transparent,
                buttonIconColor: primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
