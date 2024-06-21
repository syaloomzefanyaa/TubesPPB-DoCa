import 'package:flutter/material.dart';

class HeaderUser extends StatelessWidget {
  final String userName;
  final String profileImageUrl;

  const HeaderUser({
    Key? key,
    required this.userName,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hello, $userName",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(profileImageUrl),
          ),
        ],
      ),
    );
  }
}
