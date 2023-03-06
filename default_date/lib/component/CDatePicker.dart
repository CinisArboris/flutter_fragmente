import 'package:flutter/material.dart';

class CDatePicker extends StatefulWidget {
  final void Function(DateTime date) onDateSelected;

  const CDatePicker({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  State<CDatePicker> createState() => _CDatePickerState();
}

class _CDatePickerState extends State<CDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            _selectDate(context);
          },
          child: const Text(
            'Select Date',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1991, 7, 2),
      lastDate: DateTime(DateTime.now().year, 31, 12),
    );
    if (picked != null && picked != DateTime.now()) {
      print(picked);
    }
    // update the state
    setState(() {});
    widget.onDateSelected(picked!);
  }
}
