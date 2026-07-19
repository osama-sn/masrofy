import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masrofy/core/routes/app_routes.dart';
import 'package:masrofy/core/service/firabase_service.dart';
import 'package:masrofy/core/themes/theme_mode_provider.dart';
import 'package:masrofy/features/auth/providers/auth_provider.dart';

class MoreTab extends ConsumerWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final user = ref.watch(firebaseAuthProvider).currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('المزيد')),
      body: ListView(
        children: [
          if (user != null)
            ListTile(
              leading: CircleAvatar(
                backgroundImage: user.photoURL != null
                    ? NetworkImage(user.photoURL!)
                    : null,
                child: user.photoURL == null ? const Icon(Icons.person) : null,
              ),
              title: Text(user.displayName ?? 'userName'.tr()),
              subtitle: Text(user.email ?? 'userEmail'.tr()),
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text("تغيير المظهر"),
            trailing: DropdownButton<ThemeMode>(
              value: currentThemeMode,
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('التلقائي'),
                ),
                DropdownMenuItem(value: ThemeMode.light, child: Text('فاتح')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('داكن')),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('تغيير اللغه'),
            trailing: Text(
              context.locale.languageCode == 'ar' ? 'العربية' : 'English',
            ),
            onTap: () {
              final isArabic = context.locale.languageCode == 'ar';
              context.setLocale(
                isArabic ? const Locale('en') : const Locale('ar'),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              'تسجيل الخروج',
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              ref.read(authControllerProvider.notifier).signOut();
              context.go(AppRoutes.auth);
            },
          ),
        ],
      ),
    );
  }
}
