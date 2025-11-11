import 'package:flutter/foundation.dart';
import '../data/models/goal_model.dart';

class GoalProvider with ChangeNotifier {
  List<GoalModel> _goals = [];
  
  List<GoalModel> get goals => _goals;
}