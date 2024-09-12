import 'package:get/get_navigation/src/root/internacionalization.dart';

class MultiLanguage extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      {
        'en_US': {
          "message": "Your Logo",
          "Welcome Back": "Welcome Back",



        },
        'es_US': {
          "message": 'Tu logo',
          "Welcome Back" : "Bienvenido de nuevo"


        },
      };
}
