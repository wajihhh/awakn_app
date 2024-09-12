import 'package:alarm/alarm.dart';
import 'package:awakn/utils/languages.dart';
import 'package:awakn/views/base/splash_screen.dart';
import 'package:awakn/views/theming/theme.dart';
import 'package:awakn/widgets/customtheme_button.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  Get.put(CustomThemeSwitchController());
  await Alarm.init(showDebugLogs: kReleaseMode ? false : true);
  await GetStorage.init();

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('CameraError: ${e.description}');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return GetMaterialApp(
          theme: CustomTheme.lightTheme,
          darkTheme: CustomTheme.darkTheme,
          // themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          translations: MultiLanguage(),
          // locale: const Locale('en', 'US'),
          // fallbackLocale: const Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
