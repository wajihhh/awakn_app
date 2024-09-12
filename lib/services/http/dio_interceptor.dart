import 'dart:developer';
import 'package:awakn/views/sign_in/sign_in_view.dart';
import 'package:dio/dio.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/route_manager.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;

  DioInterceptor(this.dio);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);

    log('[ URL: ${options.uri} ]');
    log('[ Headers: ${options.headers.toString()} ]');
    log('[ Request: ${options.data.toString()} ]');
    // var isExpiredToken = false;
    // var token = await TokenManager().getToken();
    // if (token.isNotEmpty) {
    //   isExpiredToken = Jwt.isExpired(token);
    // }

    // if (isExpiredToken) {
    //   await UserService().refreshToken().then((token) {
    //     if (token != null) {
    //       options.headers.addAll({'authorization': 'Bearer ${token!}'});
    //       // return handler.next(options); //  super.onResponse(value, );
    //     }
    //   }).catchError(
    //       (onError) => throw UnauthorizedException(onError.requestOptions));
    // }
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    super.onResponse(response, handler);
    log('[ Response: ${response.data} ]');
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    log('[ Error ] ${err.toString()}');
    log('[ Error Response] ${err.response.toString()}');
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
          // case 401:
          case 403:
            throw BadRequestException(err.requestOptions, err.response!);
          case 401:
            // case 403:
            throw UnauthorizedException(err.requestOptions);
          // case 401:
          // case 403:
          //   tokenHandling(err, handler);
          // break;
          case 404:
            throw NotFoundException(err.requestOptions, err.response!);
          case 409:
            throw ConflictException(err.requestOptions);
          case 500:
            throw InternalServerErrorException(err.requestOptions);
        }
        break;
      case DioExceptionType.cancel:
        break;
      default:
        throw NoInternetConnectionException(err.requestOptions);
    }

    return handler.next(err);
  }

  void tokenHandling(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    // if (err.requestOptions.path.contains(ApiConstants.refreshToken)) {
    Get.offAll(() => const SignInView());
    // } else {
    //   AuthService().refreshToken(dioError: err).then((value) {
    //     if (value != null) {
    //       handler.resolve(value);
    //       // return value;
    //       //  super.onResponse(value, );
    //       // throw UnauthorizedException(err.requestOptions);
    //     }
    //   }).catchError((onError) => throw UnauthorizedException());
    // }
  }
}

// InterceptorsWrapper dioInterceptor() {
//   return InterceptorsWrapper(
//       onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
//     // super.onRequest(options, handler);
//     // log('[ URL: ${options.baseUrl}${options.path} ]');
//     log('[ URL: ${options.uri} ]');
//     log('[ Headers: ${options.headers.toString()} ]');
//     log('[ Request: ${options.data.toString()} ]');
//     // return options;
//   }, onResponse:
//           (Response<dynamic> response, ResponseInterceptorHandler handler) {
//     // super.onResponse(response, handler);
//     log('[ Response: ${response.data} ]');
//     // return response;
//   }, onError: (DioError err, ErrorInterceptorHandler handler) {
//     log('[ Error ] ${err.toString()}');
//     log('[ Error Response] ${err.response.toString()}');
//     switch (err.type) {
//       case DioErrorType.connectTimeout:
//       case DioErrorType.sendTimeout:
//       case DioErrorType.receiveTimeout:
//         throw DeadlineExceededException(err.requestOptions);
//       case DioErrorType.response:
//         switch (err.response?.statusCode) {
//           case 400:
//             throw BadRequestException(err.requestOptions);

//           case 401:
//             if (err.requestOptions.path.contains(ApiContants.refreshToken)) {
//               Get.offAll(() => const SignInView());
//               break;
//             } else {
//               UserService().refreshToken(dioError: err).then((value) {
//                 if (value != null) {
//                   // handler.resolve(value);
//                   return value;
//                   //  super.onResponse(value, );
//                   // throw UnauthorizedException(err.requestOptions);
//                 }
//               }).catchError(
//                   (onError) => throw UnauthorizedException(err.requestOptions));
//             }
//             break;
//           case 403:
//             throw UnauthorizedException(err.requestOptions);
//           case 404:
//             throw NotFoundException(err.requestOptions);
//           case 409:
//             throw ConflictException(err.requestOptions);
//           case 500:
//             throw InternalServerErrorException(err.requestOptions);
//         }
//         break;
//       case DioExceptionType.cancel:
//         break;
//       case DioExceptionType.other:
//         throw NoInternetConnectionException(err.requestOptions);
//     }

//     return handler.next(err);
//   });
// }

class BadRequestException extends DioException {
  BadRequestException(RequestOptions request, Response response)
      : super(requestOptions: request, response: response);

  @override
  String toString() {
    return response!.data['message'];
  }
}

class InternalServerErrorException extends DioException {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'unknown_error'.tr;
  }
}

class ConflictException extends DioException {
  ConflictException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'conflict_occured'.tr;
  }
}

class UnauthorizedException extends DioException {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'access_denied'.tr;
  }
}

class NotFoundException extends DioException {
  NotFoundException(RequestOptions request, Response response)
      : super(requestOptions: request, response: response);

  @override
  String toString() {
    return response!.data['message'];
  }
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'No Internet Connection.';
  }
}

class DeadlineExceededException extends DioException {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'connection_timed_out'.tr;
  }
}
