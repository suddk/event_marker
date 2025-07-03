import 'package:flutter_timezone/flutter_timezone.dart';

class TimezoneService {
  static Future<String> getCurrentTimezone() async {
    return await FlutterTimezone.getLocalTimezone();
  }
}
