
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(radius: AppSizes.rL, child: Icon(Icons.person)),
        AppSizes.s.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('مرحباً، أسامة', style: context.textTheme.titleLarge),
            AppSizes.s.verticalSpace,
            Text(
              'التحكم في أموالك هو أول خطوة للحرية الماليه',
              style: context.textTheme.bodySmall!.copyWith(
                color: AppColors.grey300,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
