import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:money_mate/services/currency_format.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/input/input_cubit.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:money_mate/bloc/category/category_state.dart';
import 'package:money_mate/widget/category/category_manage.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:money_mate/widget/common/gradient_animated_button.dart';
import 'package:money_mate/widget/common/category_grid_item.dart';
import 'package:money_mate/widget/common/confirm_delete_dialog.dart';

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
  late CurrencyTextInputFormatter _formatter;
  bool _isFormatterInitialized = false;

  bool _moneyError = false;
  bool _categoryError = false;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.inputItem.description ?? '';
    // Initial value will be formatted in didChangeDependencies
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFormatterInitialized) {
      final locale = Localizations.localeOf(context).toString();
      _formatter = CurrencyFormat.getFormatter(locale);
      _moneyController.text = _formatter.formatDouble(widget.inputItem.money);
      _isFormatterInitialized = true;
    }
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
                      const Color(0xFF0F2027),
                      const Color(0xFF203A43),
                      const Color(0xFF2C5364),
                    ]
                  : [const Color(0xFF4364F7), const Color(0xFF6FB1FC)],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
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
        actions: [
          IconButton(
            onPressed: () => _showDeleteDialog(context),
            icon: const Icon(Icons.delete_outline, color: Colors.white),
          ),
        ],
      ),
      body: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF5F7FA),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildDatePicker(isDark),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _descriptionController,
                        AppLocalizations.of(context)!.inputDescription,
                        Icons.description_outlined,
                        Colors.blueAccent,
                        isDark,
                      ),
                      const SizedBox(height: 15),
                      _buildMoneyField(isDark, isIncome),
                    ],
                  ),
                ),
              ),
              _buildCategorySection(isIncome, isDark),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildSaveButton(isIncome),
    );
  }

  Widget _buildDatePicker(bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: CupertinoCalendar(
        weekdayDecoration: CalendarWeekdayDecoration(
          textStyle: TextStyle(fontSize: 12),
        ),
        monthPickerDecoration: CalendarMonthPickerDecoration(
          selectedCurrentDayStyle: CalendarMonthPickerSelectedCurrentDayStyle(
            textStyle: const TextStyle(fontSize: 12),
            mainColor: Color(0xFF4364F7),
            backgroundCircleColor: Color(0xFF4364F7),
          ),
          currentDayStyle: CalendarMonthPickerCurrentDayStyle(
            textStyle: const TextStyle(fontSize: 16, color: Colors.redAccent),
          ),
          selectedDayStyle: CalendarMonthPickerSelectedDayStyle(
            textStyle: const TextStyle(fontSize: 12),
            mainColor: Color(0xFF4364F7),
            backgroundCircleColor: Color(0xFF4364F7),
          ),
          defaultDayStyle: CalendarMonthPickerDefaultDayStyle(
            textStyle: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        footerDecoration: CalendarFooterDecoration(
          timeLabelStyle: const TextStyle(fontSize: 14),
          timeStyle: const TextStyle(fontSize: 14, color: Color(0xFF4364F7)),
        ),
        minimumDateTime: DateTime(1900),
        maximumDateTime: DateTime(2100),
        initialDateTime: selectedDateTime,
        onDateTimeChanged: (DateTime newDate) {
          setState(() {
            selectedDateTime = newDate;
          });
        },
        mode: CupertinoCalendarMode.dateTime,
        use24hFormat: true,
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
          borderSide: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(15),
        ),
        label: Text(label),
        prefixIcon: Icon(icon, color: iconColor),
      ),
    );
  }

  Widget _buildMoneyField(bool isDark, bool isIncome) {
    return TextField(
      controller: _moneyController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [_formatter],
      onChanged: (value) {
        if (_moneyError) {
          setState(() {
            _moneyError = false;
          });
        }
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _moneyError
                ? Colors.red
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _moneyError ? Colors.red : Colors.blueAccent,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        label: Text(AppLocalizations.of(context)!.inputMoney),
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black,
        ),
        prefixIcon: const Icon(Icons.attach_money),
        prefixIconColor: isIncome
            ? const Color(0xFF00C853)
            : const Color(0xFFFF3D00),
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _categoryError ? Colors.red : null,
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
                  showError: _categoryError,
                  onTap: () => setState(() {
                    _selectedCatId = cat.id;
                    _categoryError = false;
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
        final double money = _formatter.getUnformattedValue().toDouble();

        setState(() {
          _categoryError = _selectedCatId == null;
          _moneyError = money <= 0;
        });

        if (_categoryError || _moneyError) {
          return;
        }

        context.read<InputCubit>().updateTransaction(
          id: widget.inputItem.id,
          date: selectedDateTime,
          time: TimeOfDay.fromDateTime(selectedDateTime),
          description: _descriptionController.text,
          money: money,
          catId: _selectedCatId!,
          isIncome: isIncome,
          context: context,
        );
        Navigator.pop(context);
      },
      label: AppLocalizations.of(context)!.update,
      icon: Icons.edit_calendar,
    );
  }

  void _showDeleteDialog(BuildContext context) {
    ConfirmDeleteDialog.show(
      context,
      title: AppLocalizations.of(context)!.confirm,
      content: AppLocalizations.of(context)!.deleteTransactionConfirm,
      onConfirm: () {
        context.read<InputCubit>().deleteTransaction(
          widget.inputItem.id,
          context,
        );
        Navigator.pop(context);
      },
    );
  }
}
