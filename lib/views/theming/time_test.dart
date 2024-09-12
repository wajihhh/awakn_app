// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// //
// //
// //
// // class TimePickerController extends GetxController {
// //   late Rx<TimeOfDay> _selectedTime;
// //
// //   Rx<TimeOfDay> get selectedTime => _selectedTime;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     _selectedTime = TimeOfDay.now().obs;
// //   }
// //
// //   Future<void> showCustomTimePicker(BuildContext context) async {
// //     final picked = await showDialog<TimeOfDay>(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return TimePickerDialog(
// //           initialTime: _selectedTime.value,
// //         );
// //       },
// //     );
// //
// //     if (picked != null && picked != _selectedTime.value) {
// //       _selectedTime.value = picked;
// //     }
// //   }
// // }
// // class Test extends StatelessWidget {
// //   const Test({super.key});
// //
// //   @override
// //
// //   Widget build(BuildContext context) {
// //     final TimePickerController controller = Get.put(TimePickerController());
// //
// //     return Scaffold(
// //       body: Center(
// //         child: ElevatedButton(
// //           onPressed: () {
// //             controller.showCustomTimePicker(context);
// //           },
// //           child: GetBuilder<TimePickerController>(
// //             builder: (controller) => Text(
// //               ' ${_formatTime(controller.selectedTime.value)}',
// //               style: TextStyle(color: Colors.black),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //   String _formatTime(TimeOfDay timeOfDay) {
// //     final hour = timeOfDay.hourOfPeriod.toString().padLeft(2, '0');
// //     final minute = timeOfDay.minute.toString().padLeft(2, '0');
// //     final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
// //     return '$hour:$minute $period';
// //   }
// // }
// //
// //
// //
// // class TimerPickerDialog extends StatefulWidget {
// //   final TimeOfDay initialTime;
// //
// //   const TimerPickerDialog({Key? key, required this.initialTime}) : super(key: key);
// //
// //   @override
// //   _TimePickerDialogState createState() => _TimePickerDialogState();
// // }
// //
// // class _TimePickerDialogState extends State<TimePickerDialog> {
// //   late TimeOfDay _selectedTime;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _selectedTime = widget.initialTime;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return AlertDialog(
// //       title: Text('Select Time'),
// //       content: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           SizedBox(
// //             height: 200,
// //             child: CupertinoTheme(
// //               data: const CupertinoThemeData(
// //                 textTheme: CupertinoTextThemeData(
// //                   dateTimePickerTextStyle: TextStyle(color: Colors.black),
// //                 ),
// //               ),
// //               child: CupertinoDatePicker(
// //                 mode: CupertinoDatePickerMode.time,
// //                 initialDateTime: DateTime(0, _selectedTime.hour, _selectedTime.minute),
// //                 onDateTimeChanged: (DateTime dateTime) {
// //                   setState(() {
// //                     _selectedTime = TimeOfDay.fromDateTime(dateTime);
// //                   });
// //                 },
// //               ),
// //             ),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               Get.find<TimePickerController>().selectedTime.value = _selectedTime;
// //               Navigator.of(context).pop();
// //             },
// //             child: Text('OK'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
//
//
//
import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay>? onTimeSelected;

  const CustomTimePicker({
    Key? key,
    required this.initialTime,
    this.onTimeSelected,
  }) : super(key: key);

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late int _selectedHour;
  late int _selectedMinute;
  late String _selectedPeriod;
  late int _selectedIndexHour;
  late int _selectedIndexMinute;
  late int _selectedIndexPeriod;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute;
    _selectedPeriod = _selectedHour < 12 ? 'AM' : 'PM';
    _selectedIndexHour = _selectedHour - 1;
    _selectedIndexMinute = _selectedMinute;
    _selectedIndexPeriod = _selectedPeriod == 'AM' ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Time'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildScrollableList(_generateHourList(), _selectedIndexHour,
                  (index) {
                _selectedHour = index + 1;
                _selectedIndexHour = index;
                _updatePeriod();
              }),
              SizedBox(width: 20),
              _buildScrollableList(_generateMinuteList(), _selectedIndexMinute,
                  (index) {
                _selectedMinute = index;
                _selectedIndexMinute = index;
              }),
              SizedBox(width: 20),
              _buildScrollableList(_generatePeriodList(), _selectedIndexPeriod,
                  (index) {
                _selectedPeriod = index == 0 ? 'AM' : 'PM';
                _selectedIndexPeriod = index;
              }),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
        TextButton(
          onPressed: () {
            final selectedTime = TimeOfDay(
              hour: _selectedHour,
              minute: _selectedMinute,
            );
            widget.onTimeSelected?.call(selectedTime);
            Navigator.of(context)
                .pop(selectedTime); // Pass selectedTime when dialog is popped
          },
          child: Text(
            'OK',
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableList(
      List<Widget> items, int selectedIndex, Function(int) onChanged) {
    return Container(
      height: 120,
      width: 60,
      child: ListWheelScrollView(
        itemExtent: 40,
        physics: FixedExtentScrollPhysics(),
        children: List.generate(items.length, (index) {
          return _buildItemWidget(items[index], index, selectedIndex);
        }),
        onSelectedItemChanged: (index) {
          setState(() {
            onChanged(index);
            if (_selectedIndexPeriod == 0 && index >= 11) {
              _selectedPeriod = 'PM';
              _selectedIndexPeriod = 1;
            } else if (_selectedIndexPeriod == 1 && index < 11) {
              _selectedPeriod = 'AM';
              _selectedIndexPeriod = 0;
            }
          });
        },
      ),
    );
  }

  Widget _buildItemWidget(Widget child, int index, int selectedIndex) {
    return Container(
      alignment: Alignment.center,
      color: index == selectedIndex ? Colors.blue.withOpacity(0.3) : null,
      child: child,
    );
  }

  List<Widget> _generateHourList() {
    return List.generate(12, (index) => index + 1).map((hour) {
      return Center(child: Text(hour.toString()));
    }).toList();
  }

  List<Widget> _generateMinuteList() {
    return List.generate(60, (index) => index).map((minute) {
      return Center(child: Text(minute.toString().padLeft(2, '0')));
    }).toList();
  }

  List<Widget> _generatePeriodList() {
    return ['AM', 'PM'].map((period) {
      return Center(child: Text(period));
    }).toList();
  }

  void _updatePeriod() {
    if (_selectedHour >= 12) {
      _selectedPeriod = 'PM';
      _selectedIndexPeriod = 1;
    } else {
      _selectedPeriod = 'AM';
      _selectedIndexPeriod = 0;
    }
  }
}

class TimePickerScreen extends StatefulWidget {
  @override
  _TimePickerScreenState createState() => _TimePickerScreenState();
}

class _TimePickerScreenState extends State<TimePickerScreen> {
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Time Picker Screen',
          style: TextStyle(color: Colors.blueGrey),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final selectedTime = await _showCustomTimePicker(context);
            if (selectedTime != null) {
              setState(() {
                _selectedTime = selectedTime;
              });
            }
          },
          child: Text(
            _selectedTime == null
                ? 'Open Time Picker'
                : 'Selected Time: ${_selectedTime!.format(context)}',
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
      ),
    );
  }

  Future<TimeOfDay?> _showCustomTimePicker(BuildContext context) async {
    return await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return CustomTimePicker(
          initialTime: _selectedTime ?? TimeOfDay.now(),
          onTimeSelected: (selectedTime) {
            // Handle the selected time
            print('Selected Time: $selectedTime');
          },
        );
      },
    );
  }
}
