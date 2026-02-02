import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:money_mate/services/currency_format.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:money_mate/bloc/category/category_state.dart';
import 'package:money_mate/bloc/schedule/schedule_cubit.dart';
import 'package:money_mate/data/network/swagger/generated/money_mate_api.swagger.dart';
import 'package:money_mate/widget/common/category_grid_item.dart';
import 'package:money_mate/widget/common/gradient_animated_button.dart';
import 'package:shimmer/shimmer.dart';

class StartSetup extends StatefulWidget {
  final ScheduleResponseDto? schedule;
  const StartSetup({super.key, this.schedule});

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

    if (widget.schedule != null) {
      final s = widget.schedule!;
      _descriptionController.text = s.description ?? '';
      _selectedCatId = s.catId;
      selectedDateTime = DateTime.tryParse(s.date) ?? DateTime.now();

      final optionIndex = _options.indexWhere((o) => o.value == s.option.value);
      if (optionIndex != -1) {
        _selectedOptionIndex = optionIndex;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFormatterInitialized) {
      final locale = Localizations.localeOf(context).toString();
      _formatter = CurrencyFormat.getFormatter(locale);
      _isFormatterInitialized = true;

      if (widget.schedule != null) {
        _moneyController.text = _formatter.formatDouble(widget.schedule!.money);
      }
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CupertinoCalendar(
                        timeLabel: AppLocalizations.of(context)!.selectTime,
                        weekdayDecoration: CalendarWeekdayDecoration(
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        monthPickerDecoration: CalendarMonthPickerDecoration(
                          selectedCurrentDayStyle:
                              CalendarMonthPickerSelectedCurrentDayStyle(
                                textStyle: const TextStyle(fontSize: 12),
                                mainColor: const Color(0xFF4364F7),
                                backgroundCircleColor: const Color(0xFF4364F7),
                              ),
                          currentDayStyle: CalendarMonthPickerCurrentDayStyle(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.redAccent,
                            ),
                          ),
                          selectedDayStyle: CalendarMonthPickerSelectedDayStyle(
                            textStyle: const TextStyle(fontSize: 12),
                            mainColor: const Color(0xFF4364F7),
                            backgroundCircleColor: const Color(0xFF4364F7),
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
                          timeStyle: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4364F7),
                          ),
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
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      _descriptionController,
                      AppLocalizations.of(context)!.inputDescription,
                      Icons.description_outlined,
                      Colors.blueAccent,
                      isDark,
                    ),
                    const SizedBox(height: 15),
                    _buildMoneyField(isDark),
                  ],
                ),
              ),
            ),

            // Repeat Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildRepeatSection(context, isDark),
            ),
            const SizedBox(height: 20),

            // Category Section Title
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15,
                top: 10,
                bottom: 10,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.selectCategory,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _categoryError
                        ? Colors.red
                        : (isDark ? Colors.white : Colors.black87),
                  ),
                ),
              ),
            ),

            _buildCategoryGrid(context, isDark),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: _buildSaveButton(context),
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
      minLines: 1,
      maxLines: 2,
      keyboardType: TextInputType.text,
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
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black,
        ),
        prefixIcon: Icon(icon),
        prefixIconColor: iconColor,
      ),
    );
  }

  Widget _buildMoneyField(bool isDark) {
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: _moneyController,
      inputFormatters: [_formatter],
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
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

  Widget _buildCategoryGrid(BuildContext context, bool isDark) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, catState) {
        if (catState.status == CategoryStatus.loading &&
            catState.incomeCategories.isEmpty &&
            catState.expenseCategories.isEmpty) {
          return _buildShimmerGrid(isDark);
        }

        final categories =
            catState.expenseCategories + catState.incomeCategories;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 85),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 16 / 10,
            crossAxisCount: 4,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            final catItem = categories[index];
            bool isSelected = _selectedCatId == catItem.id;
            return CategoryGridItem(
              icon: catItem.icon,
              name: catItem.name,
              isSelected: isSelected,
              isDark: isDark,
              showError: _categoryError,
              onTap: () {
                setState(() {
                  _selectedCatId = catItem.id;
                  _categoryError = false;
                });
              },
            );
          },
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

  Widget _buildShimmerGrid(bool isDark) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 16 / 10,
        crossAxisCount: 4,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 85),
      itemCount: 8,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return GradientAnimatedButton(
      onPressed: _handleSave,
      label: AppLocalizations.of(context)!.setUp,
      icon: Icons.check_circle_outline,
      width: 140, // Increased width for "Set Up" or similar text
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

    if (widget.schedule != null) {
      context.read<ScheduleCubit>().updateSchedule(
        id: widget.schedule!.id.toString(),
        date: selectedDateTime.toIso8601String(),
        description: _descriptionController.text,
        money: money,
        catId: _selectedCatId!,
        icon: cat.icon,
        name: cat.name,
        isIncome: cat.isIncome,
        option: _options[_selectedOptionIndex],
      );
    } else {
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
    }
    Navigator.pop(context);
  }
}
