import 'dart:io';

import 'package:awakn/models/login_response.dart';
import 'package:awakn/models/profile_response.dart';
import 'package:awakn/services/exception_handler.dart';
import 'package:awakn/services/http/api.dart';
import 'package:awakn/services/http/api_constants.dart';
import 'package:awakn/services/token_manager.dart';
import 'package:awakn/utils/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class UserService {
  final Api _api = Api();

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      Dio dio = await _api.createDio();
      await dio.post(
        ApiConstants.signUp,
        data: {
          "full_name": fullName,
          "email": email,
          "password": password,
          "phone_no": phoneNumber,
        },
      );
      return true;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // Future<bool> generalSetting() async {
  //   try {
  //     Dio dio = await _api.createDio();
  //     var response = await dio.post("https://eternal-network.3.133.97.239.nip.io/awakn/user/profile/update-general-settings",
  //         data: {
  //           "color_mode": "string",
  //           "smooth_wake_up": true,
  //           "block_alarm_during_calls": true,
  //           "stick_alarm": true,
  //           "disturb_mode": true,
  //           "general_alarm_volume": 0
  //
  //
  //         });
  //     GeneralSettingResponse res = GeneralSettingResponse.fromJson(response.data);
  //
  //
  //   } on Exception catch (e) {
  //     ExceptionHandler().handle(e);
  //   } catch(e){
  //     debugPrint(e.toString());
  //
  //   }
  //   return false;
  // }

  Future<bool> signIn(String email, String password) async {
    try {
      Dio dio = await _api.createDio();
      var response = await dio.post(ApiConstants.signIn, data: {
        "email": email,
        "password": password,
      });
      LoginResponse res = LoginResponse.fromJson(response.data);

      // Map<String, dynamic> payload = Jwt.parseJwt(res.data!.token!);
      globalCache.user = res.data!.user!;
      await TokenManager().setToken(res.data!.token!);
      return true;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> guestSignIn() async {
    try {
      Dio dio = await _api.createDio();
      var response = await dio.post(ApiConstants.guestSignIn);
      LoginResponse res = LoginResponse.fromJson(response.data);

      // Map<String, dynamic> payload = Jwt.parseJwt(res.data!.token!);
      globalCache.user = res.data!.user!;
      await TokenManager().setToken(res.data!.token!);
      return true;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> getTokenFromGoogle(GoogleSignInAccount acc) async {
    try {
      Dio dio = await _api.createDio();
      var response = await dio.post(
        ApiConstants.signIn,
        data: {
          "email": acc.email,
          "displayName": acc.displayName,
          "id": acc.id,
          "serverAuthCode": acc.serverAuthCode,
          "photoUrl": acc.photoUrl,
          "app_pk": AppConstants.appId
        },
      );
      LoginResponse.fromJson(response.data);
      // Map<String, dynamic> payload = Jwt.parseJwt(res.token!);
      // globalCache.userID = payload['user_id'];
      // await TokenManager().setToken(res.token!);
      return true;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> getTokenFromApple(
      AuthorizationCredentialAppleID credential) async {
    try {
      Dio dio = await _api.createDio();
      var response = await dio.post(
        ApiConstants.signIn,
        data: {
          'authorizationCode': credential.authorizationCode,
          'userIdentifier': credential.userIdentifier,
          'givenName': credential.givenName,
          'familyName': credential.familyName,
          'email': credential.email,
          'identityToken': credential.identityToken,
          'state': credential.state,
        },
      );
      LoginResponse.fromJson(response.data);
      // Map<String, dynamic> payload = Jwt.parseJwt(res.token!);
      // globalCache.userID = payload['user_id'];
      // print(payload);
      // await TokenManager().setToken(res.token!);
      return true;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<ProfileResponse?> getProfile({String? id}) async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      var response = await dio.get(
          id != null ? '${ApiConstants.profile}/$id' : ApiConstants.profile);
      ProfileResponse profile = ProfileResponse.fromJson(response.data['data']);

      globalCache.userProfile = profile;
      return profile;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<bool> updateProfile({
    File? file,
    String? fullName,
    String? country,
    String? city,
    String? phoneNumber,
  }) async {
    try {
      FormData formdata = FormData.fromMap({
        "full_name": fullName,
        "country": country,
        "city": city,
        "phone_no": phoneNumber,
        "profile_picture": file == null
            ? null
            : await MultipartFile.fromFile(file.path,
                filename: file.path.split("/").last),
      });
      Dio dio = await _api.createDio(hasAuth: true);
      dio.options.headers["Content-Type"] = "multipart/form-data";
      await dio.put(
        ApiConstants.userUpdate,
        data: formdata,
      );

      return true;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  // Future<dynamic> refreshToken({DioException? dioError}) async {
  //   try {
  //     Dio dio = await _api.createDio();
  //     var response = await dio.post(
  //       ApiConstants.refreshToken,
  //       data: {
  //         "token": await TokenManager().getToken(),
  //       },
  //     );
  //     LoginResponse res = LoginResponse.fromJson(response.data);
  //     // Map<String, dynamic> payload = Jwt.parseJwt(res.token!);
  //     // globalCache.userID = payload['user_id'];
  //     // await TokenManager().setToken(res.token!);
  //     if (dioError != null) {
  //       // dio.lock();
  //       // dio.interceptors.requestLock.lock();
  //       // dio.interceptors.errorLock.lock();
  //       RequestOptions options = dioError.response!.requestOptions;
  //       options.headers["Authorization"] = 'Bearer ${res.data!.token}';
  //       return dio.fetch(options);
  //     }
  //     // getProfileData();
  //     return res.data!.token;
  //   } on Exception catch (e) {
  //     ExceptionHandler().handle(e);
  //   }
  //   return false;
  // }
  Future<bool> forgotPassword(String email) async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);

      await dio.post(ApiConstants.forgotPassword, data: {"email": email});
      return true;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> resetPassword({
    required String token,
    required String email,
    required String pass,
    required String confirmPass,
  }) async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      await dio.post(
        ApiConstants.resetPassword,
        data: {
          "token": token,
          "email": email,
          "pass": pass,
          "confirm_pass": confirmPass
        },
      );
      return true;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> changePassword({
    required String currentPass,
    required String newPass,
    required String confirmNewPass,
  }) async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      await dio.post(
        ApiConstants.changePassword,
        data: {
          "current_pass": currentPass,
          "new_pass": newPass,
          "confirm_new_pass": confirmNewPass
        },
      );
      return true;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> logout() async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      await dio.put(
        ApiConstants.logout,
      );
      globalCache.user = null;
      await TokenManager().clearToken();
      return true;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }
}

Future<bool> signOut() async {
  try {
    globalCache.user = null;
    await TokenManager().clearToken();
    return true;
  } catch (e) {
    debugPrint(e.toString());
  }
  return false;
}
