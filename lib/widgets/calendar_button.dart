
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarButtonWidget extends StatefulWidget {
  const CalendarButtonWidget({super.key});

  @override
  _CalendarButtonWidgetState createState() => _CalendarButtonWidgetState();
}

class _CalendarButtonWidgetState extends State<CalendarButtonWidget> {
  DateTime? selectedDate;
  var dateString = (DateTime.now());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFF9B9EE7)),
            borderRadius: BorderRadius.circular(60)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset("assets/images/Calendar.png"),
            const SizedBox(width: 5,),
            Text(
              selectedDate == null
              // ? '${dateString}'
                  ? ("Select Date")
                  : '${DateFormat('MMMM d, y').format(selectedDate!)}',
              style: const TextStyle(
                  color: Color(0xFF6B46F6)
              ),)
          ],
        ),
      ),
    );
  }
}