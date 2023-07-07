import 'package:get_it/get_it.dart';

import 'utils/prefs.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton(() => Prefs());
  // //Custom Utils
  // getIt.registerFactory(() => CustomAlerts());
  // getIt.registerFactory(() => FunctionResponse());
  // //Stores
  // getIt.registerLazySingleton(() => LocaleStore());
  // getIt.registerLazySingleton(() => CustomerStore());
}
