import 'package:flutter/foundation.dart';
import '../data/models/dashboard_summary.dart';

class DashboardProvider with ChangeNotifier {
  DashboardSummary? _summary;
  
  DashboardSummary? get summary => _summary;
}