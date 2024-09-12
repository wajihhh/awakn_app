import 'package:awakn/views/subscriptions/subscription_view_model.dart';
import 'package:awakn/widgets/custom_button.dart';
import 'package:awakn/widgets/custom_textfield.dart';
import 'package:awakn/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../widgets/dialogUtils.dart';
import '../theming/theme.dart';

class PackageDetail extends StatelessWidget {
  const PackageDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Get.put(SubscriptionViewModel());
    return Obx(() => Container(
      decoration: BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),

      child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: ReusableAppBar(
              title: "Platinum Package Details",
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/Vector.svg",
                              color: Colors.white
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Credit Details",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const CustomTextField(
                          labeltext: "Card Number",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RoundedExpiryTextField(labelText: 'Expires'),
                            CVCCodeTextField(
                              labelText: "CVC",
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              side: BorderSide(color: Color(0xffA188FF)),
                              activeColor: Color(0xffA188FF),
                              checkColor: Colors.white,
                              value: model.saveInfo.value,
                              onChanged: (bool? value) => model.saveInfo(value),
                            ),
                            Flexible(
                              child: Text(
                                "Save checkout information to my account for future purchases",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontSize: 15),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        DialogUtils.subscriptionSuccessDialog(context);
                      },
                      child: CustomButton(
                        text: "Pay \$24.00",
                        textColor: Colors.white,
                        fontWeight: FontWeight.w500,
                        height: 40.sp,
                        width: 293.sp,
                      )

                      //Container(
                      //                   height: 40.sp,
                      //                   width: 293.sp,
                      //                   decoration: BoxDecoration(
                      //                       borderRadius: BorderRadius.circular(60),
                      //                       // border: Border.all(color: Color(0xff8990A1)),
                      //                       color: Color(0xff6B46F6)),
                      //                   child: Center(
                      //                     child: Text("Pay \$24.00",
                      //                         style: TextStyle(
                      //                             color: Colors.white, fontWeight: FontWeight.w500)),
                      //                   ),
                      //                 ),
                      ),
                ],
              ),
            ),
          ),
        ));
  }
}

class RoundedExpiryTextField extends StatefulWidget {
  final String labelText;
  RoundedExpiryTextField({required this.labelText});
  @override
  State<RoundedExpiryTextField> createState() => _RoundedExpiryTextFieldState();
}

class _RoundedExpiryTextFieldState extends State<RoundedExpiryTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 163,
          child: Text(
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
            widget.labelText,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          width: 163,
          child: TextField(
            cursorColor: Colors.white,
            style: TextStyle(
                color: Colors.white),
            decoration: InputDecoration(
              hintText: 'MM/YY',
              hintStyle: TextStyle(
                  color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(60.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60.0),
                  borderSide: BorderSide(color: Color(0xff949FBB))),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                  5), // Limit input to 5 characters (MM/YY)
              _CardExpiryInputFormatter(),
            ],
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }
}

class _CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (text.length > 5) {
      return oldValue; // Do not allow more than 5 characters
    }

    if (text.isNotEmpty &&
        int.tryParse(text.substring(text.length - 1)) == null) {
      // Remove non-numeric characters
      text = text.substring(0, text.length - 1);
    }

    if (text.length >= 3 && text.indexOf('/') == -1) {
      // Insert '/' after the third character
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class CVCCodeTextField extends StatefulWidget {
  final String labelText;

  CVCCodeTextField({required this.labelText});

  @override
  _CVCCodeTextFieldState createState() => _CVCCodeTextFieldState();
}

class _CVCCodeTextFieldState extends State<CVCCodeTextField> {
  // TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 163,
          child: Text(
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
            widget.labelText,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          width: 163,
          child: TextField(
            cursorColor: Colors.white,
            // maxLength: 3,
            maxLength: 3,
            // controller: _controller,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(60.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60.0),
                  borderSide: BorderSide(color: Color(0xff949FBB))),

              hintText: '***',
              counterText: "",
              hintStyle: TextStyle(
                  color:Colors.white),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60.0),
                  borderSide: BorderSide(color: Color(0xff949FBB))),
              // contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
            obscureText: true, // Set to true to hide the entered text
            keyboardType: TextInputType.number,

            // inputFormatters: [
            //   FilteringTextInputFormatter.digitsOnly, // Allow only numeric input
            // ],
            style: TextStyle(
                color: Colors.white),
          ),
        ),
      ],
    );
  }
}
