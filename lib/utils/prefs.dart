import 'prefs_helper.dart';

Prefs get prefs {
  return Prefs._prefs;
}

class Prefs {
  static final _prefs = Prefs();
  final authToken = PrefsHelper<String>("authToken");
  final userId = PrefsHelper<String>("userId");
  final fcmToken = PrefsHelper<String>("fcmToken");
  final showedInitialOffer = PrefsHelper<bool>("showedInitialOffer");
}
