import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/bloc/input/input_cubit.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:money_mate/bloc/category/category_state.dart';
import 'package:money_mate/widget/category/category_manage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UpdateInput extends StatefulWidget {
  final Map<String, dynamic> inputItem;
  const UpdateInput({super.key, required this.inputItem});

  @override
  State<UpdateInput> createState() => _UpdateInputState();
}

class _UpdateInputState extends State<UpdateInput> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _moneyController = TextEditingController();
  final DateRangePickerController _dateController = DateRangePickerController();
  String? _selectedCatId;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.inputItem['description'];
    _moneyController.text = widget.inputItem['money'].toString();
    _dateController.selectedDate =
        DateFormat("dd/MM/yyyy").parse(widget.inputItem['date']);
    _selectedCatId = widget.inputItem['catId'];
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final isIncome = widget.inputItem['isIncome'];

    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 115),
              child: Column(
                children: [
                  _buildDatePicker(isDark),
                  const SizedBox(height: 10),
                  _buildTextField(
                      _descriptionController,
                      LocaleData.input_description.getString(context),
                      Icons.description,
                      Colors.blue,
                      isDark),
                  const SizedBox(height: 10),
                  _buildMoneyField(isDark),
                ],
              ),
            ),
            _buildCategorySection(isIncome, isDark),
          ]),
        ),
        _buildHeader(isIncome, isDark),
      ]),
      floatingActionButton: _buildSaveButton(isIncome),
    );
  }

  Widget _buildDatePicker(bool isDark) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.amber),
          borderRadius: BorderRadius.circular(10)),
      child: SfDateRangePicker(
        showNavigationArrow: true,
        selectionColor: Colors.deepOrangeAccent,
        controller: _dateController,
        headerStyle: const DateRangePickerHeaderStyle(
            textAlign: TextAlign.center,
            textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, Color iconColor, bool isDark) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.amber),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.amber),
            borderRadius: BorderRadius.circular(10)),
        label: Text(label),
        prefixIcon: Icon(icon, color: iconColor),
      ),
    );
  }

  Widget _buildMoneyField(bool isDark) {
    return TextField(
      controller: _moneyController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: isDark ? Colors.orange : Colors.amber),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.amber),
            borderRadius: BorderRadius.circular(10)),
        label: Text(LocaleData.input_money.getString(context)),
        prefixIcon: const Icon(Icons.attach_money, color: Colors.green),
      ),
    );
  }

  Widget _buildCategorySection(bool isIncome, bool isDark) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                isIncome
                    ? LocaleData.income_category.getString(context)
                    : LocaleData.expense_category.getString(context),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CategoryManage(isIncome: isIncome))),
                child: Text(LocaleData.more.getString(context))),
          ],
        ),
      ),
      BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          final cats =
              isIncome ? state.incomeCategories : state.expenseCategories;
          if (state.status == CategoryStatus.loading) {
            return const Shimmer(
                gradient: LinearGradient(colors: [Colors.grey, Colors.white]),
                child: SizedBox(height: 100));
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 85),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.6,
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8),
            itemCount: cats.length,
            itemBuilder: (context, index) {
              final cat = cats[index];
              final isSelected = _selectedCatId == cat['catId'];
              return InkWell(
                onTap: () => setState(() {
                  _selectedCatId = cat['catId'];
                }),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)]
                        .shade100
                        .withOpacity(0.35),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isSelected
                            ? (isDark ? Colors.orange : Colors.amber)
                            : Colors.transparent,
                        width: 2),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cat['icon'], style: const TextStyle(fontSize: 20)),
                        Text(cat['name'], overflow: TextOverflow.ellipsis),
                      ]),
                ),
              );
            },
          );
        },
      ),
    ]);
  }

  Widget _buildHeader(bool isIncome, bool isDark) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.blue[900]!, Colors.orange[900]!]
              : [Colors.orange, Colors.blue],
        ),
      ),
      child: SafeArea(
        child: Row(children: [
          const BackButton(color: Colors.white),
          Text(
              isIncome
                  ? LocaleData.income.getString(context)
                  : LocaleData.expense.getString(context),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
              child: Text('(${widget.inputItem['description']})',
                  style: const TextStyle(color: Colors.white70),
                  overflow: TextOverflow.ellipsis)),
        ]),
      ),
    );
  }

  Widget _buildSaveButton(bool isIncome) {
    return FloatingActionButton.extended(
      onPressed: () {
        if (_selectedCatId != null && _moneyController.text.isNotEmpty) {
          context.read<InputCubit>().updateTransaction(
                id: widget.inputItem['id'],
                date: DateFormat("dd/MM/yyyy")
                    .format(_dateController.selectedDate!),
                description: _descriptionController.text,
                money: _moneyController.text,
                catId: _selectedCatId!,
                isIncome: isIncome,
              );
          Navigator.pop(context);
        }
      },
      label: Text(LocaleData.update.getString(context)),
      icon: const Icon(Icons.edit_calendar),
      backgroundColor: Colors.green,
    );
  }
}
