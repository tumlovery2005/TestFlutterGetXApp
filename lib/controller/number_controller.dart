import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NumberController extends GetxController{
  int number = 0;
  String language = 'en';

  void numberIncrement(){
    number++;
    update();
  }

  void changeLanguage(){
    if(language == 'en'){
      language = 'th';
      Get.updateLocale(const Locale('th', 'TH'));
    } else {language = 'en';
      Get.updateLocale(const Locale('en', 'US'));
    }
  }
}