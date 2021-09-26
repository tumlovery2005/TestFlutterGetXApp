import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tarkingapp/bloc/ChatCubit.dart';
import 'package:tarkingapp/bloc/chat/ChatBloc.dart';
import 'package:tarkingapp/bloc/chat/ChatEvent.dart';
import 'package:tarkingapp/bloc/chat/ChatState.dart';
import 'package:tarkingapp/model/MessageModel.dart';

class ChatPage extends StatefulWidget {
  final String nickName;
  ChatPage({
    required this.nickName,
    Key? key,
  }) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late ChatBloc chatBloc;
  final chatController = Get.put(ChatController());
  final ScrollController _scrollController = new ScrollController();
  final messageController = TextEditingController();
  double width = 0;
  IO.Socket socket = IO.io('http://192.168.1.33:3000', OptionBuilder()
      .setTransports(['websocket']) // for Flutter or Dart VM
      .setExtraHeaders({'foo': 'bar'}) // optional
      .build());

  @override
  void initState() {
    super.initState();
    connectServer();
  }

  void connectServer(){
    socket.onConnect((_) {
      _connect(false, 'Connected');
      socket.emit('add user', widget.nickName);
    });
    socket.on('login', (data) => _onLogin(data));
    socket.on('user joined', (data) => _onUserJoin(data));
    socket.on('typing', (data) => _tyPing(data));
    socket.on('stop typing', (data) => _stopTyping(data));
    socket.on('new message', (data) => _newMessage(data));
    socket.on("user left", (data) => _userLeft(data));
    socket.onDisconnect((_) => _connect(true, 'disconnect'));
    socket.onConnectError((data) => _connect(true, data.toString()));
    socket.connect();
  }

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter chat demo'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: GetBuilder<ChatController>(
          builder: (_) =>  Column(
            children: <Widget>[
              Visibility(
                visible: chatController.connect,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(width * 2),
                  color: chatController.connect ? Colors.red : Colors.green,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('${chatController.connected}', style: TextStyle(
                        color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: chatController.messageModelList.length,
                  itemBuilder: (BuildContext context, int index) {
                    MessageModel model = chatController.messageModelList[index];
                    if(model.type == MessageStatus.Messages){
                      return getMessages('${model.message}');
                    } else if(model.type == MessageStatus.Typing){
                      return getTyping('${model.username}');
                    } else if(model.type == MessageStatus.MessageOther){
                      return getMessageOther(model);
                    } else {
                      return getMessageMe(model);
                    }
                  },
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.black,
                padding: EdgeInsets.only(
                  left: width * 2, top: width * 2, bottom: width * 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(
                          left: width, right: width,
                        ),
                        child: TextFormField(
                          onChanged: (data) => _sendTyping(data),
                          controller: messageController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.blue,
                            ),
                            hintText: 'Message.',
                            hintStyle: TextStyle(
                                color: Colors.grey
                            ),
                            fillColor: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.blue,
                      tooltip: 'send message',
                      onPressed: () => _sendMessage(messageController.text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getMessages(String message){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 2),
      child: Center(
        child: Text(message),
      ),
    );
  }

  Widget getTyping(String nickName){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('$nickName : '),
          new Image(
            image: AssetImage("assets/images/typing.gif"),
            width: width * 10,
            height: width * 4,
          )
        ],
      ),
    );
  }

  Widget getMessageOther(MessageModel messageModel){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${messageModel.username}'),
          Container(
            margin: EdgeInsets.only(
              right: width * 30,
            ),
            padding: EdgeInsets.all(width * 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(width * 2)),
              color: Colors.grey[400],
            ),
            child: Text('${messageModel.message}', style: TextStyle(
              color: Colors.black,),
            ),
          ),
        ],
      ),
    );
  }

  Widget getMessageMe(MessageModel messageModel){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 2),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: EdgeInsets.only(
            left: width * 30,
          ),
          padding: EdgeInsets.all(width * 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(width * 2)),
            color: Colors.deepPurple,
          ),
          child: Text('${messageModel.message}', style: TextStyle(
            color: Colors.white,),
          ),
        ),
      ),
    );
  }

  _connect(bool connect, String connected){
    chatController.setConnection(connect, connected);
  }

  _onLogin(dynamic data){
    chatController.addConnect();
    chatController.addLogin(data);
    // chatBloc..add(ChatConnectionEvent());
    // chatBloc..add(ChatLoginEvent(data: data));
  }

  _onUserJoin(dynamic data){
    chatController.addUser(data);
    chatController.addLogin(data);
    // chatBloc..add(ChatUserJoinedEvent(data: data));
    // chatBloc..add(ChatLoginEvent(data: data));
  }

  _tyPing(dynamic data){
    chatController.typing(data);
    // chatBloc..add(ChatTypingEvent(data: data));
    _scrollToBottom();
  }

  _stopTyping(dynamic data){
    chatController.stopTyping(data);
    // chatBloc..add(ChatStopTypingEvent(data: data));
    _scrollToBottom();
  }

  _newMessage(dynamic data){
    chatController.newMessage(data);
    // chatBloc..add(ChatNewMessageEvent(data: data));
    _scrollToBottom();
  }

  _userLeft(dynamic data){
    chatController.userLeft(data);
    chatController.addLogin(data);
    // chatBloc..add(ChatUserLeftEvent(data: data));
    // chatBloc..add(ChatLoginEvent(data: data));
  }

  _sendTyping(String data){
    if(data == ''){
      socket.emit('stop typing');
    } else {
      socket.emit('typing');
    }
  }

  _sendMessage(String data){
    if(data == '') return;

    socket.emit('stop typing');
    socket.emit('new message', data);
    chatController.sendMessage(data);
    // chatBloc..add(ChatSendMessageEvent(data: data));
    messageController.clear();
    _scrollToBottom();
  }

  _scrollToBottom() async {
    await Future.delayed(Duration(milliseconds: 300), (){
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    });
  }
}

