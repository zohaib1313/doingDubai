import 'package:dubai_screens/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgViewer extends StatelessWidget {
  final String svgPath;
  final double? height;
  final double? width;
  final Color? color;

  const SvgViewer(
      {Key? key, required this.svgPath, this.height, this.width, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgPath,
      color: color,
      height: height ?? 18,
      width: width ?? 18,
    );
  }
}

mySimpleCheckBox(
    {onTap,
    onMessageTap,
    Color? fillColor,
    bool isActive = false,
    Color? checkColor,
    required String message,
    Color? messageColor}) {
  return Row(
    children: [
      InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: fillColor ?? AppColors.whiteColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: isActive
              ?  Icon(
                  Icons.check,
                  color: AppColors.blackColor,
                  size: 12.0,
                )
              : const SizedBox(
                  height: 12,
                  width: 12,
                ),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      InkWell(
        onTap: onMessageTap,
        child: Text(
          message,
          style: TextStyle(
              decoration: TextDecoration.underline,
              color: AppColors.primaryColor),
        ),
      )
    ],
  );
}


