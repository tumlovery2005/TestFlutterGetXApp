import 'package:equatable/equatable.dart';

abstract class NumberState extends Equatable {}

class NumberIncrementState extends NumberState {
  final int? number;
  NumberIncrementState({this.number});

  NumberIncrementState conpyWith({
   int? number,
  }){
    return NumberIncrementState(
      number: number ?? this.number,
    );
  }

  @override
  List<Object?> get props => [this.number];

}