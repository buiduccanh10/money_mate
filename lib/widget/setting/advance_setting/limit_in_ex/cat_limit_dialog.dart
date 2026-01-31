import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/services/currency_format.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:intl/intl.dart';

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
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final locale = Localizations.localeOf(context).toString();
      if (locale == 'vi') {
        final formatter = NumberFormat("###,###,###", "vi_VN");
        _limitController.text = formatter.format(widget.limit);
      } else {
        _limitController.text = widget.limit.toString();
      }
      _isInitialized = true;
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
    final locale = Localizations.localeOf(context).toString();

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
          keyboardType: locale == 'vi'
              ? const TextInputType.numberWithOptions(decimal: false)
              : const TextInputType.numberWithOptions(decimal: true),
          controller: _limitController,
          inputFormatters: locale == 'vi'
              ? [FilteringTextInputFormatter.digitsOnly, CurrencyFormat()]
              : [],
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.attach_money, color: Colors.green),
            suffixText: locale == 'vi' ? 'đ' : '\$',
            suffixStyle: const TextStyle(fontWeight: FontWeight.bold),
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
                  String raw = _limitController.text;
                  double limit = 0;
                  if (locale == 'vi') {
                    limit = double.tryParse(raw.replaceAll('.', '')) ?? 0;
                  } else {
                    limit = double.tryParse(raw.replaceAll(',', '.')) ?? 0;
                  }
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
