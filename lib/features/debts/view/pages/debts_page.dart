import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/num_extension.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/core/widgets/custom_app_bar.dart';
import 'package:masrofy/core/widgets/custom_app_scaffold.dart';
import 'package:masrofy/features/debts/controller/debts_controller.dart';
import 'package:masrofy/features/debts/models/debts_model.dart';
import 'package:masrofy/features/debts/view/pages/widgets/debt_card.dart';
import 'package:masrofy/features/debts/view/pages/widgets/debts_form.dart';
import 'package:masrofy/features/debts/view/pages/widgets/debts_summery_card.dart';
import 'package:masrofy/features/income/view/pages/income_page.dart';

class DebtsPage extends ConsumerStatefulWidget {
  const DebtsPage({super.key});

  @override
  ConsumerState<DebtsPage> createState() => _DebtsPageState();
}

class _DebtsPageState extends ConsumerState<DebtsPage> {
  int _selectedTabIndex = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _creditorController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _paidController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _creditorController.dispose();
    _totalController.dispose();
    _paidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final debtsState = ref.watch(debtsControllerProvider);

    return AppScaffold(
      isDark: context.isDarkMode,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomAppBar(title: 'الديون', onAddPressed: _showAddDebtSheet),
            AppSizes.m.verticalSpace,
            debtsState.when(
              data: (List<DebtModel> debts) {
                final filteredDebts = _selectedTabIndex == 1
                    ? debts.where((debt) => debt.isPaid).toList()
                    : debts.where((debt) => !debt.isPaid).toList();

                final totalRemaining = debts
                    .where((debt) => !debt.isPaid)
                    .fold<double>(0, (sum, debt) => sum + debt.remainingAmount);

                final totalAmount = debts.fold<double>(
                  0,
                  (sum, debt) => sum + debt.totalAmount,
                );

                final paidPercentage = totalAmount == 0
                    ? 0.0
                    : ((totalAmount -
                              debts.fold<double>(
                                0,
                                (sum, debt) => sum + debt.remainingAmount,
                              )) /
                          totalAmount *
                          100);

                return Column(
                  children: [
                    DebtsSummaryCard(
                      totalRemaining: totalRemaining,
                      paidPercentage: paidPercentage,
                    ),
                    AppSizes.l.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTabItem('نشطة', index: 0),
                        AppSizes.l.horizontalSpace,
                        _buildTabItem('مسددة', index: 1),
                      ],
                    ),

                    AppSizes.l.verticalSpace,
                    if (filteredDebts.isEmpty)
                      Center(
                        child: Column(
                          children: [
                            AppSizes.xxl.verticalSpace,
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: AppSizes.iconXL,
                              color: AppColors.grey400,
                            ),
                            AppSizes.m.verticalSpace,
                            Text(
                              'لا توجد ديون هنا',
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: AppColors.grey500,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredDebts.length,
                        separatorBuilder: (context, index) =>
                            AppSizes.m.verticalSpace,
                        itemBuilder: (context, index) {
                          final debt = filteredDebts[index];
                          return DebtCard(
                            debt: debt,
                            onTap: () => _showDebtFormSheet(debt: debt),
                          );
                        },
                      ),
                  ],
                );
              },
              loading: () => Center(
                child: Padding(
                  padding: 24.allPadding,
                  child: const CircularProgressIndicator(),
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: 24.allPadding,
                  child: Text(
                    'تعذر تحميل الديون',
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ],
        ).paddingAll(AppSizes.screenPadding),
      ),
    );
  }

  Future<void> _showAddDebtSheet() async {
    await _showDebtFormSheet();
  }

  Future<void> _showDebtFormSheet({DebtModel? debt}) async {
    final isDark = context.isDarkMode;
    final isEditing = debt != null;

    _titleController.text = debt?.title ?? '';
    _creditorController.text = debt?.creditor ?? '';
    _totalController.text = debt?.totalAmount.toStringAsFixed(0) ?? '';
    _paidController.text = debt?.paidAmount.toStringAsFixed(0) ?? '';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return DebtFormSheet(
          isDark: isDark,
          isEditing: isEditing,
          titleController: _titleController,
          creditorController: _creditorController,
          totalController: _totalController,
          paidController: _paidController,
          onDelete: isEditing
              ? () async {
                  context.pop();
                  await _deleteDebt(debt);
                }
              : null,
          onSave: () async {
            final title = _titleController.text.trim();
            final creditor = _creditorController.text.trim();
            final total = double.tryParse(_totalController.text) ?? 0;
            final paid = double.tryParse(_paidController.text) ?? 0;

            if (title.isEmpty || total <= 0) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('أدخل عنوانًا صحيحًا ومبلغًا أكبر من صفر'),
                ),
              );
              return;
            }

            final updatedDebt = DebtModel(
              id: debt?.id ?? '',
              title: title,
              creditor: creditor,
              totalAmount: total,
              paidAmount: paid,
            );

            try {
              final notifier = ref.read(debtsControllerProvider.notifier);
              if (isEditing) {
                await notifier.updateDebt(updatedDebt);
              } else {
                await notifier.addDebt(updatedDebt);
              }
              await notifier.refreshDebts();

              if (!mounted) return;
              _titleController.clear();
              _creditorController.clear();
              _totalController.clear();
              _paidController.clear();
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isEditing
                        ? 'تم تعديل الدين بنجاح'
                        : 'تمت إضافة الدين بنجاح',
                  ),
                ),
              );
            } catch (error) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isEditing
                        ? 'حدث خطأ أثناء تعديل الدين'
                        : 'حدث خطأ أثناء إضافة الدين',
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<void> _deleteDebt(DebtModel debt) async {
    try {
      await  ref.read(debtsControllerProvider.notifier).deleteDebt(debt.id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حذف الدين بنجاح')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء حذف الدين')));
    }
  }

  Widget _buildTabItem(String label, {required int index}) {
    final isSelected = _selectedTabIndex == index;
    final isDark = context.isDarkMode;
    final activeColor = AppColors.expense;

    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: context.textTheme.titleSmall?.copyWith(
              color: isSelected
                  ? activeColor
                  : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          AppSizes.xs.verticalSpace,
          Container(
            width: 70.w,
            height: 2.h,
            decoration: BoxDecoration(
              color: isSelected ? activeColor : Colors.transparent,
              borderRadius: 1.r.radius,
            ),
          ),
        ],
      ),
    );
  }
}