class ChatController extends GetxController {
  List<MessageModel> messageModelList = [];
  var connect = true;
  var connected = 'Connecting....';

  void setConnection(var connect, var connected){
    this.connect = connect;
    this.connected = connected;
    update();
  }

  void addConnect() {
    MessageModel messageModel = MessageModel();
    messageModel.message = 'Welcome to Socket.IO Chat –';
    messageModel.type = MessageStatus.Messages;
    messageModelList..add(messageModel);
    update();
  }

  void addLogin(dynamic data) {
    var json = jsonEncode(data);
    MessageModel messageModel = MessageModel.fromJson(jsonDecode(json));
    messageModel.message = "there's ${messageModel.numUsers} participant";
    messageModel.type = MessageStatus.Messages;
    messageModelList..add(messageModel);
    update();
  }

  void addUser(dynamic data) {
    var json = jsonEncode(data);
    MessageModel messageModel = MessageModel.fromJson(jsonDecode(json));
    messageModel.message = "${messageModel.username} joined";
    messageModel.type = MessageStatus.Messages;
    messageModelList..add(messageModel);
    update();
  }

  void typing(dynamic data) {
    var json = jsonEncode(data);
    MessageModel messageModel = MessageModel.fromJson(jsonDecode(json));
    messageModel.message = 'Typing';
    messageModel.type = MessageStatus.Typing;
    bool check = false;
    for(int i = 0;i < messageModelList.length;i++){
      if(messageModel.username == messageModelList[i].username
          && MessageStatus.Typing == messageModelList[i].type){
        check = true;
      }
    }
    if(!check){
      messageModelList..add(messageModel);
    }
    update();
  }

  void stopTyping(dynamic data) {
    var json = jsonEncode(data);
    MessageModel messageModel = MessageModel.fromJson(jsonDecode(json));
    messageModel.message = 'Typing';
    messageModel.type = MessageStatus.Typing;
    int check = -1;
    for(int i = messageModelList.length - 1; i > -1;i--){
      if(messageModel.username == messageModelList[i].username
          && messageModelList[i].type == MessageStatus.Typing){
        check = i;
      }
    }
    if(check > -1){
      messageModelList..removeAt(check);
    }
    update();
  }

  void newMessage(dynamic data) {
    var json = jsonEncode(data);
    MessageModel messageModel = MessageModel.fromJson(jsonDecode(json));
    messageModel.type = MessageStatus.MessageOther;
    messageModelList..add(messageModel);
    update();
  }

  void sendMessage(String data) {
    MessageModel messageModel = MessageModel();
    messageModel.message = data;
    messageModel.type = MessageStatus.MessageMe;
    messageModelList..add(messageModel);
    update();
  }

  void userLeft(dynamic data) {
    var json = jsonEncode(data);
    MessageModel messageModel = MessageModel.fromJson(jsonDecode(json));
    messageModel.message = "${messageModel.username} left";
    messageModel.type = MessageStatus.Messages;
    messageModelList..add(messageModel);
    update();
  }
}