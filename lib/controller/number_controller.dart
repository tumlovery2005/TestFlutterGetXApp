import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NumberController extends GetxController{
  int number = 0;

  void numberIncrement(){
    number++;
    update();
  }
}