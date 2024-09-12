import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CodeController extends GetxController {
  RxString code1 = ''.obs;
  RxString code2 = ''.obs;
  RxString code3 = ''.obs;
  RxString code4 = ''.obs;
}

class CodeInput extends StatelessWidget {
  final CodeController _codeController = CodeController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CodeController>(
      init: _codeController,
      builder: (_) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildOTPTextField(_codeController.code1),
          const SizedBox(width: 16),
          buildOTPTextField(_codeController.code2),
          const SizedBox(width: 16),
          buildOTPTextField(_codeController.code3),
          const SizedBox(width: 16),
          buildOTPTextField(_codeController.code4),
        ],
      ),
    );
  }

  Widget buildOTPTextField(RxString controller) {
    return SizedBox(
      width: 50,
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: TextEditingController()..text = controller.value,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            Get.focusScope?.previousFocus();
          } else if (value.length == 1) {
            Get.focusScope?.nextFocus();
          }
          controller.value = value;
        },
      ),
    );
  }
}
