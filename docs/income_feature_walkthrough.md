# Income Feature Walkthrough

الملف ده معمول كمرجع سريع للشباب وهما شغالين على `income feature`.
الفكرة إننا نفهم الفيتشر من أول شكل الداتا لحد ما تظهر في الواجهة وتتخزن في Firestore.

## 1. الهدف من الفيتشر

الـ income feature مسؤولة عن إن المستخدم يقدر:

- يشوف إجمالي الدخل في شهر معين.
- يضيف دخل جديد.
- يعدل دخل موجود.
- يمسح دخل موجود.
- يفلتر الدخل حسب الشهر والسنة.
- يشوف كل دخل بتصنيفه، المبلغ، الاسم، والوصف.

## 2. تقسيم الملفات

الفيتشر متقسمة بالشكل ده:

```text
lib/features/income/
├── controller/
│   └── income_controller.dart
├── data/
│   └── income_entry_model.dart
├── repository/
│   └── income_repository.dart
└── view/
    ├── pages/
    │   └── income_page.dart
    └── widgets/
        ├── income_entry_card.dart
        ├── income_form_sheet.dart
        └── income_summary_card.dart
```

كل جزء له مسؤولية واضحة:

| الملف | المسؤولية |
| --- | --- |
| `income_entry_model.dart` | شكل الداتا وتحويلها من وإلى Firestore |
| `income_repository.dart` | التعامل المباشر مع Firestore |
| `income_controller.dart` | إدارة الحالة باستخدام Riverpod |
| `income_page.dart` | الصفحة الأساسية وتجميع كل أجزاء الواجهة |
| `income_summary_card.dart` | كارت إجمالي الدخل وعدد الإدخالات |
| `income_entry_card.dart` | كارت عرض دخل واحد |
| `income_form_sheet.dart` | Bottom sheet للإضافة والتعديل والحذف |

## 3. شكل الداتا

الموديل موجود في:

```text
lib/features/income/data/income_entry_model.dart
```

كل income entry فيها:

```dart
final String id;
final String title;
final String description;
final double amount;
final int month;
final int year;
final String category;
```

معنى كل field:

| Field | المعنى |
| --- | --- |
| `id` | ID بتاع document في Firestore |
| `title` | اسم الدخل، مثال: راتب شهر يوليو |
| `description` | وصف اختياري |
| `amount` | قيمة الدخل |
| `month` | رقم الشهر |
| `year` | السنة |
| `category` | التصنيف: salary, freelance, investment, bonus, other |

فيه getter مهم:

```dart
String get monthYear => '$year-${month.toString().padLeft(2, '0')}';
```

ده بيطلع key بالشكل ده:

```text
2026-07
```

وبيستخدم في ترتيب وعرض الشهور المتاحة.

## 4. التخزين في Firestore

التعامل مع Firestore موجود في:

```text
lib/features/income/repository/income_repository.dart
```

الداتا بتتخزن تحت المستخدم الحالي:

```text
users/{uid}/income_entries
```

الـ repository فيه 4 عمليات أساسية:

```dart
getIncomeEntries()
addIncomeEntry(entry)
updateIncomeEntry(entry)
deleteIncomeEntry(id)
```

مهم نفهم إن الـ repository ملوش علاقة بالـ UI. هو بس يعرف يقرأ ويكتب في Firestore.

## 5. إدارة الحالة باستخدام Riverpod

الـ controller موجود في:

```text
lib/features/income/controller/income_controller.dart
```

الـ provider:

```dart
final incomeControllerProvider =
    AsyncNotifierProvider<IncomeController, List<IncomeEntryModel>>(
      IncomeController.new,
    );
```

ده معناه إن الصفحة هتتعامل مع state من نوع:

```dart
AsyncValue<List<IncomeEntryModel>>
```

يعني الصفحة لازم تتعامل مع 3 حالات:

- `loading`
- `error`
- `data`

وده بيظهر في `IncomePage` عن طريق:

```dart
state.when(
  loading: ...
  error: ...
  data: ...
)
```

## 6. أول ما صفحة الدخل تفتح

الصفحة الأساسية موجودة في:

```text
lib/features/income/view/pages/income_page.dart
```

أول حاجة الصفحة بتعملها:

```dart
final state = ref.watch(incomeControllerProvider);
```

اللي بيحصل بعدها:

