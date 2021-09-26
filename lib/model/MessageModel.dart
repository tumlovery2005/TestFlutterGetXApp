import 'package:tarkingapp/bloc/ChatCubit.dart';

class MessageModel {
    String? message;
    int? numUsers;
    MessageStatus? type;
    String? username;

    MessageModel({this.message, this.numUsers, this.type, this.username});

    factory MessageModel.fromJson(Map<String, dynamic> json) {
        return MessageModel(
            message: json['message'],
            numUsers: json['numUsers'], 
            username: json['username'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['numUsers'] = this.numUsers;
        data['username'] = this.username;
        return data;
    }
}