import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/services/currency_format.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/input/input_cubit.dart';
import 'package:money_mate/bloc/input/input_state.dart';
import 'package:money_mate/widget/category/category_manage.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:money_mate/bloc/category/category_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:money_mate/widget/common/gradient_animated_button.dart';
import 'package:money_mate/widget/common/category_grid_item.dart';

class InputContent extends StatefulWidget {
  final bool isIncome;

  const InputContent({super.key, required this.isIncome});

  @override
  State<InputContent> createState() => _InputContentState();
}

class _InputContentState extends State<InputContent> {
  final descriptionController = TextEditingController();
  final moneyController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();
  InputCubit? _inputCubit;
  late CurrencyTextInputFormatter _formatter;
  bool _isFormatterInitialized = false;

  bool _moneyError = false;
  bool _categoryError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _inputCubit ??= context.read<InputCubit>();
    if (!_isFormatterInitialized) {
      final locale = Localizations.localeOf(context).toString();
      _formatter = CurrencyFormat.getFormatter(locale);
      _isFormatterInitialized = true;
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    moneyController.dispose();
    _inputCubit?.resetSelection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<InputCubit, InputState>(
      listener: (context, state) {
        if (state.status == InputStatus.success) {
          descriptionController.clear();
          moneyController.clear();
          ScaffoldMessenger.of(context).showToast(
            msg: "Saved! Check home screen.",
            backgroundColor: Colors.green,
          );
        } else if (state.status == InputStatus.overLimit) {
          ScaffoldMessenger.of(context).showToast(
            msg: "Over limit! ${state.overLimitMessage}",
            backgroundColor: Colors.orange,
          );
        } else if (state.status == InputStatus.failure) {
          ScaffoldMessenger.of(context).showToast(
            msg: state.errorMessage ?? "Error",
            backgroundColor: Colors.red,
          );
        }
      },
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF5F7FA),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 140),
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
                          weekdayDecoration: CalendarWeekdayDecoration(
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          monthPickerDecoration: CalendarMonthPickerDecoration(
                            selectedCurrentDayStyle:
                                CalendarMonthPickerSelectedCurrentDayStyle(
                                  textStyle: const TextStyle(fontSize: 12),
                                  mainColor: const Color(0xFF4364F7),
                                  backgroundCircleColor: const Color(
                                    0xFF4364F7,
                                  ),
                                ),
                            currentDayStyle: CalendarMonthPickerCurrentDayStyle(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.redAccent,
                              ),
                            ),
                            selectedDayStyle:
                                CalendarMonthPickerSelectedDayStyle(
                                  textStyle: const TextStyle(fontSize: 12),
                                  mainColor: const Color(0xFF4364F7),
                                  backgroundCircleColor: const Color(
                                    0xFF4364F7,
                                  ),
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
                      TextField(
                        minLines: 1,
                        maxLines: 2,
                        keyboardType: TextInputType.text,
                        controller: descriptionController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.grey[700]!
                                  : Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.inputDescription,
                          ),
                          labelStyle: const TextStyle(color: Colors.grey),
                          floatingLabelStyle: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          prefixIcon: const Icon(Icons.description_outlined),
                          prefixIconColor: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: moneyController,
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
                                  : (isDark
                                        ? Colors.grey[700]!
                                        : Colors.grey[300]!),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _moneyError
                                  ? Colors.red
                                  : Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          label: Text(AppLocalizations.of(context)!.inputMoney),
                          labelStyle: const TextStyle(color: Colors.grey),
                          floatingLabelStyle: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          prefixIcon: const Icon(Icons.attach_money),
                          prefixIconColor: widget.isIncome
                              ? const Color(0xFF00C853)
                              : const Color(0xFFFF3D00),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isIncome
                          ? AppLocalizations.of(context)!.incomeCategory
                          : AppLocalizations.of(context)!.expenseCategory,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _categoryError ? Colors.red : null,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CategoryManage(isIncome: widget.isIncome),
                          ),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.more),
                    ),
                  ],
                ),
              ),
              _buildCategoryGrid(context, isDark),
            ],
          ),
        ),
        floatingActionButton: _buildSaveButton(context),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, bool isDark) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, catState) {
        return BlocBuilder<InputCubit, InputState>(
          builder: (context, inputState) {
            if (catState.status == CategoryStatus.loading &&
                catState.incomeCategories.isEmpty) {
              return _buildShimmerGrid(isDark);
            }

            final categories = widget.isIncome
                ? catState.incomeCategories
                : catState.expenseCategories;

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
                bool isSelected = inputState.catId == catItem.id;
                return CategoryGridItem(
                  icon: catItem.icon,
                  name: catItem.name,
                  isSelected: isSelected,
                  isDark: isDark,
                  showError: _categoryError,
                  onTap: () {
                    context.read<InputCubit>().selectCategory(
                      index,
                      catItem.id,
                    );
                    setState(() {
                      _categoryError = false;
                    });
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return GradientAnimatedButton(
      onPressed: () {
        final state = context.read<InputCubit>().state;
        final double money = _formatter.getUnformattedValue().toDouble();

        setState(() {
          _categoryError = state.catId == null;
          _moneyError = money <= 0;
        });

        if (_categoryError || _moneyError) {
          return;
        }

        context.read<InputCubit>().addTransaction(
          date: selectedDateTime,
          time: TimeOfDay.fromDateTime(selectedDateTime),
          description: descriptionController.text,
          money: money,
          catId: state.catId!,
          context: context,
        );
        context.read<InputCubit>().resetSelection();
        moneyController.clear();
        descriptionController.clear();
      },
      label: AppLocalizations.of(context)!.inputVave,
      icon: Icons.add,
      width: 120,
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
}

extension ScaffoldToast on ScaffoldMessengerState {
  void showToast({required String msg, Color backgroundColor = Colors.black}) {
    showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
