import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/service/firabase_service.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/features/auth/providers/auth_provider.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseAuthProvider).currentUser;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: AppSizes.rXL,
          backgroundImage: user!.photoURL != null
              ? NetworkImage(user.photoURL!)
              : null,
          child: user.photoURL == null ? const Icon(Icons.person) : null,
        ),
        AppSizes.s.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مرحباً، ${user!.displayName}',
              style: context.textTheme.titleLarge,
            ),
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
