import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';

class CatUpdateDialog extends StatefulWidget {
  final Map<String, dynamic> catItem;
  const CatUpdateDialog({super.key, required this.catItem});

  @override
  State<CatUpdateDialog> createState() => _CatUpdateDialogState();
}

class _CatUpdateDialogState extends State<CatUpdateDialog> {
  late final TextEditingController _iconController;
  late final TextEditingController _nameController;
  String? _iconError;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    _iconController = TextEditingController(text: widget.catItem['icon']);
    _nameController = TextEditingController(text: widget.catItem['name']);
  }

  @override
  void dispose() {
    _iconController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(
            LocaleData.updateCatTitle.getString(context),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '(${widget.catItem['name']})',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
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
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10)),
                label: Text(LocaleData.chooseAnIcon.getString(context)),
                prefixIcon:
                    const Icon(Icons.insert_emoticon, color: Colors.orange),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                errorText: _nameError,
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10)),
                label: Text(LocaleData.categoryName.getString(context)),
                prefixIcon:
                    const Icon(Icons.new_label, color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocaleData.cancel.getString(context),
              style: const TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _onUpdate,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Text(LocaleData.update.getString(context),
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _onUpdate() {
    setState(() {
      _iconError = _iconController.text.isEmpty
          ? LocaleData.catIconValidator.getString(context)
          : null;
      _nameError = _nameController.text.isEmpty
          ? LocaleData.catNameValidator.getString(context)
          : null;
    });

    if (_iconError == null && _nameError == null) {
      context.read<CategoryCubit>().updateCategory(
            widget.catItem['catId'],
            _iconController.text,
            _nameController.text,
            widget.catItem['isIncome'],
            widget.catItem['limit']?.toDouble() ?? 0.0,
          );
      Navigator.pop(context);
    }
  }

  void _showEmojiPicker(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 300,
        child: EmojiPicker(
          textEditingController: _iconController,
          config: Config(
            checkPlatformCompatibility: true,
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
