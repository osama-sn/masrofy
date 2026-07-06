import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/routes/app_routes.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/core/widgets/custom_buttons.dart';

class AuthBtn extends StatelessWidget {
  const AuthBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: "التسجيل من خلال جوجل",
      variant: ButtonVariant.outlined,
      onPressed: () {
        context.go(AppRoutes.home);
      },
      icon: FaIcon(FontAwesomeIcons.google, size: AppSizes.iconM),
      textStyle: context.textTheme.titleMedium,
    );
  }
}
