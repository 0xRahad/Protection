import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:protection/core/theme/app_colors.dart';
import 'package:protection/features/main/provider/nav_provider.dart';

import 'package:protection/features/main/view/pages/dashboard_page.dart';
import 'package:protection/features/main/view/pages/logs_page.dart';
import 'package:protection/features/main/view/pages/settings_page.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationView(
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: DragToMoveArea(
                child: Text(
                  "Protection - Web Blocker",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Iconsax.minus_cirlce_copy, size: 20),
                  onPressed: () {
                    windowManager.minimize();
                  },
                ),
                IconButton(
                  icon: Icon(
                    Iconsax.close_circle_copy,
                    size: 20,
                    color: AppColors.redColor,
                  ),
                  onPressed: () {
                    windowManager.close();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      pane: NavigationPane(
        displayMode: PaneDisplayMode.compact,
        size: NavigationPaneSize(compactWidth: 55, openMaxWidth: 200),
        items: [
          PaneItem(
            icon: Icon(Iconsax.home_copy, size: 20),
            title: Text("Dashbaord"),
            body: DashboardPage(),
          ),

          PaneItem(
            icon: Icon(Iconsax.setting_2_copy, size: 20),
            title: Text("Settings"),
            body: SettingsPage(),
          ),

          PaneItem(
            icon: Icon(Iconsax.activity_copy, size: 20),
            title: Text("System Logs"),
            body: LogsPage(),
          ),

          PaneItem(
            icon: Icon(Iconsax.information_copy, size: 20),
            title: Text("About Us"),
            body: LogsPage(),
          ),
          PaneItem(
            icon: Icon(Iconsax.shield_tick_copy, size: 20),
            title: Text("Terms & Conditions"),
            body: LogsPage(),
          ),
        ],
        selected: ref.watch(navProvider),
        onChanged: (value) {
          ref.read(navProvider.notifier).state = value;
        },
      ),
    );
  }
}
