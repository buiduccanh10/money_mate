import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/services/currency_format.dart';
import 'package:money_mate/services/locales.dart';
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

  @override
  void initState() {
    super.initState();
    final locale = FlutterLocalization.instance.currentLocale.toString();
    if (locale == 'vi') {
      final formatter = NumberFormat("###,###,###", "vi_VN");
      _limitController.text = formatter.format(widget.limit);
    } else {
      _limitController.text = widget.limit.toString();
    }
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = FlutterLocalization.instance.currentLocale.toString();

    return AlertDialog(
      title: Text(
        "${LocaleData.limitDialog.getString(context)}: ${widget.catName}",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      scrollable: true,
      content: SizedBox(
        width: 400,
        child: TextField(
          keyboardType: locale == 'vi'
              ? const TextInputType.numberWithOptions(decimal: false)
              : const TextInputType.numberWithOptions(decimal: true),
          controller: _limitController,
          inputFormatters: locale == 'vi'
              ? [FilteringTextInputFormatter.digitsOnly, CurrencyFormat()]
              : [],
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(10)),
            label: Text(LocaleData.inputMoney.getString(context)),
            prefixIcon: const Icon(Icons.money_off, color: Colors.green),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocaleData.cancel.getString(context),
              style: const TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            final locale =
                FlutterLocalization.instance.currentLocale.toString();
            String raw = _limitController.text;
            double limit = 0;
            if (locale == 'vi') {
              limit = double.tryParse(raw.replaceAll('.', '')) ?? 0;
            } else {
              limit = double.tryParse(raw.replaceAll(',', '.')) ?? 0;
            }
            context.read<CategoryCubit>().updateLimit(widget.catId, limit);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Text(LocaleData.inputVave.getString(context),
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
