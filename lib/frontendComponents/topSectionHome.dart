import 'package:flutter/material.dart';

class TopSectionHome extends StatelessWidget {
  final Function() onShopPressed;
  final Function() onSettingPressed;

  TopSectionHome({
    Key? key,
    required this.onShopPressed,
    required this.onSettingPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.topCenter,
      height: 80.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 70.0,
            height: 70.0,
            child: IconButton(
              icon: Image.asset('assets/icons/shop.png'),
              iconSize: 30.0,
              onPressed: onShopPressed,
            ),
          ),
          SizedBox(
            width: 70.0,
            height: 70.0,
            child: IconButton(
              icon: Image.asset('assets/icons/settings.png'),
              iconSize: 30.0,
              onPressed: onSettingPressed,
            ),
          ),
        ],
      ),
    );
  }
}
