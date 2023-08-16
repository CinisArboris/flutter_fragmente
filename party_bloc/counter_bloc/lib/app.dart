import 'package:counter_bloc/counter/view/counter_page.dart';
import 'package:flutter/material.dart';

class CounterApp extends MaterialApp {
  /// {@macro counter_app}
  const CounterApp({super.key}) : super(home: const CounterPage());
}
