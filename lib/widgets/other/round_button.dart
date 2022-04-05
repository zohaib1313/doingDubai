import 'package:dubai_screens/src/utils/colors.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final bool isFilled;
  final Function() onPress;

  const RoundedButton(
      {Key? key,
      required this.title,
      required this.isFilled,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
              height: 20,
              width: 50,
              child: Center(
                  child: Text(
                title,
                style: TextStyle(color: Colors.white),
              ))),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: AppColors.kPrimary))),
          backgroundColor: isFilled
              ? MaterialStateProperty.all<Color>(AppColors.kPrimary)
              : null,
        ),
        onPressed: onPress
        //   () {
        //   pop();
        //   isCountryBtn = false;
        //   isCityBtn = false;
        //   isNameBtn = true;
        //   setState(() { });
        // },
        );
  }
}
