import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';

class GoalForm extends StatelessWidget {
  final bool isEditing;
  final TextEditingController titleController;
  final TextEditingController currentController;
  final TextEditingController targetController;
  final VoidCallback? onDelete;
  final VoidCallback onSave;

  const GoalForm({
    super.key,
    required this.isEditing,
    required this.titleController,
    required this.currentController,
    required this.targetController,
    required this.onDelete,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.grey300,
                borderRadius: BorderRadius.circular(999),
              ),
            ).center(),
            AppSizes.m.verticalSpace,
            Text(
              isEditing ? 'تعديل الهدف' : 'إضافة هدف جديد',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSizes.m.verticalSpace,
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'اسم الهدف',
                border: OutlineInputBorder(),
              ),
            ),
            AppSizes.m.verticalSpace,
            TextField(
              controller: currentController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'المبلغ الحالي',
                border: OutlineInputBorder(),
              ),
            ),
            AppSizes.m.verticalSpace,
            TextField(
              controller: targetController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'الهدف النهائي',
                border: OutlineInputBorder(),
              ),
            ),
            AppSizes.l.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  if (isEditing && onDelete != null)
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: onDelete,
                        child: const Text('حذف الهدف'),
                      ),
                    ),
                  FilledButton(
                    onPressed: onSave,
                    child: Text(isEditing ? 'تحديث الهدف' : 'حفظ الهدف'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
