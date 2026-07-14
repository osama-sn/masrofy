import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/routes/app_routes.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/core/widgets/custom_buttons.dart';
import 'package:masrofy/features/auth/providers/auth_provider.dart';

class AuthBtn extends ConsumerWidget {
  const AuthBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);
    return CustomButton(
      isLoading: authController.isLoading,
      text: "التسجيل من خلال جوجل",
      variant: ButtonVariant.outlined,
      onPressed: () async {
        bool success = await ref
            .read(authControllerProvider.notifier)
            .signInWithGoogle();
        if (success && context.mounted) {
          context.go(AppRoutes.home);
        }
      },
      icon: FaIcon(FontAwesomeIcons.google, size: AppSizes.iconM),
      textStyle: context.textTheme.titleMedium,
    );
  }
}
