import 'package:equatable/equatable.dart';
import 'package:tarkingapp/model/MessageModel.dart';

class ChatState extends Equatable {
  final List<MessageModel> messageModelList;
  final bool connect;
  final String connected;

  const ChatState({
    this.messageModelList = const <MessageModel>[],
    this.connect = true,
    this.connected = 'Connecting..',
  });

  ChatState copyWith({
    List<MessageModel>? messageModelList,
    bool? connect,
    String? connected,
  }) {
    return ChatState(
      messageModelList: messageModelList ?? this.messageModelList,
      connect: connect ?? this.connect,
      connected: connected ?? this.connected,
    );
  }

  @override
  List<Object?> get props => [this.messageModelList];
}