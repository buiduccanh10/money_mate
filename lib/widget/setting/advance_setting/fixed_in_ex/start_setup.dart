import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/currency_format.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:money_mate/bloc/category/category_state.dart';
import 'package:money_mate/bloc/schedule/schedule_cubit.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class StartSetup extends StatefulWidget {
  const StartSetup({super.key});

  @override
  State<StartSetup> createState() => _StartSetupState();
}

class _StartSetupState extends State<StartSetup> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _moneyController = TextEditingController();
  final DateRangePickerController _dateController = DateRangePickerController();
  String? _selectedCatId;
  int _selectedOptionIndex = 0;

  final List<String> _options = [
    'never',
    'daily',
    'weekly',
    'monthly',
    'yearly',
  ];

  @override
  void initState() {
    super.initState();
    _dateController.selectedDate = DateTime.now();
    context.read<CategoryCubit>().fetchCategories();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _moneyController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = FlutterLocalization.instance.currentLocale.toString();

    return Scaffold(
      appBar: AppBar(title: Text(LocaleData.setUp.getString(context))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildDatePicker(isDark),
              const SizedBox(height: 16),
              _buildTextField(
                _descriptionController,
                LocaleData.inputDescription.getString(context),
                Icons.description,
                Colors.blue,
                isDark,
              ),
              const SizedBox(height: 12),
              _buildMoneyField(isDark, locale),
              const SizedBox(height: 16),
              _buildCategorySection(isDark),
              const SizedBox(height: 16),
              _buildRepeatSection(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleSave,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.schedule, color: Colors.white),
        label: Text(
          LocaleData.setUp.getString(context),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDatePicker(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: isDark ? Colors.orange : Colors.amber),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SfDateRangePicker(
        showNavigationArrow: true,
        selectionColor: Colors.deepOrangeAccent,
        controller: _dateController,
        headerStyle: const DateRangePickerHeaderStyle(
          textAlign: TextAlign.center,
          textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    Color iconColor,
    bool isDark,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDark ? Colors.orange : Colors.amber),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: label,
        prefixIcon: Icon(icon, color: iconColor),
      ),
    );
  }

  Widget _buildMoneyField(bool isDark, String locale) {
    return TextField(
      controller: _moneyController,
      keyboardType: locale == 'vi'
          ? const TextInputType.numberWithOptions(decimal: false)
          : const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: locale == 'vi'
          ? [FilteringTextInputFormatter.digitsOnly, CurrencyFormat()]
          : [],
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDark ? Colors.orange : Colors.amber),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: LocaleData.inputMoney.getString(context),
        prefixIcon: const Icon(Icons.attach_money, color: Colors.green),
        suffixText: locale == 'vi' ? 'đ' : (locale == 'zh' ? '¥' : '\$'),
      ),
    );
  }

  Widget _buildCategorySection(bool isDark) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final categories = state.expenseCategories + state.incomeCategories;
        if (state.status == CategoryStatus.loading && categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleData.selectCategory.getString(context),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((cat) {
                final isSelected = _selectedCatId == cat.id;
                return InkWell(
                  onTap: () => setState(() => _selectedCatId = cat.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)]
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? Colors.orange : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(cat.icon),
                        const SizedBox(width: 4),
                        Text(cat.name),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRepeatSection(BuildContext context) {
    return Row(
      children: [
        Text(
          LocaleData.repeat.getString(context),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _showRepeatPicker,
          child: Text(
            _options[_selectedOptionIndex],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _showRepeatPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          itemExtent: 32,
          onSelectedItemChanged: (index) =>
              setState(() => _selectedOptionIndex = index),
          children: _options.map((o) => Center(child: Text(o))).toList(),
        ),
      ),
    );
  }

  void _handleSave() {
    if (_selectedCatId == null || _moneyController.text.isEmpty) return;

    final locale = FlutterLocalization.instance.currentLocale.toString();
    double money = 0;
    if (locale == 'vi') {
      money = double.tryParse(_moneyController.text.replaceAll('.', '')) ?? 0;
    } else {
      money = double.tryParse(_moneyController.text.replaceAll(',', '.')) ?? 0;
    }

    final catCubit = context.read<CategoryCubit>();
    final allCats =
        catCubit.state.incomeCategories + catCubit.state.expenseCategories;
    final cat = allCats.firstWhere((c) => c.id == _selectedCatId);

    context.read<ScheduleCubit>().addSchedule(
      date: DateFormat('dd/MM/yyyy').format(_dateController.selectedDate!),
      description: _descriptionController.text,
      money: money,
      catId: _selectedCatId!,
      icon: cat.icon,
      name: cat.name,
      isIncome: cat.isIncome,
      option: CreateScheduleDtoOption.values.firstWhere(
        (e) => e.name.toLowerCase() == _options[_selectedOptionIndex],
      ),
    );
    Navigator.pop(context);
  }
}
