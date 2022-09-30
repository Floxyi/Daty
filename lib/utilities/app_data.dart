import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isFirstStartup() async {
  final prefs = await SharedPreferences.getInstance();
  bool? firstStart = await prefs.getBool('isFirstStartup');

  if (firstStart == null) {
    await prefs.setBool('isFirstStartup', false);
    return true;
  } else {
    return false;
  }
}