1. `IncomePage` تراقب `incomeControllerProvider`.
2. `IncomeController.build()` يشتغل.
3. الـ controller ينادي `_getEntries()`.
4. `_getEntries()` تنادي `repository.getIncomeEntries()`.
5. الـ repository يجيب الداتا من Firestore.
6. الداتا ترجع للصفحة كـ `List<IncomeEntryModel>`.

## 7. فلترة الدخل حسب الشهر

جوه `IncomePage` فيه شهر وسنة مختارين:

```dart
int _selMonth = DateTime.now().month;
int _selYear = DateTime.now().year;
```

بعد ما الداتا ترجع، الصفحة بتفلترها:

```dart
final filtered = entries
    .where((e) => e.month == _selMonth && e.year == _selYear)
    .toList();
```

يعني لو المستخدم مختار يوليو 2026، الصفحة تعرض بس الإدخالات اللي:

```text
month = 7
year = 2026
```

## 8. حساب إجمالي الدخل

بعد الفلترة، الصفحة بتحسب الإجمالي:

```dart
final total = filtered.fold<double>(
  0,
  (sum, e) => sum + e.amount,
);
```

الناتج ده بيتبعت لـ:

```dart
IncomeSummaryCard(
  totalIncome: total,
  entryCount: filtered.length,
  monthLabel: '${_months[_selMonth - 1]} $_selYear',
)
```

## 9. كارت ملخص الدخل

الملف:

```text
lib/features/income/view/widgets/income_summary_card.dart
```

الكارت بيعرض:

- اسم الشهر والسنة.
- إجمالي الدخل.
- عدد الإدخالات في الشهر.

الـ amount بيتعمله formatting هنا:

```dart
String _formatAmount(double value)
```

عشان يظهر مثلًا:

```text
12,500 EGP
```

بدل:

```text
12500
```

## 10. عرض قائمة الدخل

لو الشهر فيه دخل، الصفحة بتعرض:

```dart
ListView.separated(
  itemCount: filtered.length,
  itemBuilder: (context, idx) => IncomeEntryCard(
    entry: filtered[idx],
    onTap: () => _showForm(context, entry: filtered[idx]),
  ),
)
```

كل item بيتعرض من خلال:

```text
lib/features/income/view/widgets/income_entry_card.dart
```

الكارت بيعرض:

- icon حسب التصنيف.
- اسم الدخل.
- الوصف لو موجود.
- المبلغ.
- اسم التصنيف.

لما المستخدم يضغط على الكارت، الفورم يفتح في وضع التعديل.

## 11. حالة عدم وجود دخل

لو `filtered.isEmpty`، الصفحة بتعرض empty state:

- icon.
- رسالة إن مفيش دخل للشهر ده.
- زرار إضافة دخل.

وده مهم عشان المستخدم ما يحسش إن الصفحة فاضية أو فيها مشكلة.

## 12. إضافة دخل جديد

لما المستخدم يضغط زرار الإضافة، الصفحة تنادي:

```dart
_showForm(context)
```

الفورم بيتفتح كـ bottom sheet:

```dart
showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: ...
)
```

في حالة الإضافة:

```dart
entry == null
```

فالقيم الافتراضية بتكون:

```dart
title = ''
description = ''
amount = ''
category = 'salary'
month = _selMonth
year = _selYear
```

## 13. الفورم

الفورم موجود في:

```text
lib/features/income/view/widgets/income_form_sheet.dart
```

الفورم بياخد:

```dart
titleController
descriptionController
amountController
selectedCategory
onCategoryChanged
onSave
onDelete
```

مهم: الفورم نفسه `StatelessWidget`.

تغيير التصنيف بيتم من `IncomePage` باستخدام `StatefulBuilder`:

```dart
onCategoryChanged: (v) => setState(() => cat = v)
```

يعني الصفحة هي اللي ماسكة حالة التصنيف، والفورم بس بيعرض وينادي callbacks.

## 14. حفظ الدخل

لما المستخدم يضغط حفظ، `onSave` تعمل الآتي:

1. تقرأ البيانات من controllers.
2. تعمل trim للعنوان والوصف.
3. تحول المبلغ من `String` إلى `double`.
4. تتأكد إن العنوان مش فاضي.
5. تتأكد إن المبلغ أكبر من صفر.
6. تكوّن `IncomeEntryModel`.
7. لو إضافة، تنادي `addEntry`.
8. لو تعديل، تنادي `updateEntry`.
9. تقفل الـ bottom sheet.
10. تعرض snackbar بنجاح العملية.

الكود المهم:

```dart
final title = titleCtrl.text.trim();
final amt = double.tryParse(amountCtrl.text.replaceAll(',', '')) ?? 0;
```

