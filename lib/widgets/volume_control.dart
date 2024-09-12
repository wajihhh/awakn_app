import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class VolumeControlWidget extends StatefulWidget {
  const VolumeControlWidget({super.key});

  @override
  _VolumeControlWidgetState createState() => _VolumeControlWidgetState();
}

class _VolumeControlWidgetState extends State<VolumeControlWidget> {
  double volumeValue = 10; // Initial Volume

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 220.sp,
          // height: 30,
          // color: Colors.black12,
          child: FlutterSlider(
            handlerHeight: 20,
            trackBar: const FlutterSliderTrackBar(
              inactiveTrackBar: BoxDecoration(
                color: Colors.grey
              ),

                activeTrackBar: BoxDecoration(
                    color: Color(0xff6B46F6)
                )
            ),
            handler: FlutterSliderHandler(




              child: const Icon(Icons.add,color: Color(0xff6B46F6)),

              decoration: BoxDecoration(

                color: const Color(0xff6B46F6),
                borderRadius: BorderRadius.circular(20),

              ),
            ),
            // maximumDistance: 10,


            // decoration: BoxDecoration(
            //
            //
            //   borderRadius: BorderRadius.circular(12),
            //   // color: Colors.green,
            //
            // ),
            values: [volumeValue],
            max: 100,
            min: 1,
            step: const FlutterSliderStep(step: 1),
            onDragging: (handlerIndex, lowerValue, upperValue) {
              setState(() {
                volumeValue = lowerValue;
                // Adjust the volume here based on the new value
                adjustVolume();
              });
            },
          ),
        ),
        SizedBox(width: 2.sp) ,
        SizedBox(
          width: 30.sp,
          height: 20.sp,

          // color: Colors.black12,
          child: Text(
            '${(volumeValue).round()}%',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 12.sp,
            ),
          ),
        )


      ],
    );
  }

  void adjustVolume() {
    // Implement volume adjustment logic here
    // For example, you can use the audioplayers package to set the volume.
    // Assuming you have an AudioPlayer instance:
    // audioPlayer.setVolume(volumeValue);
  }
}