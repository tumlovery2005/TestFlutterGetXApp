import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable { }

class ChatConnectionEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class ChatConnectEvent extends ChatEvent {
  final bool connect;
  final String connected;
  ChatConnectEvent({
    required this.connect,
    required this.connected
  });

  @override
  List<Object?> get props => [this.connect, this.connected];
}

class ChatLoginEvent extends ChatEvent {
  final dynamic data;
  ChatLoginEvent({
    required this.data,
  });

  @override
  List<Object?> get props => [this.data];
}

class ChatUserJoinedEvent extends ChatEvent {
  final dynamic data;
  ChatUserJoinedEvent({
    required this.data,
  });

  @override
  List<Object?> get props => [this.data];
}

class ChatTypingEvent extends ChatEvent {
  final dynamic data;
  ChatTypingEvent({
    required this.data,
  });

  @override
  List<Object?> get props => [this.data];
}

class ChatStopTypingEvent extends ChatEvent {
  final dynamic data;
  ChatStopTypingEvent({
    required this.data,
  });

  @override
  List<Object?> get props => [this.data];
}

class ChatNewMessageEvent extends ChatEvent {
  final dynamic data;
  ChatNewMessageEvent({
    required this.data,
  });

  @override
  List<Object?> get props => [this.data];
}

class ChatUserLeftEvent extends ChatEvent {
  final dynamic data;
  ChatUserLeftEvent({
    required this.data,
  });

  @override
  List<Object?> get props => [this.data];
}

class ChatSendMessageEvent extends ChatEvent {
  final String data;
  ChatSendMessageEvent({
    required this.data,
  });

  @override
  List<Object?> get props => [this.data];
}