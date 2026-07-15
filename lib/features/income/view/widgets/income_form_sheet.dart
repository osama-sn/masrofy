import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';

class IncomeFormSheet extends StatelessWidget {
  const IncomeFormSheet({
    super.key,
    required this.isDark,
    required this.isEditing,
    required this.titleController,
    required this.descriptionController,
    required this.amountController,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onSave,
    required this.onDelete,
  });

  final bool isDark;
  final bool isEditing;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController amountController;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onSave;
  final VoidCallback? onDelete;

  static const _categories = [
    {
      'key': 'salary',
      'label': 'راتب',
      'icon': Icons.business_center_rounded,
      'color': AppColors.primary,
    },
    {
      'key': 'freelance',
      'label': 'عمل حر',
      'icon': Icons.laptop_mac_rounded,
      'color': AppColors.purple,
    },
    {
      'key': 'investment',
      'label': 'استثمار',
      'icon': Icons.trending_up_rounded,
      'color': AppColors.cyan,
    },
    {
      'key': 'bonus',
      'label': 'مكافأة',
      'icon': Icons.card_giftcard_rounded,
      'color': AppColors.accent,
    },
    {
      'key': 'other',
      'label': 'أخرى',
      'icon': Icons.more_horiz_rounded,
      'color': AppColors.success,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.borderDark : AppColors.grey300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            AppSizes.m.verticalSpace,

            // Title
            Text(
              isEditing ? 'تعديل الدخل' : 'إضافة دخل جديد',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            AppSizes.l.verticalSpace,

            // Title field
            TextField(
              controller: titleController,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                labelText: 'اسم الدخل',
                hintText: 'مثال: راتب شهر يوليو',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title_rounded),
              ),
            ),
            AppSizes.m.verticalSpace,

            // Amount field
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                labelText: 'المبلغ',
                hintText: '0.00',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payments_rounded),
                suffixText: 'EGP',
              ),
            ),
            AppSizes.m.verticalSpace,

            // Description field
            TextField(
              controller: descriptionController,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                labelText: 'وصف (اختياري)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes_rounded),
              ),
            ),
            AppSizes.l.verticalSpace,

            // Category selector
            Text(
              'التصنيف',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            AppSizes.s.verticalSpace,
            SizedBox(
              height: 80.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                reverse: true,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => 10.horizontalSpace,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final key = cat['key'] as String;
                  final isSelected = selectedCategory == key;
                  final color = cat['color'] as Color;

                  return GestureDetector(
                    onTap: () => onCategoryChanged(key),
                    child: Column(
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color
                                : color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: Colors.white, width: 2)
                                : null,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            cat['icon'] as IconData,
                            color: isSelected ? Colors.white : color,
                            size: 22.sp,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          cat['label'] as String,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? (isDark ? Colors.white : Colors.black)
                                : AppColors.grey500,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            AppSizes.l.verticalSpace,

            // Actions
            Column(
              children: [
                if (isEditing && onDelete != null)
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: onDelete,
                      child: const Text(
                        'حذف الدخل',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onSave,
                    child: Text(isEditing ? 'تحديث الدخل' : 'حفظ الدخل'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
