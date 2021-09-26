import 'package:equatable/equatable.dart';

abstract class NumberEvent extends Equatable { }

class NumberIncrementEvent extends NumberEvent {
  final int number;
  NumberIncrementEvent({required this.number});

  @override
  List<Object?> get props => [this.number];
}