

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension NumExtension on num {
  EdgeInsets get allPadding => EdgeInsets.all(r);
EdgeInsets get horizontalPadding => EdgeInsets.symmetric(horizontal: w);

  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: h);
  BorderRadius get radius => BorderRadius.circular(r);
 
   String get formatAmount {
    final fixed = this % 1 == 0
        ? toStringAsFixed(0)
        : toStringAsFixed(2);
    return fixed.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }
}





