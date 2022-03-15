import 'package:flutter/material.dart';
class AppBottomSheet{
  static appMaterialBottomSheet(BuildContext context, {required List<Widget> list}) {

    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: list,
            ),
          );
        });
  }
}