
import 'package:dubai_screens/src/utils/images.dart';
import 'package:flutter/material.dart';

class LogoImageWidget extends StatelessWidget {
  const LogoImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.only(bottom: 50),
      child: Center(
          child: Image.asset(
        AppImages.logoApp,
        height: 140,
        width: 140,
      )),
    );
  }
}
