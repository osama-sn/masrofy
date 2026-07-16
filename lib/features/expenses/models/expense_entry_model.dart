import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseEntryModel {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final int month;
  final int year;
  final String category;

  ExpenseEntryModel({required this.id, required this.title, required this.description, required this.amount, required this.date, required this.month, required this.year, required this.category});
  String get monthYear => "$year-${month.toString().padLeft(2,"0")}";
   factory ExpenseEntryModel.fromMap(String id, Map<String, dynamic> json) {
    DateTime parsedDate;
    final dateVal = json['date'];
    if (dateVal is Timestamp) {
      parsedDate = dateVal.toDate();
    } else if (dateVal is String) {
      parsedDate = DateTime.tryParse(dateVal) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }
     
     
    return ExpenseEntryModel(
      id: id,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: parsedDate,
      month: json['month'] as int? ?? parsedDate.month,
      year: json['year'] as int? ?? parsedDate.year,
      category: json['category'] as String? ?? 'other',
    );
  }
   Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'month': month,
      'year': year,
      'category': category,
    };
  }
}
