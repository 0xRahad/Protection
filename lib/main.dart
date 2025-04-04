import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protection/features/main/provider/website_repo_provider.dart';
import 'package:protection/features/main/repository/website_repository.dart';
import 'package:protection/protection.dart';
import "package:fluent_ui/fluent_ui.dart" hide Page;
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = await WebsiteRepository.create();
  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.setTitle("Protection - Web Blocker");
    await windowManager.setMinimumSize(const Size(1280, 800));
    await windowManager.setMaximumSize(const Size(1280, 800));
    await windowManager.setSize(const Size(1280, 800));
    await windowManager.setPreventClose(false);
    await windowManager.setSkipTaskbar(false);
    await windowManager.setAlignment(Alignment.center);
    await windowManager.show();
  });

  runApp(ProviderScope(
    overrides: [websiteRepoProvider.overrideWithValue(repo)],
    child: const Protection()));
}
