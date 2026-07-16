import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masrofy/core/constants/data.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/core/widgets/custom_app_bar.dart';
import 'package:masrofy/core/widgets/custom_app_scaffold.dart';
import 'package:masrofy/features/income/controller/income_controller.dart';
import 'package:masrofy/features/income/view/widgets/add_income_sheet.dart';
import 'package:masrofy/features/income/view/widgets/income_entry_card.dart';
import 'package:masrofy/features/income/view/widgets/income_summary_card.dart';

class IncomePage extends ConsumerStatefulWidget {
  const IncomePage({super.key});
  @override
  ConsumerState<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends ConsumerState<IncomePage> {
  int _selMonth = DateTime.now().month;
 int _selYear = DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(incomeControllerProvider);
    return AppScaffold(
      isDark: context.isDarkMode,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomAppBar(
              title: 'الدخل',
              onAddPressed: () => AddIncomeBottomSheet.show(context),
            ),
            AppSizes.m.verticalSpace,
            state.when(
              loading: () =>
                  const CircularProgressIndicator().center().paddingAll(24),
              error: (_, __) => Text(
                'تعذر تحميل الدخل',
                style: context.textTheme.bodyMedium,
              ).center().paddingAll(24),
              data: (entries) {
                final filtered = entries
                    .where((e) => e.month == _selMonth && e.year == _selYear)
                    .toList();
                final total = filtered.fold<double>(
                  0,
                  (sum, e) => sum + e.amount,
                );
                final keys = {
                  '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}',
                  ...entries.map((e) => e.monthYear),
                }.toList()..sort((a, b) => b.compareTo(a));
 
                return Column(
                  children: [
                    IncomeSummaryCard(
                      totalIncome: total,
                      entryCount: filtered.length,
                      monthLabel: '${months[_selMonth - 1]} $_selYear',
                    ),
                    AppSizes.l.verticalSpace,
                    SizedBox(
                      height: 36.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        itemCount: keys.length,
                        separatorBuilder: (_, __) => 8.horizontalSpace,
                        itemBuilder: (context, i) {
                         
                          final p = keys[i].split('-');
                          final y = int.parse(p[0]),m = int.parse(p[1]);
                          final active = _selMonth == m && _selYear == y;
                          return GestureDetector(
                            onTap: () => setState(() {
                              _selMonth = m;
                              _selYear = y;
                            }),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.income
                                    : (context.isDarkMode
                                          ? AppColors.cardDark
                                          : AppColors.grey100),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.rM,
                                ),
                                border: active
                                    ? null
                                    : Border.all(
                                        color: context.isDarkMode
                                            ? AppColors.borderDark
                                            : AppColors.borderLight,
                                      ),
                              ),
                              child: Text(
                                '${months[m - 1]} $y',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: active
                                      ? Colors.white
                                      : (context.isDarkMode
                                            ? AppColors.textSecondaryDark
                                            : AppColors.textSecondaryLight),
                                  fontWeight: active
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    AppSizes.l.verticalSpace,
                    if (filtered.isEmpty)
                      Column(
                        children: [
                          AppSizes.xxl.verticalSpace,
                          Icon(
                            Icons.payments_outlined,
                            size: AppSizes.iconXL,
                            color: AppColors.grey400,
                          ),
                          AppSizes.m.verticalSpace,
                          Text(
                            'لا يوجد دخل مسجل لهذا الشهر',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColors.grey500,
                            ),
                          ),
                          AppSizes.m.verticalSpace,
                          FilledButton.icon(
                            onPressed: () => AddIncomeBottomSheet.show(context),
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('إضافة دخل'),
                          ),
                        ],
                      ).center()
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => AppSizes.m.verticalSpace,
                        itemBuilder: (context, idx) => IncomeEntryCard(
                          entry: filtered[idx],
                          onTap: () => AddIncomeBottomSheet.show(context, entry: filtered[idx]),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ).paddingAll(AppSizes.screenPadding),
      ),
    );
  }
}

