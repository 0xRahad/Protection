import 'package:fluent_ui/fluent_ui.dart';

class AppTheme {
  AppTheme._();

  static final lightTheme = FluentThemeData(
    accentColor: Colors.blue,
    brightness: Brightness.light,
  );
  static final darkTheme = FluentThemeData(
    accentColor: Colors.orange,
    brightness: Brightness.dark,
  );
}
