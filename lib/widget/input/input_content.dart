import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  double scale = 1.0;
  InputCubit? _inputCubit;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _inputCubit ??= context.read<InputCubit>();
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
    final locale = Localizations.localeOf(context).toString();

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 135),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark ? Colors.orange : Colors.amber,
                        ),
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
                          mode: CupertinoCalendarMode.dateTime,
                          use24hFormat: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      minLines: 1,
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isDark ? Colors.orange : Colors.amber,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.amber),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        label: Text(
                          AppLocalizations.of(context)!.inputDescription,
                        ),
                        labelStyle: const TextStyle(color: Colors.grey),
                        floatingLabelStyle: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        prefixIcon: const Icon(Icons.description),
                        prefixIconColor: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      keyboardType: locale == 'vi'
                          ? const TextInputType.numberWithOptions(
                              decimal: false,
                            )
                          : const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                      controller: moneyController,
                      inputFormatters: locale == 'vi'
                          ? [
                              FilteringTextInputFormatter.digitsOnly,
                              CurrencyFormat(),
                            ]
                          : [],
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isDark ? Colors.orange : Colors.amber,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.amber),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        label: Text(AppLocalizations.of(context)!.inputMoney),
                        labelStyle: const TextStyle(color: Colors.grey),
                        floatingLabelStyle: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        prefixIcon: const Icon(Icons.attach_money),
                        prefixIconColor: Colors.green,
                        suffixStyle: const TextStyle(fontSize: 20),
                        suffixText: locale == 'vi'
                            ? 'đ'
                            : (locale == 'zh' ? '¥' : '\$'),
                      ),
                    ),
                  ],
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
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
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
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    context.read<InputCubit>().selectCategory(
                      index,
                      catItem.id,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.5,
                        color: isSelected
                            ? (isDark ? Colors.orange : Colors.amber)
                            : Colors.transparent,
                      ),
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)]
                          .shade100
                          .withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          catItem.icon,
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          catItem.name,
                          style: TextStyle(
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: 120,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 63, 148, 66),
              Color.fromARGB(255, 77, 183, 80),
              Color.fromARGB(255, 89, 206, 93),
            ],
          ),
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            final state = context.read<InputCubit>().state;
            if (state.catId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Select a category")),
              );
              return;
            }
            context.read<InputCubit>().addTransaction(
              date: selectedDateTime,
              time: TimeOfDay.fromDateTime(selectedDateTime),
              description: descriptionController.text,
              money: moneyController.text,
              catId: state.catId!,
              context: context,
            );
            context.read<InputCubit>().resetSelection();
            setState(() {
              scale = 1.1;
            });
            Future.delayed(const Duration(milliseconds: 200), () {
              setState(() {
                scale = 1.0;
              });
            });
          },
          label: Row(
            children: [
              const Icon(Icons.add, size: 35, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                AppLocalizations.of(context)!.inputVave,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
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
