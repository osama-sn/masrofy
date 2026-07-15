
class GoalModal {
  final String id;
  final String title;
  final double current;
  final double target;

  GoalModal({
    required this.id,
    required this.title,
    required this.current,
    required this.target,
  });
  double get progress => target == 0 ? 0 : current / target;
  int get percentage => (progress * 100).round();
  bool get isAcitve => current < target;
   factory GoalModal.fromMap(
    String id,
    Map<String, dynamic> json,
  ) {
    return GoalModal(
      id: id,
      title: json['title'],
      current: (json['current'] as num).toDouble(),
      target: (json['target'] as num).toDouble(),
     
    
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'current': current,
      'target': target,
      
    };
  }
}
