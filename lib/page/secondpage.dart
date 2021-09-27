import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testgetxapp/controller/number_controller.dart';

class SecondPage extends StatefulWidget {

  @override
  SecondPageState createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage>{
  NumberController numberController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Second : ${numberController.number}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          numberController.numberIncrement(),
          numberController.changeLanguage(),
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

}