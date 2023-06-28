import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit(int initialState) : super(initialState);

  void doubleIncrement() => emit(state + 2);
  void tripleIncrement() => emit(state + 3);
  void quadIncrement() => emit(state + 4);
}
