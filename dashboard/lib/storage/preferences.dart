import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';


class Preferences {

  final List<String> userPreferences = ['email', 'password', 'name'];
  static Preferences _localPreferences;
  final Map<String, dynamic> memory = {
    'email': 'example',
    'password': 'you',
    'name': 'shouldnt'
  };


  static Preferences getInstance() {
    if (_localPreferences == null) {
      _localPreferences = Preferences();
      _localPreferences._initPreferences();
    }

    return _localPreferences;
  }

  Future<void> setString(String key, String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  Future<void> _initPreferences() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    for (String prefs in userPreferences) {
      Map<String, dynamic> memPrefs = memory;
      dynamic val = pref.get(prefs);
      memPrefs[prefs] = ((val == null) ? memPrefs[prefs] : val);
    
    }
  }


}