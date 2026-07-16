import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/features/income/controller/income_controller.dart';
import 'package:masrofy/features/income/data/income_entry_model.dart';
import 'package:masrofy/features/income/view/widgets/income_form_sheet.dart';

class AddIncomeBottomSheet {
  const AddIncomeBottomSheet._();

  static void show(BuildContext context, {IncomeEntryModel? entry}) {
    final titleCtrl = TextEditingController(text: entry?.title ?? '');
    final descCtrl = TextEditingController(text: entry?.description ?? '');
    final amountCtrl = TextEditingController(
      text: entry != null ? entry.amount.toStringAsFixed(0) : '',
    );
    String cat = entry?.category ?? 'salary';
    int m = entry?.month ?? DateTime.now().month;
    int y = entry?.year ?? DateTime.now().year;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sc) => StatefulBuilder(
        builder: (ctx, setState) => Consumer(
          builder: (context, ref, _) => IncomeFormSheet(
            isDark: ctx.isDarkMode,
            isEditing: entry != null,
            titleController: titleCtrl,
            descriptionController: descCtrl,
            amountController: amountCtrl,
            selectedCategory: cat,
            onCategoryChanged: (val) => setState(() => cat = val),
            onDelete: entry == null
                ? null
                : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    ctx.pop();
                    await ref
                        .read(incomeControllerProvider.notifier)
                        .deleteEntry(entry.id);
                    messenger.showSnackBar(
                      const SnackBar(content: Text('تم حذف الدخل بنجاح')),
                    );
                  },
            onSave: () async {
              final title = titleCtrl.text.trim();
              final amt =
                  double.tryParse(amountCtrl.text.replaceAll(',', '')) ?? 0;
              final messenger = ScaffoldMessenger.of(ctx);
              if (title.isEmpty || amt <= 0) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('أدخل اسمًا صحيحًا ومبلغًا أكبر من صفر'),
                  ),
                );
                return;
              }
              final newEntry = IncomeEntryModel(
                id: entry?.id ?? '',
                title: title,
                description: descCtrl.text.trim(),
                amount: amt,
                month: m,
                year: y,
                category: cat,
              );
              try {
                final n = ref.read(incomeControllerProvider.notifier);
                if (entry != null) {
                  await n.updateEntry(newEntry);
                } else {
                  await n.addEntry(newEntry);
                }
                if (context.mounted) ctx.pop();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      entry != null
                          ? 'تم تعديل الدخل بنجاح'
                          : 'تمت إضافة الدخل بنجاح',
                    ),
                  ),
                );
              } catch (_) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('حدث خطأ أثناء حفظ البيانات')),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
