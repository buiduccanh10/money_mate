import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:money_mate/services/currency_format.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:money_mate/bloc/category/category_state.dart';
import 'package:money_mate/bloc/schedule/schedule_cubit.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';

class StartSetup extends StatefulWidget {
  const StartSetup({super.key});

  @override
  State<StartSetup> createState() => _StartSetupState();
}

class _StartSetupState extends State<StartSetup> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _moneyController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();
  String? _selectedCatId;
  int _selectedOptionIndex = 0;

  final List<CreateScheduleDtoOption> _options = [
    CreateScheduleDtoOption.daily,
    CreateScheduleDtoOption.weekly,
    CreateScheduleDtoOption.monthly,
    CreateScheduleDtoOption.yearly,
  ];
  late CurrencyTextInputFormatter _formatter;
  bool _isFormatterInitialized = false;

  bool _moneyError = false;
  bool _categoryError = false;

  String _getOptionLabel(CreateScheduleDtoOption option) {
    switch (option) {
      case CreateScheduleDtoOption.daily:
        return AppLocalizations.of(context)!.daily;
      case CreateScheduleDtoOption.weekly:
        return AppLocalizations.of(context)!.weekly;
      case CreateScheduleDtoOption.monthly:
        return AppLocalizations.of(context)!.monthly;
      case CreateScheduleDtoOption.yearly:
        return AppLocalizations.of(context)!.yearly;
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().fetchCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFormatterInitialized) {
      final locale = Localizations.localeOf(context).toString();
      _formatter = CurrencyFormat.getFormatter(locale);
      _isFormatterInitialized = true;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _moneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F7FA),
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
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.setUp,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDatePicker(isDark),
            const SizedBox(height: 20),
            _buildInputCard(
              isDark,
              child: Column(
                children: [
                  _buildTextField(
                    _descriptionController,
                    AppLocalizations.of(context)!.inputDescription,
                    Icons.description_outlined,
                    Colors.blue,
                    isDark,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(
                      height: 1,
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                    ),
                  ),
                  _buildMoneyField(isDark),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildCategorySection(isDark),
            const SizedBox(height: 20),
            _buildRepeatSection(context, isDark),
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _handleSave,
          backgroundColor: Colors.green,
          elevation: 0,
          highlightElevation: 0,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          label: Text(
            AppLocalizations.of(context)!.setUp,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(bool isDark, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDatePicker(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CupertinoCalendar(
          timeLabel: AppLocalizations.of(context)!.selectTime,
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
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(16),
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        prefixIcon: Icon(icon, color: iconColor),
      ),
    );
  }

  Widget _buildMoneyField(bool isDark) {
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
        prefixIconColor: Colors.orange,
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
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.selectCategory,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _categoryError
                      ? Colors.red
                      : (isDark ? Colors.white : Colors.black87),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: categories.map((cat) {
                  final isSelected = _selectedCatId == cat.id;
                  return InkWell(
                    onTap: () => setState(() {
                      _selectedCatId = cat.id;
                      _categoryError = false;
                    }),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                  ? Colors.blue.withValues(alpha: 0.2)
                                  : Colors.blue.withValues(alpha: 0.1))
                            : (isDark ? Colors.grey[800] : Colors.grey[100]),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue
                              : (_categoryError
                                    ? Colors.red
                                    : Colors.transparent),
                          width: isSelected || _categoryError ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(cat.icon),
                          const SizedBox(width: 8),
                          Text(
                            cat.name,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.blue
                                  : (isDark ? Colors.white70 : Colors.black87),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRepeatSection(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: _showRepeatPicker,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.repeat,
                    color: Colors.purple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  AppLocalizations.of(context)!.repeat,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  _getOptionLabel(_options[_selectedOptionIndex]),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.purple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRepeatPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          height: 250,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: CupertinoPicker(
            itemExtent: 32,
            backgroundColor: Colors.transparent,
            onSelectedItemChanged: (index) =>
                setState(() => _selectedOptionIndex = index),
            children: _options
                .map(
                  (o) => Center(
                    child: Text(
                      _getOptionLabel(o),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void _handleSave() {
    final double money = _formatter.getUnformattedValue().toDouble();

    setState(() {
      _categoryError = _selectedCatId == null;
      _moneyError = money <= 0;
    });

    if (_categoryError || _moneyError) {
      return;
    }

    final catCubit = context.read<CategoryCubit>();
    final allCats =
        catCubit.state.incomeCategories + catCubit.state.expenseCategories;
    final cat = allCats.firstWhere((c) => c.id == _selectedCatId);

    context.read<ScheduleCubit>().addSchedule(
      date: selectedDateTime.toIso8601String(),
      description: _descriptionController.text,
      money: money,
      catId: _selectedCatId!,
      icon: cat.icon,
      name: cat.name,
      isIncome: cat.isIncome,
      option: _options[_selectedOptionIndex],
    );
    Navigator.pop(context);
  }
}
