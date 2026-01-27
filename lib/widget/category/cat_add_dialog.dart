import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';

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

  @override
  void dispose() {
    _iconController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.addCatDialogTitle,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                label: Text(AppLocalizations.of(context)!.chooseAnIcon),
                prefixIcon: const Icon(
                  Icons.insert_emoticon,
                  color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                errorText: _nameError,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                label: Text(AppLocalizations.of(context)!.categoryName),
                prefixIcon: const Icon(
                  Icons.new_label,
                  color: Colors.blueAccent,
                ),
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
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.inputVave,
            style: const TextStyle(color: Colors.white),
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
        height: 300,
        child: EmojiPicker(
          textEditingController: _iconController,
          config: Config(
            checkPlatformCompatibility: true,
            locale: Localizations.localeOf(context),
            emojiViewConfig: EmojiViewConfig(
              backgroundColor: isDark ? Colors.black : Colors.white,
              columns: 7,
              buttonMode: ButtonMode.MATERIAL,
            ),
          ),
        ),
      ),
    );
  }
}
