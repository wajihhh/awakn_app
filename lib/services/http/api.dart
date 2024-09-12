import 'package:awakn/services/http/api_constants.dart';
import 'package:awakn/services/http/dio_interceptor.dart';
import 'package:awakn/services/token_manager.dart';
import 'package:dio/dio.dart';

class Api {
  final tokenDio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
  ));

  Api._internal();

  static final _singleton = Api._internal();

  factory Api() => _singleton;

  Future<Dio> createDio({bool hasAuth = false}) async {
    String token = await TokenManager().getToken();
    var dio = Dio(BaseOptions(
      headers: hasAuth
          ? {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              // 'app-id': AppConstants.appId,
            }
          : {
              'Content-Type': 'application/json',
              // 'app-id': AppConstants.appId,
            },
      baseUrl: ApiConstants.baseUrl,
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
    ));

    dio.interceptors.addAll({
      DioInterceptor(dio),
    });

    // dio.interceptors.add(dioInterceptor());
    return dio;
  }
}
