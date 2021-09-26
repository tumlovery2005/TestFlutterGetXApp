import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkingapp/bloc/number/NumberEvent.dart';
import 'package:tarkingapp/bloc/number/NumberState.dart';

class NumberBloc extends Bloc<NumberEvent, NumberState> {
  NumberBloc() : super(NumberIncrementState());

  @override
  Stream<NumberState> mapEventToState(NumberEvent event) async* {
    if(event is NumberIncrementEvent){
      yield await _mapNumber(event.number);
    }
  }

  Future<NumberState> _mapNumber(int number) async{
    return NumberIncrementState(
      number: number,
    );
  }

}