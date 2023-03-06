import 'package:default_date/component/CDatePicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            showDatePick(),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget showDatePick() {
    return Column(
      children: [
        const Text(
          'Calendar',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // CDatePicker(
        // ),
        // use CDatePicker and get the selected date
        CDatePicker(
          onDateSelected: (DateTime date) {
            setState(() {
              _selectedDate = date;
              _dateController.text = DateFormat('yyyy-MM-dd')
                  .format(date); // Actualiza el valor del EditText
            });
          },
        ),
        Text(
          '${_selectedDate.toLocal()}'.split(' ')[0],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
