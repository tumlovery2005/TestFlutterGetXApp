import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tarkingapp/bloc/number/NumberBloc.dart';
import 'package:tarkingapp/bloc/number/NumberEvent.dart';
import 'package:tarkingapp/bloc/number/NumberState.dart';
import 'package:tarkingapp/page/SplashPage.dart';

import 'bloc/NumberCubit.dart';
import 'bloc/chat/ChatBloc.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;


void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
    //   GetMaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   debugShowCheckedModeBanner: false,
    //   home: SplashPage(),
    //   // MyHomePage(title: 'Flutter Demo Home Page'),
    // );

      MultiBlocProvider(
      providers: [
        BlocProvider<NumberBloc>(
          create: (_) => NumberBloc(),
        ),
        BlocProvider<ChatBloc>(
          create: (_) => ChatBloc(),
        ),
      ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );

    //   BlocProvider(
    //   create: (_) => NumberCubit(),
    //   child: MaterialApp(
    //     title: 'Flutter Demo',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     debugShowCheckedModeBanner: false,
    //     home: SplashPage(),
    //     // MyHomePage(title: 'Flutter Demo Home Page'),
    //   ),
    // );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final numberController = Get.put(NumberController());
  late NumberBloc numberCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NumberCubit>(create: (_) => NumberCubit(),),
        BlocProvider<NumberBloc>(
          create: (_) => NumberBloc()..add(NumberIncrementEvent(number: 0)),
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              getCol(),
              // Obx(() => Text(
              //   '${numberController.count}',
              //   style: Theme.of(context).textTheme.headline4,
              // )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // onPressed: numberController.increment,
          onPressed: () => numberCubit..add(NumberIncrementEvent(number: 5)),
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
  
  Widget getCol(){
    return BlocBuilder<NumberBloc, NumberState>(
      builder: (context, state) {
        numberCubit = BlocProvider.of<NumberBloc>(context);
        if(state is NumberIncrementState){
          bool select = state.number == 1 ? true : false;
          return TextNumber(number: state.number!, select: select);
        } else {
          return Container();
        }
      },
    );
  }
}

class TextNumber extends StatelessWidget {
  final int number;
  final bool select;
  TextNumber({
    required this.number,
    required this.select,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    select == true ? Color(0xFF3b51b1) : Colors.white,
                    select == true ? Color(0xFF498fe1) : Colors.white
                  ])),
          child: Text(
            '$number',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: select == true ? Colors.white : Colors.black),
          )
      );
  }
}

class NumberController extends GetxController {
  var count = 10.obs;
  increment() => count >0 ? count-- : count = 10.obs;
}
