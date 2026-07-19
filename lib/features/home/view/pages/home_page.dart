import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/features/expenses/view/widgets/add_expense.dart';
import 'package:masrofy/features/home/view/tabs/expenses_tab.dart';
import 'package:masrofy/features/home/view/tabs/home_tab.dart';
import 'package:masrofy/features/home/view/tabs/more_tab.dart';
import 'package:masrofy/features/home/view/tabs/reports_tab.dart';
import 'package:masrofy/features/home/view/widgets/home_bottom_navigation.dart';
import 'package:masrofy/features/income/view/widgets/add_income_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentNavIndex = 0; // الرئيسية selected by default

  final List<Widget> _tabs = [
    HomeTab(),
    ReportsTab(),
    SizedBox.shrink(), // FAB Placeholder
    TransactionsTab(),
    MoreTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _currentNavIndex, children: _tabs),
      ),
      bottomNavigationBar: HomeBottomNavigation(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          if (index == 2) {
            _showAddSelectionSheet(context);
          } else {
            setState(() {
              _currentNavIndex = index;
            });
          }
        },
      ),
    );
  }
}

/// Shows a beautiful selection bottom sheet to choose between
/// adding an Expense or an Income entry.
void _showAddSelectionSheet(BuildContext context) {
  final isDark = context.isDarkMode;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.rXL)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: isDark ? AppColors.borderDark : AppColors.grey300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          AppSizes.l.verticalSpace,

          // Title
          Text(
            'إضافة عملية جديدة',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSizes.l.verticalSpace,

          // Two option cards
          Row(
            children: [
              // Expense option
              Expanded(
                child: _AddOptionCard(
                  icon: Icons.shopping_bag_rounded,
                  label: 'مصروف',
                  color: AppColors.expense,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(ctx);
                    AddExpenseBottomSheet.show(context);
                  },
                ),
              ),
              AppSizes.m.horizontalSpace,
              // Income option
              Expanded(
                child: _AddOptionCard(
                  icon: Icons.trending_up_rounded,
                  label: 'دخل',
                  color: AppColors.income,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(ctx);
                    AddIncomeBottomSheet.show(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// A beautiful option card for the add-selection bottom sheet.
class _AddOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _AddOptionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.rL),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(AppSizes.rL),
            border: Border.all(
              color: isDark
                  ? AppColors.borderDark
                  : color.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28.sp),
              ),
              AppSizes.m.verticalSpace,
              Text(
                label,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
