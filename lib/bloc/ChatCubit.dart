import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkingapp/model/MessageModel.dart';

enum MessageStatus {Messages, MessageMe, MessageOther, Typing}
class ChatCubit extends Cubit<List<MessageModel>>{
  ChatCubit() : super([]);

  void addConnect(){
    MessageModel messageModel = MessageModel();
    messageModel.message = 'Welcome to Socket.IO Chat –';
    messageModel.type = MessageStatus.Messages;
    state.add(messageModel);
    emit(state);
  }

  void addLogin(dynamic data){
    var json = jsonEncode(data);
    MessageModel messageModel = MessageModel.fromJson(jsonDecode(json));
    messageModel.message = "there's ${messageModel.numUsers} participant";
    messageModel.type = MessageStatus.Messages;
    state.add(messageModel);
    emit(state);
  }

  void addUser(dynamic data) {
    var json = jsonEncode(data);
    MessageModel messageModel = MessageModel.fromJson(jsonDecode(json));
    messageModel.message = "${messageModel.username} joined";
    messageModel.type = MessageStatus.Messages;
    state.add(messageModel);
    print('addUser ${state.length}');
    emit(state);
  }
}