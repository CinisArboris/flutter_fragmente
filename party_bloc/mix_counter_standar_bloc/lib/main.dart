import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mix_counter_standar_bloc/counter/cubit/counter_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            BlocProvider<CounterCubit>(
              create: (context) => CounterCubit(_counter),
              child: BlocBuilder<CounterCubit, int>(
                builder: (context, state) {
                  _counter = state;
                  return Column(
                    children: [
                      FloatingActionButton(
                        onPressed: () =>
                            context.read<CounterCubit>().doubleIncrement(),
                        tooltip: 'Increment by 2',
                        child: const Text('+2'),
                      ),
                      FloatingActionButton(
                        onPressed: () =>
                            context.read<CounterCubit>().tripleIncrement(),
                        tooltip: 'Increment by 3',
                        child: const Text('+3'),
                      ),
                      FloatingActionButton(
                        onPressed: () =>
                            context.read<CounterCubit>().quadIncrement(),
                        tooltip: 'Increment by 4',
                        child: const Text('+4'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