والـ validation:

```dart
if (title.isEmpty || amt <= 0) {
  messenger.showSnackBar(...);
  return;
}
```

## 15. التعديل

لما المستخدم يضغط على income card:

```dart
_showForm(context, entry: filtered[idx])
```

في الحالة دي:

```dart
entry != null
```

فالفورم يفتح بالقيم القديمة:

```dart
final titleCtrl = TextEditingController(text: entry?.title ?? '');
final descCtrl = TextEditingController(text: entry?.description ?? '');
final amountCtrl = TextEditingController(
  text: entry != null ? entry.amount.toStringAsFixed(0) : '',
);
```

وعند الحفظ:

```dart
await n.updateEntry(newEntry);
```

## 16. الحذف

زرار الحذف بيظهر بس في وضع التعديل:

```dart
if (isEditing && onDelete != null)
```

عند الحذف:

```dart
await ref
    .read(incomeControllerProvider.notifier)
    .deleteEntry(entry.id);
```

بعدها الـ controller يعمل reload للداتا، والصفحة تتحدث تلقائيًا.

## 17. مسار الداتا بالكامل

ده flow مختصر من أول المستخدم يضغط حفظ:

```text
User taps Save
        ↓
IncomeFormSheet.onSave
        ↓
IncomePage creates IncomeEntryModel
        ↓
IncomeController.addEntry/updateEntry
        ↓
IncomeRepository.addIncomeEntry/updateIncomeEntry
        ↓
Firestore users/{uid}/income_entries
        ↓
Controller reloads entries
        ↓
Riverpod updates state
        ↓
IncomePage rebuilds
        ↓
Summary and list update
```

## 18. Checklist للشغل

قبل ما نقول إن الفيتشر خلصانة، نجرب:

- إضافة دخل جديد بعنوان ومبلغ صحيح.
- محاولة إضافة دخل بدون عنوان.
- محاولة إضافة دخل بمبلغ صفر.
- تعديل دخل موجود.
- حذف دخل موجود.
- التنقل بين الشهور.
- التأكد إن إجمالي الشهر بيتغير صح.
- التأكد إن عدد الإدخالات بيتغير صح.
- تجربة dark mode و light mode.
- تجربة شاشة صغيرة عشان bottom sheet والـ keyboard.

## 19. ملاحظات مهمة من الكود الحالي

### Route typo

في:

```text
lib/core/routes/app_routes.dart
```

المسار مكتوب:

```dart
static const String income = '/icome';
```

لو ده typo، الأفضل يبقى:

```dart
static const String income = '/income';
```

بس خلو بالكم: لو في أي مكان معتمد على `/icome` لازم يتحدث معاه.

### Arabic encoding

لو العربي ظاهر في التطبيق أو IDE بشكل غريب مثل:

```text
Ø§Ù„Ø¯Ø®Ù„
```

يبقى غالبًا الملفات محتاجة تتأكد إنها محفوظة بصيغة:

```text
UTF-8
```

### Controllers lifecycle

في `_showForm` فيه `TextEditingController` بيتعمل داخل function.
ده مقبول في bottom sheet بسيط، بس لو الفورم كبر أو بقى فيه منطق أكتر، ممكن يتحول لـ `StatefulWidget` ويتعمل `dispose` للـ controllers بشكل أوضح.

### Month and year in form

حاليًا الدخل الجديد بيتضاف للشهر المختار في الصفحة:

```dart
int m = entry?.month ?? _selMonth;
int y = entry?.year ?? _selYear;
```

لكن الفورم نفسه مفيهوش اختيار شهر وسنة. لو مطلوب المستخدم يضيف دخل لشهر مختلف، نحتاج نضيف picker للشهر والسنة.

## 20. تقسيم الشغل على الفريق

اقتراح تقسيم بسيط:

| الشخص | المهمة |
| --- | --- |
| Developer 1 | Model + Repository |
| Developer 2 | Controller + Riverpod state |
| Developer 3 | IncomePage + filtering + month selector |
| Developer 4 | UI widgets: summary, card, form sheet |
| Developer 5 | Testing + bug fixes + polish |

## 21. الخلاصة

أهم حاجة الشباب يفهموها:

```text
UI لا تكلم Firestore مباشرة.
UI تكلم Controller.
Controller يكلم Repository.
Repository يكلم Firestore.
```

وبكده الكود يفضل منظم وسهل يتعدل أو يتوسع بعدين.
