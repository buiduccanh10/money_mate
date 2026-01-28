import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/input/input_cubit.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:money_mate/bloc/category/category_state.dart';
import 'package:money_mate/widget/category/category_manage.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:money_mate/widget/common/gradient_animated_button.dart';
import 'package:money_mate/widget/common/category_grid_item.dart';

class UpdateInput extends StatefulWidget {
  final TransactionResponseDto inputItem;
  const UpdateInput({super.key, required this.inputItem});

  @override
  State<UpdateInput> createState() => _UpdateInputState();
}

class _UpdateInputState extends State<UpdateInput> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _moneyController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();
  String? _selectedCatId;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.inputItem.description ?? '';
    _moneyController.text = widget.inputItem.money.toString();
    try {
      selectedDateTime = DateFormat("yyyy-MM-dd").parse(widget.inputItem.date);
    } catch (e) {
      selectedDateTime = DateFormat("dd/MM/yyyy").parse(widget.inputItem.date);
    }

    if (widget.inputItem.time.contains(':')) {
      final timeParts = widget.inputItem.time.split(':');
      selectedDateTime = selectedDateTime.copyWith(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    }

    _selectedCatId = widget.inputItem.catId;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final isIncome = widget.inputItem.isIncome;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color.fromARGB(255, 203, 122, 0),
                      const Color.fromARGB(255, 0, 112, 204),
                    ]
                  : [Colors.orange, Colors.blue],
            ),
          ),
        ),
        leading: const BackButton(color: Colors.white),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isIncome
                  ? AppLocalizations.of(context)!.income
                  : AppLocalizations.of(context)!.expense,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '(${widget.inputItem.description})',
                style: const TextStyle(color: Colors.white70, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  _buildDatePicker(isDark),
                  const SizedBox(height: 10),
                  _buildTextField(
                    _descriptionController,
                    AppLocalizations.of(context)!.inputDescription,
                    Icons.description,
                    Colors.blue,
                    isDark,
                  ),
                  const SizedBox(height: 10),
                  _buildMoneyField(isDark),
                ],
              ),
            ),
            _buildCategorySection(isIncome, isDark),
          ],
        ),
      ),
      floatingActionButton: _buildSaveButton(isIncome),
    );
  }

  Widget _buildDatePicker(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CupertinoCalendar(
          minimumDateTime: DateTime(1900),
          maximumDateTime: DateTime(2100),
          initialDateTime: selectedDateTime,
          onDateTimeChanged: (DateTime newDate) {
            setState(() {
              selectedDateTime = newDate;
            });
          },
          monthPickerDecoration: CalendarMonthPickerDecoration(),
          mode: CupertinoCalendarMode.dateTime,
          use24hFormat: true,
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
          borderSide: const BorderSide(color: Colors.amber),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber),
          borderRadius: BorderRadius.circular(10),
        ),
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
          borderSide: BorderSide(color: isDark ? Colors.orange : Colors.amber),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber),
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(AppLocalizations.of(context)!.inputMoney),
        prefixIcon: const Icon(Icons.attach_money, color: Colors.green),
      ),
    );
  }

  Widget _buildCategorySection(bool isIncome, bool isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isIncome
                    ? AppLocalizations.of(context)!.incomeCategory
                    : AppLocalizations.of(context)!.expenseCategory,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryManage(isIncome: isIncome),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.more),
              ),
            ],
          ),
        ),
        BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            final cats = isIncome
                ? state.incomeCategories
                : state.expenseCategories;
            if (state.status == CategoryStatus.loading) {
              return const Shimmer(
                gradient: LinearGradient(colors: [Colors.grey, Colors.white]),
                child: SizedBox(height: 100),
              );
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 85),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.6,
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: cats.length,
              itemBuilder: (context, index) {
                final cat = cats[index];
                final isSelected = _selectedCatId == cat.id;
                return CategoryGridItem(
                  icon: cat.icon,
                  name: cat.name,
                  isSelected: isSelected,
                  isDark: isDark,
                  onTap: () => setState(() {
                    _selectedCatId = cat.id;
                  }),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton(bool isIncome) {
    return GradientAnimatedButton(
      onPressed: () {
        if (_selectedCatId != null && _moneyController.text.isNotEmpty) {
          context.read<InputCubit>().updateTransaction(
            id: widget.inputItem.id,
            date: selectedDateTime,
            time: TimeOfDay.fromDateTime(selectedDateTime),
            description: _descriptionController.text,
            money: _moneyController.text,
            catId: _selectedCatId!,
            isIncome: isIncome,
            context: context,
          );
          Navigator.pop(context);
        }
      },
      label: AppLocalizations.of(context)!.update,
      icon: Icons.edit_calendar,
    );
  }
}
