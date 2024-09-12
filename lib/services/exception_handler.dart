// import 'package:awakn/views/sign_in/sign_in_view.dart';
// import 'package:awakn/widgets/snackbar_manager.dart';
// import 'package:get/get.dart';
//
// import 'http/dio_interceptor.dart';
//
// class ExceptionHandler {
//   void handle(dynamic e) {
//     if (e is UnauthorizedException) {
//       Get.offAll(() => const SignInView());
//       return;
//     }
//     if (e is BadRequestException ||
//         e is NotFoundException ||
//         e is InternalServerErrorException ||
//         e is NoInternetConnectionException ||
//         e is DeadlineExceededException) {
//       SnackbarManager().showAlertSnackbar(Get.context!, e.toString());
//       return;
//     }
//     SnackbarManager()
//         .showAlertSnackbar(Get.context!, e.response.data['message']);
//   }
// }

import 'package:awakn/views/sign_in/sign_in_view.dart';
import 'package:awakn/widgets/snackbar_manager.dart';
import 'package:get/get.dart';

import 'http/dio_interceptor.dart';

class ExceptionHandler {
  void handle(dynamic e) {
    if (e is UnauthorizedException) {
      Get.offAll(() => const SignInView());
      return;
    }
    if (e is BadRequestException ||
        e is NotFoundException ||
        e is InternalServerErrorException ||
        e is NoInternetConnectionException ||
        e is DeadlineExceededException) {
      SnackbarManager().showAlertSnackbar(Get.context!, e.toString());
      return;
    }
    if (e.response?.statusCode == 422 && e.response?.data['message'] != null) {
      final errorMessage = e.response.data['message'];
      if (errorMessage is List && errorMessage.isNotEmpty) {
        SnackbarManager().showAlertSnackbar(Get.context!, errorMessage[0]);
      } else {
        SnackbarManager().showAlertSnackbar(Get.context!, errorMessage.toString());
      }
      return;
    }
    SnackbarManager()
        .showAlertSnackbar(Get.context!, 'An unexpected error occurred.');
  }
}
