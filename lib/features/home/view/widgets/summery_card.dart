
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masrofy/core/constants/app_assets.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/num_extension.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';

class SummeryCard extends StatelessWidget {
  const SummeryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.walletGradient,
        borderRadius: AppSizes.rXL.radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {},
              borderRadius: AppSizes.rS.radius,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "الملخص المالي",
                      style: context.textTheme.titleMedium,
                    ),
                    AppSizes.s.horizontalSpace,
                    Icon(
                      // _obscureBalances
                      //     ? Icons.visibility_off_outlined
                      // :
                      Icons.visibility_outlined,
                      color: Colors.white,
                      size: AppSizes.iconS,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AppSizes.s.verticalSpace,
    
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
    
                children: [
                  Text(
                    "إجمالي الرصيد",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  AppSizes.xs.verticalSpace,
                  Row(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '12,450',
                            // formatAmount('12,450'),
                            style: context.textTheme.displayMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          AppSizes.s.horizontalSpace,
                          Text(
                            'جنيه',
                            style: context.textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  AppSizes.xs.verticalSpace,
                  // Thin horizontal divider
                  Container(
                    height: 0.5,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  AppSizes.s.verticalSpace,
                  Row(
                    children: [
                      CardSubTitle(
                        title: "إجمالي الدخل",
                        value: "1800",
                        color: AppColors.primaryLight,
                      ),
                      AppSizes.m.horizontalSpace,
                      // Vertical Divider
                      Container(
                        width: 0.5,
                        height: 35.h,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      AppSizes.m.horizontalSpace,
    
                      CardSubTitle(
                        title: "إجمالي المصروف",
                        value: "9800",
                        color: AppColors.debt,
                      ),
                    ],
                  ),
                ],
              ),
              AppSizes.s.horizontalSpace,
              Image.asset(
                AppAssets.summery,
                width: 120.w,
                height: 120.h,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ],
      ).paddingAll(AppSizes.s),
    );
  }
}

class CardSubTitle extends StatelessWidget {
  const CardSubTitle({
    super.key,
    required this.title,
    required this.color,
    required this.value,
  });
  final String title;
  final Color color;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Text(
          title,
          style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.white.withValues(alpha: 0.7),
          ),
        ),
        AppSizes.s.verticalSpace,
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: context.textTheme.titleMedium?.copyWith(color: color),
              ),
              AppSizes.s.horizontalSpace,
              Text(
                'جنيه',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
