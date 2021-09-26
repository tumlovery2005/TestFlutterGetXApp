import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarkingapp/page/CahtPage.dart';
import 'package:tarkingapp/page/widget/TextEidget.dart';

class LoginPage extends StatefulWidget {

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final niclNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextTitle(title: "What's your nickname?",),
              getTextFileds(),
              getButton('Login'),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTextFileds(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        left: 30,
        right: 30
      ),
      child: TextField(
        controller: niclNameController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.white),
          ),
          labelText: 'Nickname',
          labelStyle: TextStyle(
            color: Colors.blue,
          ),
          hintText: 'Nickname.',
          hintStyle: TextStyle(
            color: Colors.blue
          ),
          fillColor: Colors.white,
        ),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget getButton(String title){
    return Container(
      margin: EdgeInsets.only(top: 10,),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                color: Colors.white,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () => _mainChat(),
              //     () {
              //   Navigator.pop(context);
              //   Navigator.push(context, MaterialPageRoute(builder: (context) =>
              //       ChatPage(nickName: niclNameController.text))
              //   );
              // },
              child: Text('$title', style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }

  _mainChat(){
    if(niclNameController.text != ''){
      Get.off(ChatPage(nickName: niclNameController.text));
    }
  }
}