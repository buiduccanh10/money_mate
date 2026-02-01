import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/services/currency_format.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class CatLimitDialog extends StatefulWidget {
  final String catId;
  final String catName;
  final double limit;
  const CatLimitDialog({
    super.key,
    required this.catId,
    required this.catName,
    required this.limit,
  });

  @override
  State<CatLimitDialog> createState() => _CatLimitDialogState();
}

class _CatLimitDialogState extends State<CatLimitDialog> {
  final TextEditingController _limitController = TextEditingController();
  late CurrencyTextInputFormatter _formatter;
  bool _isFormatterInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFormatterInitialized) {
      final locale = Localizations.localeOf(context).toString();
      _formatter = CurrencyFormat.getFormatter(locale);
      if (widget.limit > 0) {
        _limitController.text = _formatter.formatDouble(widget.limit);
      }
      _isFormatterInitialized = true;
    }
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      title: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.money_off_rounded,
              color: Colors.blue,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.catName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.limitDialog,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 320,
        child: TextField(
          autofocus: true,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: _limitController,
          inputFormatters: [_formatter],
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(15),
            ),
            label: Text(AppLocalizations.of(context)!.inputMoney),
            labelStyle: const TextStyle(color: Colors.grey),
            floatingLabelStyle: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
            prefixIcon: const Icon(Icons.attach_money),
            prefixIconColor: Colors.orange,
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  double limit = _formatter.getUnformattedValue().toDouble();
                  context.read<CategoryCubit>().updateLimit(
                    widget.catId,
                    limit,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.inputVave,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
