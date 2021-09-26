import 'package:flutter_bloc/flutter_bloc.dart';

class NumberCubit extends Cubit<int> {
  NumberCubit() : super(0);

  void increment(){
    state > 9 ? emit(0) : emit(state + 1);
  }
}