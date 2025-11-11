class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String type; // 'expense' or 'income'
  final double? budgetLimit;
  
  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    this.budgetLimit,
  });
  
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      type: json['type'] as String,
      budgetLimit: (json['budgetLimit'] as num?)?.toDouble(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'type': type,
      'budgetLimit': budgetLimit,
    };
  }
}

// features/goals/data/models/goal_model.dart
class GoalModel {
  final String id;
  final String name;
  final String icon;
  final double target;
  final double current;
  final DateTime deadline;
  final double monthlyContribution;
  
  GoalModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.target,
    required this.current,
    required this.deadline,
    required this.monthlyContribution,
  });
  
  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      target: (json['target'] as num).toDouble(),
      current: (json['current'] as num).toDouble(),
      deadline: DateTime.parse(json['deadline'] as String),
      monthlyContribution: (json['monthlyContribution'] as num).toDouble(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'target': target,
      'current': current,
      'deadline': deadline.toIso8601String(),
      'monthlyContribution': monthlyContribution,
    };
  }
  
  double get percentage => (current / target) * 100;
  double get remaining => target - current;
  
  int get monthsLeft {
    final now = DateTime.now();
    final months = ((deadline.year - now.year) * 12) + deadline.month - now.month;
    return months > 0 ? months : 0;
  }
}
