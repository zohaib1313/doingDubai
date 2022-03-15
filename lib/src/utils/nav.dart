import 'package:flutter/material.dart';

class AppNavigation {
  push(BuildContext context, Widget widget) async {
    return await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => widget));
  }

  pushReplacement(BuildContext context, Widget widget) {
    return Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => widget,
      ),
      (route) => false, //if you want to disable back feature set to false
    );
  }

  pop(BuildContext context) {
    return Navigator.of(context).pop();
  }
}
