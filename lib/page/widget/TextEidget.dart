import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  final String? title;
  TextTitle({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Text('$title',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30
        ),
      ),
    );
  }

}