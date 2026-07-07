import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:masrofy/core/constants/app_assets.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/num_extension.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/core/widgets/custom_app_scaffold.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> _allGoals = [
    {
      'title': 'شراء سيارة',
      'current':'250,000',
      'target': '250,000',
      'percentage': 100,
      'progress': 1,
      'icon': Icons.directions_car_rounded,
      'color': AppColors.blue,
      'isActive': false,
    },
    {
      'title': 'سفر تركيا',
      'current': '12,500',
      'target': '25,000',
      'percentage': 50,
      'progress': 0.5,
      'icon': Icons.airplanemode_active_rounded,
      'color': AppColors.success,
      'isActive': true,
    },
    {
      'title': 'صندوق الطوارئ',
      'current': '8,000',
      'target': '10,000',
      'percentage': 80,
      'progress': 0.8,
      'icon': Icons.shield_rounded,
      'color': AppColors.success,
      'isActive': true,
    },
    {
      'title': 'شراء منزل',
      'current': '0',
      'target': '500,000',
      'percentage': 0,
      'progress': 0.0,
      'icon': Icons.home_rounded,
      'color': AppColors.expense,
      'isActive': true,
    },

    {
      'title': 'هاتف جديد',
      'current': '15,000',
      'target': '15,000',
      'percentage': 100,
      'progress': 1.0,
      'icon': Icons.phone_android_rounded,
      'color': AppColors.success,
      'isActive': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final iconColor = context.colorScheme.onSurface;

    final filteredGoals = _allGoals.where((goal) {
      if (_selectedTabIndex == 1) {
        return !goal['isActive'];
      }
      return goal['isActive'];
    }).toList();

    return AppScaffold(
      isDark: context.isDarkMode,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: iconColor,
                    size: AppSizes.iconM,
                  ),
                ),
                Text('الأهداف المالية', style: context.textTheme.titleLarge),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_rounded,
                    color: iconColor,
                    size: AppSizes.iconM,
                  ),
                ),
              ],
            ),
            AppSizes.m.verticalSpace,

            const _GoalsSummaryCard(),
            AppSizes.l.verticalSpace,

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabItem('نشطة', index: 0),
                AppSizes.l.horizontalSpace,
                _buildTabItem('مكتملة', index: 1),
              ],
            ),
            AppSizes.l.verticalSpace,

            if (filteredGoals.isEmpty)
              Center(
                child: Column(
                  children: [
                    AppSizes.xxl.verticalSpace,
                    Icon(
                      Icons.track_changes_outlined,
                      size: AppSizes.iconXL,
                      color: AppColors.grey400,
                    ),
                    AppSizes.m.verticalSpace,
                    Text(
                      'لا توجد أهداف هنا',
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
                itemCount: filteredGoals.length,
                separatorBuilder: (context, index) => AppSizes.m.verticalSpace,
                itemBuilder: (context, index) {
                  final goal = filteredGoals[index];
                  return _GoalCard(
                    title: goal['title'] as String,
                    current: goal['current'] as String,
                    target: goal['target'] as String,
                    percentage: goal['percentage'] as int,
                    progressValue: goal['progress'] as double,
                    icon: goal['icon'] as IconData,
                    color: goal['color'] as Color,
                  );
                },
              ),
          ],
        ).paddingAll(AppSizes.screenPadding),
      ),
    );
  }

  Widget _buildTabItem(String label, {required int index}) {
    final isSelected = _selectedTabIndex == index;
    final isDark = context.isDarkMode;
    final activeColor = AppColors.purple;

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

class _GoalsSummaryCard extends StatelessWidget {
  const _GoalsSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: 16.allPadding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.rXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إجمالي الأهداف',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AppSizes.xs.verticalSpace,
                Text(
                  '4',
                  style: context.textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSizes.s.verticalSpace,
                Text(
                  'المكتملة من 5',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
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

class _GoalCard extends StatelessWidget {
  final String title;
  final String current;
  final String target;
  final int percentage;
  final double progressValue;
  final IconData icon;
  final Color color;

  const _GoalCard({
    required this.title,
    required this.current,
    required this.target,
    required this.percentage,
    required this.progressValue,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      padding: 16.allPadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.rL),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.rM),
                ),
                child: Icon(icon, color: color, size: AppSizes.iconM),
              ),
              AppSizes.m.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleMedium
                  ),
                  4.verticalSpace,
                  Text(
                    '$current EGP',
                    style: context.textTheme.bodyMedium
                  ),
                  2.verticalSpace,
                  Text(
                    'من $target EGP',
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

          Row(
            children: [
              Text(
                '$percentage%',
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              8.horizontalSpace,
              SizedBox(
                width: 80.w,
                child: ClipRRect(
                  borderRadius:10.r.radius,
                  child: LinearProgressIndicator(
                    value: progressValue,
                    minHeight: 6.h,
                    backgroundColor: isDark
                        ? AppColors.borderDark
                        : AppColors.grey100,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
