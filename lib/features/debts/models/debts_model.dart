
class DebtModel {
  final String id;
  final String title;
  final String creditor;
  final double totalAmount;
  final double paidAmount;

  const DebtModel({
    required this.id,
    required this.title,
    required this.creditor,
    required this.totalAmount,
    required this.paidAmount,
  });

  double get remainingAmount => totalAmount - paidAmount;

  double get progress => totalAmount == 0 ? 0 : paidAmount / totalAmount;

  int get percentage => (progress * 100).round();

  bool get isPaid => remainingAmount <= 0;

  factory DebtModel.fromMap(String id, Map<String, dynamic> json) {
    return DebtModel(
      id: id,
      title: json['title'] as String? ?? '',
      creditor: json['creditor'] as String? ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'creditor': creditor,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
    };
  }
}
