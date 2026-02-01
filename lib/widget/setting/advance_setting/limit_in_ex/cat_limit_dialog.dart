import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/services/currency_format.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:money_mate/bloc/category/category_state.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class CatLimitDialog extends StatefulWidget {
  final String catId;
  final String catName;
  final double limit;
  final UpdateLimitDtoLimitType? limitType;
  const CatLimitDialog({
    super.key,
    required this.catId,
    required this.catName,
    required this.limit,
    this.limitType,
  });

  @override
  State<CatLimitDialog> createState() => _CatLimitDialogState();
}

class _CatLimitDialogState extends State<CatLimitDialog> {
  final TextEditingController _limitController = TextEditingController();
  late CurrencyTextInputFormatter _formatter;
  bool _isFormatterInitialized = false;
  late UpdateLimitDtoLimitType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.limitType ?? UpdateLimitDtoLimitType.monthly;
  }

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

    return BlocListener<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state.status == CategoryStatus.success) {
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.limitSuccess,
            backgroundColor: Colors.green,
          );
          Navigator.pop(context);
        } else if (state.status == CategoryStatus.failure) {
          Fluttertoast.showToast(
            msg: state.errorMessage ?? AppLocalizations.of(context)!.limitFail,
            backgroundColor: Colors.red,
          );
          // Do not close dialog on failure
        }
      },
      child: AlertDialog(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
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
              const SizedBox(height: 16),
              DropdownButtonFormField<UpdateLimitDtoLimitType>(
                value: _selectedType,
                dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
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
                  label: Text(AppLocalizations.of(context)!.limitPeriod),
                  labelStyle: const TextStyle(color: Colors.grey),
                ),
                items: UpdateLimitDtoLimitType.values
                    .where(
                      (e) =>
                          e != UpdateLimitDtoLimitType.swaggerGeneratedUnknown,
                    )
                    .map((type) {
                      String label = '';
                      switch (type) {
                        case UpdateLimitDtoLimitType.daily:
                          label = AppLocalizations.of(context)!.daily;
                          break;
                        case UpdateLimitDtoLimitType.weekly:
                          label = AppLocalizations.of(context)!.weekly;
                          break;
                        case UpdateLimitDtoLimitType.monthly:
                          label = AppLocalizations.of(context)!.monthly;
                          break;
                        case UpdateLimitDtoLimitType.yearly:
                          label = AppLocalizations.of(context)!.yearly;
                          break;
                        default:
                          label = type.value ?? '';
                      }
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    })
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
            ],
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
                      _selectedType,
                      AppLocalizations.of(context)!,
                    );
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
      ),
    );
  }
}
