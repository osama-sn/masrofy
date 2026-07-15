import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:masrofy/core/constants/app_assets.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/num_extension.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/core/widgets/custom_app_scaffold.dart';
import 'package:masrofy/features/goals/controllers/goal_controller.dart';
import 'package:masrofy/features/goals/models/goal_modal.dart';
import 'package:masrofy/features/goals/view/widgets/goal_card.dart';
import 'package:masrofy/features/goals/view/widgets/goal_form.dart';
import 'package:masrofy/features/goals/view/widgets/summery_card.dart';
import 'package:masrofy/features/income/presentation/pages/income_page.dart';

class GoalsPage extends ConsumerStatefulWidget {
  const GoalsPage({super.key});

  @override
  ConsumerState<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends ConsumerState<GoalsPage> {
  int _selectedTabIndex = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _currentController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = context.colorScheme.onSurface;

    final goalsController = ref.watch(goalsConrollerProvider);

    return AppScaffold(
      isDark: context.isDarkMode,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomAppBar(
              title: "الأهداف الماليه",
              addNewItem: _showAddGoalSheet,
            ),
            goalsController.when(
              data: (List<GoalModal> goals) {
                final filteredGoals = _selectedTabIndex == 1
                    ? goals.where((goal) => !goal.isAcitve).toList()
                    : goals.where((goal) => goal.isAcitve).toList();
                return Column(
                  children: [
                    GoalsSummaryCard(
                      total: goals.length.toString(),
                      achieved: goals
                          .map((goal) => goal.isAcitve)
                          .toList()
                          .length
                          .toString(),
                    ),
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
                        separatorBuilder: (context, index) =>
                            AppSizes.m.verticalSpace,
                        itemBuilder: (context, index) {
                          final goal = filteredGoals[index];
                          return InkWell(
                            onTap: () => _showAddGoalSheet(goal: goal),
                            child: GoalCard(
                              goal: goal,
                              icon: Icons.savings_rounded,
                              color: AppColors.purple,
                            ),
                          );
                        },
                      ),
                    AppSizes.m.verticalSpace,
                  ],
                );
              },
              error: (error, stackTrace) =>
                  Text("تعذر تحميل الاهداف").center().paddingAll(AppSizes.l),
              loading: () => CircularProgressIndicator.adaptive()
                  .center()
                  .paddingAll(AppSizes.l),
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

  Future<void> _deleteGoal(GoalModal goal) async {
    try {
      await ref.read(goalsConrollerProvider.notifier).deleteGoal(goal.id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حذف الهدف بنجاح')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء حذف الهدف')));
    }
  }

  Future<void> _onSave({GoalModal? goal}) async {
    final isEditing = goal != null;
    final newGoal = GoalModal(
      id: goal?.id ?? '',
      title: _titleController.text.trim(),
      current: double.tryParse(_currentController.text) ?? 0,
      target: double.tryParse(_targetController.text) ?? 0,
    );
    if (_titleController.text.isEmpty ||
        double.tryParse(_targetController.text)! <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل اسمًا صحيحًا وهدفًا أكبر من صفر')),
      );
      return;
    }
    try {
      final controller = ref.read(goalsConrollerProvider.notifier);
      if (!isEditing) {
        await controller.addGoal(newGoal);
      } else {
        await controller.updateGoal(newGoal);
      }
      _currentController.clear();
      _titleController.clear();
      _targetController.clear();
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing ? 'تم تعديل الهدف بنجاح' : 'تمت إضافة الهدف بنجاح',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'حدث خطأ أثناء تعديل الهدف'
                : 'حدث خطأ أثناء إضافة الهدف',
          ),
        ),
      );
    }
  }

  Future<void> _showAddGoalSheet({GoalModal? goal}) async {
    final isEditing = goal != null;
    _titleController.text = isEditing ? goal.title : "";
    _currentController.text = isEditing ? goal.current.toStringAsFixed(0) : "";
    _targetController.text = goal?.target.toStringAsFixed(0) ?? '';

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return GoalForm(
          isEditing: isEditing,
          titleController: _titleController,
          currentController: _currentController,
          targetController: _targetController,
          onDelete: isEditing
              ? () async {
                  context.pop();
                  await _deleteGoal(goal);
                }
              : null,
          onSave: () {
            _onSave(goal: isEditing ? goal : null);
          },
        );
      },
    );
  }
}
