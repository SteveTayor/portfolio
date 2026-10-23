import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const String _key = 'portfolio_theme_mode';

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_key);
      if (saved == 'light') _mode = ThemeMode.light;
      if (saved == 'dark') _mode = ThemeMode.dark;
    } catch (_) {
      // Storage can be unavailable (private windows). Fall back silently.
    }
  }

  Future<void> set(ThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, mode == ThemeMode.dark ? 'dark' : 'light');
    } catch (_) {}
  }

  void toggle(Brightness current) {
    set(current == Brightness.dark ? ThemeMode.light : ThemeMode.dark);
  }
}

class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Reads the controller without subscribing, so widgets never rebuild just
  /// because the controller changed (the app root already does that).
  static ThemeController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<ThemeScope>();
    return scope!.notifier!;
  }
}
