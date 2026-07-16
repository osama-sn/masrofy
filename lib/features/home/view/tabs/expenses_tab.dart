import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masrofy/core/constants/app_assets.dart';
import 'package:masrofy/core/constants/data.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/num_extension.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/core/widgets/custom_app_bar.dart';
import 'package:masrofy/features/expenses/controller/expnese_controller.dart';
import 'package:masrofy/features/expenses/models/expense_entry_model.dart';
import 'package:masrofy/features/expenses/models/expnese_category.dart';
import 'package:masrofy/features/expenses/view/widgets/add_expense.dart';
import 'package:masrofy/features/expenses/view/widgets/months_list.dart';
import 'package:masrofy/features/home/view/widgets/summery_card.dart';

class TransactionsTab extends ConsumerStatefulWidget {
  const TransactionsTab({super.key});

  @override
  ConsumerState<TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends ConsumerState<TransactionsTab> {
  int _setMonth = DateTime.now().month;
  int _setYear = DateTime.now().year;
  String formatDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate == today) {
      return 'اليوم';
    } else if (checkDate == yesterday) {
      return 'أمس';
    } else {
      return DateFormat('d MMMM yyyy', 'ar').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseController = ref.watch(expenseControllerProvider);
    final isDark = context.isDarkMode;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomAppBar(
            title: "المصروفات",
            onAddPressed: () => AddExpenseBottomSheet.show(context),
          ).center(),
          AppSizes.m.verticalSpace,

          expenseController.when(
            data: (data) {
              final filterd = data
                  .where((e) => e.month == _setMonth && e.year == _setYear)
                  .toList();
              filterd.sort((a, b) => b.date.compareTo(a.date));
              final totalExpenses = filterd.fold<double>(
                0,
                (sum, e) => sum + e.amount,
              );
              final keys = {
                '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}',
                ...data.map((e) => e.monthYear),
              }.toList()..sort((a, b) => b.compareTo(a));

              final Map<String, List<ExpenseEntryModel>> grouped = {};
              for (var entry in filterd) {
                final label = formatDateLabel(entry.date);
                if (!grouped.containsKey(label)) {
                  grouped[label] = [];
                }
                grouped[label]!.add(entry);
              }
              // {
              //   "اليوم": [
              //     شراء بقالة (150 EGP),
              //     عشاء (200 EGP)
              //   ],
              //   "أمس": [
              //     بنزين (300 EGP)
              //   ]
              // }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  _ExpensesSummaryCard(
                    total: totalExpenses.toString(),
                    monthLabel: "${months[_setMonth - 1]}-$_setYear",
                  ),
                  AppSizes.l.verticalSpace,
                  MonthSelector(
                    monthYearKeys: keys,
                    selectedMonth: _setMonth,
                    selectedYear: _setYear,
                    activeColor: AppColors.expense,
                    onMonthSelected: (m, y) => setState(() {
                      _setMonth = m;
                      _setYear = y;
                    }),
                  ),
                  AppSizes.l.verticalSpace,
                  if (filterd.isEmpty)
                    Column(
                      children: [
                        AppSizes.xxl.verticalSpace,
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: AppSizes.iconXL,
                          color: AppColors.grey400,
                        ),
                        AppSizes.m.verticalSpace,
                        Text(
                          'لا توجد مصروفات مسجلة لهذا الشهر',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                        AppSizes.m.verticalSpace,
                        FilledButton.icon(
                          onPressed: () => AddExpenseBottomSheet.show(context),
                          icon: const Icon(Icons.add_rounded),
                          label: Text('إضافة مصروف'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.expense,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ).center()
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: grouped.keys.length,
                      itemBuilder: (context, index) {
                        final dateLabel = grouped.keys.elementAt(index);
                        final items = grouped[dateLabel]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                vertical: 8.h,
                              ),
                              child: Text(
                                dateLabel,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.cardDark
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.rL,
                                ),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.borderDark
                                      : AppColors.borderLight,
                                ),
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  thickness: 0.5,
                                  color: isDark
                                      ? AppColors.dividerDark
                                      : AppColors.dividerLight,
                                ),
                                itemBuilder: (context, itemIndex) {
                                  final item = items[itemIndex];
                                  return InkWell(
                                    onTap: () {
                                      AddExpenseBottomSheet.show(
                                        context,
                                        entry: item,
                                      );
                                    },
                                    child: _TransactionItem(
                                      expenseEntryModel: item,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                ],
              );
            },

            error: (err, stack) => Text(
              'تعذر تحميل المصروفات',
              style: context.textTheme.bodyMedium,
            ).center().paddingAll(AppSizes.xl),
            loading: () => CircularProgressIndicator.adaptive()
                .center()
                .paddingAll(AppSizes.xl),
          ),
        ],
      ).paddingAll(AppSizes.screenPadding),
    );
  }
}

class _ExpensesSummaryCard extends StatelessWidget {
  final String total;
  final String monthLabel;

  const _ExpensesSummaryCard({required this.total, required this.monthLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSizes.m.allPadding,
      decoration: BoxDecoration(
        gradient: AppColors.walletGradient,
        borderRadius: AppSizes.rXL.radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: Text info & Period selector
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إجمالي المصروفات',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppSizes.xs.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(total, style: context.textTheme.headlineMedium),
                  AppSizes.s.horizontalSpace,
                  Text('EGP', style: context.textTheme.titleMedium),
                ],
              ),
              AppSizes.m.verticalSpace,
              // Period selection pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: AppSizes.rM.radius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    AppSizes.xs.horizontalSpace,
                    Text(monthLabel, style: context.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ).expanded(),

          // Right side: Expenses illustration image
          AppSizes.s.horizontalSpace,
          Image.asset(
            AppAssets.goals,
            width: 120.w,
            height: 120.h,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final ExpenseEntryModel expenseEntryModel;

  const _TransactionItem({required this.expenseEntryModel});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final category = ExpenseCategory.getById(expenseEntryModel.category);
    final categoryName = category.nameAr;
    final timeStr = DateFormat('jm', 'ar').format(expenseEntryModel.date);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.m, vertical: 12.h),
      child: Row(
        children: [
          // Right side: Icon + Text info
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: AppSizes.iconS,
                ),
              ),
              AppSizes.m.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expenseEntryModel.title,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    expenseEntryModel.description,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // Middle: Time
          Text(
            timeStr,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),

          const Spacer(),

          // Left: Amount
          Text(
            '${expenseEntryModel.amount} EGP',
            style: context.textTheme.bodyLarge?.copyWith(
              color: AppColors.expense,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
