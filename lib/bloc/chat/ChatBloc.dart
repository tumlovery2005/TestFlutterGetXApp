import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkingapp/bloc/chat/ChatState.dart';
import 'package:tarkingapp/model/MessageModel.dart';

import '../ChatCubit.dart';
import 'ChatEvent.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState>{
  ChatBloc() : super(ChatState());

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if(event is ChatConnectionEvent){
      yield await addConnect();
    } else if(event is ChatLoginEvent){
      yield await addLogin(event.data);
    } else if(event is ChatUserJoinedEvent){
      yield await addUser(event.data);
    } else if(event is ChatTypingEvent){
      yield await typing(event.data);
    } else if(event is ChatStopTypingEvent){
      yield await stopTyping(event.data);
    } else if(event is ChatNewMessageEvent){
      yield await newMessage(event.data);
    } else if(event is ChatUserLeftEvent){
      yield await userLeft(event.data);
    } else if(event is ChatSendMessageEvent){
      yield await sendMessage(event.data);
    } else if(event is ChatConnectEvent){
      yield await connection(event.connect, event.connected);
    }
  }

  Future<ChatState> connection(bool connect, String connected) async {
    return state.copyWith(
      connect: connect,
      connected: connected,
    );
  }

  Future<ChatState> addConnect() async {
    MessageModel messageModel = MessageModel();
    messageModel.message = 'Welcome to Socket.IO Chat –';
    messageModel.type = MessageStatus.Messages;
    return state.copyWith(
      messageModelList: List.of(state.messageModelList)..add(messageModel),
    );
  }

  Future<ChatState> addLogin(dynamic data) async {
    var json = jsonEncode(data);
    MessageModel messageModel = MessageModel.fromJson(jsonDecode(json));
    messageModel.message = "there's ${messageModel.numUsers} participant";
    messageModel.type = MessageStatus.Messages;
    return state.copyWith(
      messageModelList: List.of(state.messageModelList)..add(messageModel),
    );
  }

  Future<ChatState> addUser(dynamic data) async {
    var json = jsonEncode(data);
    MessageModel messageModel = MessageModel.fromJson(jsonDecode(json));
    messageModel.message = "${messageModel.username} joined";
    messageModel.type = MessageStatus.Messages;
    return state.copyWith(
      messageModelList: List.of(state.messageModelList)..add(messageModel),
    );
  }

  Future<ChatState> typing(dynamic data) async {
    var json = jsonEncode(data);
    MessageModel messageModel = MessageModel.fromJson(jsonDecode(json));
    messageModel.message = 'Typing';
    messageModel.type = MessageStatus.Typing;
    List<MessageModel> mes = state.messageModelList;;
    bool check = false;
    for(int i = 0;i < state.messageModelList.length;i++){
      if(messageModel.username == state.messageModelList[i].username
          && MessageStatus.Typing == state.messageModelList[i].type){
        check = true;
      }
    }
    if(!check){
      mes = List.of(state.messageModelList)..add(messageModel);
    }
    return state.copyWith(
      messageModelList: mes,
    );
  }

  Future<ChatState> stopTyping(dynamic data) async {
    var json = jsonEncode(data);
    MessageModel messageModel = MessageModel.fromJson(jsonDecode(json));
    messageModel.message = 'Typing';
    messageModel.type = MessageStatus.Typing;
    List<MessageModel> mes = state.messageModelList;
    int check = -1;
    for(int i = state.messageModelList.length - 1; i > -1;i--){
      if(messageModel.username == state.messageModelList[i].username
          && state.messageModelList[i].type == MessageStatus.Typing){
        check = i;
      }
    }
    if(check > -1){
      mes = List.of(state.messageModelList)..removeAt(check);
    }
    return state.copyWith(
      messageModelList: mes,
    );
  }

  Future<ChatState> newMessage(dynamic data) async {
    var json = jsonEncode(data);
    MessageModel messageModel = MessageModel.fromJson(jsonDecode(json));
    messageModel.type = MessageStatus.MessageOther;
    return state.copyWith(
      messageModelList: List.of(state.messageModelList)..add(messageModel),
    );
  }

  Future<ChatState> sendMessage(String data) async {
    MessageModel messageModel = MessageModel();
    messageModel.message = data;
    messageModel.type = MessageStatus.MessageMe;
    return state.copyWith(
      messageModelList: List.of(state.messageModelList)..add(messageModel),
    );
  }

  Future<ChatState> userLeft(dynamic data) async {
    var json = jsonEncode(data);
    MessageModel messageModel = MessageModel.fromJson(jsonDecode(json));
    messageModel.message = "${messageModel.username} left";
    messageModel.type = MessageStatus.Messages;
    return state.copyWith(
      messageModelList: List.of(state.messageModelList)..add(messageModel),
    );
  }
}