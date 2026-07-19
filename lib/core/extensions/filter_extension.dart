import 'package:masrofy/features/home/controllers/reports_provider.dart';

extension ReportsFilterExtension on ReportsFilter{
  String  get name{
    switch (this) {
    case ReportsFilter.thisMonth:
        return 'هذا الشهر';
      case ReportsFilter.lastMonth:
        return 'الشهر الماضي';
      case ReportsFilter.thisYear:
        return 'هذا العام';
      case ReportsFilter.all:
        return 'الكل';
    }
  }
}