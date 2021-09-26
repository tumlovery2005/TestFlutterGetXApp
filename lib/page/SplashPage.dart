import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarkingapp/page/widget/TextEidget.dart';

import 'LoginPage.dart';

class SplashPage extends StatefulWidget {

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    Timer(Duration(seconds: 3), () => { nextPage() });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextTitle(title: 'Example chat.',),
              TextTitle(title: 'Socket io server.',),
            ],
          ),
        ),
      ),
    );
  }

  void nextPage(){
    Get.off(LoginPage());
  }
}