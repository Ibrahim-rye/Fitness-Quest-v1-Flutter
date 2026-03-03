import 'package:flutter/material.dart';
import './avatarView.dart';

class TopSection extends StatelessWidget {
  final Function() onEditPressed;
  final Function() onAvatarPressed;

  TopSection({
    Key? key,
    required this.onEditPressed,
    required this.onAvatarPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      alignment: Alignment.topCenter,
      height: 200.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 64.0,
            height: 64.0,
            child: IconButton(
              icon: Image.asset('assets/icons/edit.png'),
              iconSize: 30.0,
              onPressed: onEditPressed,
            ),
          ),
          AvatarView(),
          SizedBox(
            width: 64.0,
            height: 64.0,
            child: IconButton(
              icon: Image.asset('assets/icons/avatar.png'),
              iconSize: 30.0,
              onPressed: onAvatarPressed,
            ),
          ),
        ],
      ),
    );
  }
}
