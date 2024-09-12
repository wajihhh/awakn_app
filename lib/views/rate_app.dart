import 'package:awakn/views/theming/theme.dart';
import 'package:awakn/widgets/customappbar.dart';
import 'package:awakn/widgets/dialogUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RateApplication extends StatefulWidget {
  const RateApplication({super.key});

  @override
  State<RateApplication> createState() => _RateApplicationState();
}

class _RateApplicationState extends State<RateApplication> {
  TextEditingController rateObjective_Controller = TextEditingController();

  String selected = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: ReusableAppBar(
          title: "Rate Application",
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select Star For rating",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          )),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: 250,
                      child: Column(
                        children: [
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            // allowHalfRating: true,
                            unratedColor: Color(0xffA0A7BA),
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star_border_outlined,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xffFF0000),
                                      Color(0xffFFE500),
                                      Color(0xffFFE500),
                                      Color(0xff14FF00),
                                      Color(0xff14FF00),
                                    ])),
                            height: 10,
                            width: 250,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Poor",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontSize: 15),
                              ),
                              Text(
                                "Satisfactory",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontSize: 15),
                              ),
                              Text(
                                "Excellent",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Would you recommend this application to others?",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          )),
                  Row(
                    children: [
                      Radio(
                        activeColor: Color(0xffA188FF),
                        focusColor: Colors.white,
                        value: 'Yes',
                        groupValue: selected,
                        onChanged: (value) {
                          setState(() {
                            selected = value.toString();
                          });
                        },
                      ),
                      Text(
                        'Yes',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 15),
                      ),
                      Radio(
                        activeColor: Color(0xffA188FF),
                        focusColor: Colors.white,
                        value: 'No',
                        groupValue: selected,
                        onChanged: (value) {
                          setState(() {
                            selected = value.toString();
                          });
                        },
                      ),
                      Text(
                        'No',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Review",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          )),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 200.0, // Adjust the height as needed
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff949FBB)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        cursorColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Write your review..',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.sp,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          backgroundColor: const Color(0xff302B4a),
                        ),
                        onPressed: () {},
                        child: GestureDetector(
                            onTap: () {
                              // Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff6B46F6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60))),
                        onPressed: () {
                          DialogUtils.reviewSuccessDialog(context);
                        },
                        child: const Text(
                          "Submit Review",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
