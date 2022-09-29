import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static SharedPreferences? _instance;

  static Future<SharedPreferences> get _preference async {
    _instance ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  static Future<String> get lastCommand async {
    return (await _preference).getString(_keyLastCommand) ?? '';
  }

  static Future<void> saveLastCommand(String value) async {
    (await _preference).setString(_keyLastCommand, value);
  }

  static const _keyLastCommand = 'lastCommand';
}