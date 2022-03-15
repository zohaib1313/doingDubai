import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/nav.dart';

class AuthButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color? backGroundColor;
  final Color? textColor;

  const AuthButton(
      {Key? key,
      required this.text,
      required this.onTap,
      this.backGroundColor,
      this.textColor})
      : super(key: key);

  @override
  _AuthButtonState createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          backgroundColor: widget.backGroundColor ?? AppColors.kPrimary,
          minimumSize: const Size.fromHeight(56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          splashFactory: InkSplash.splashFactory,
          shadowColor: Colors.white,
        ),
        onPressed: widget.onTap,
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 18,
            color: widget.textColor ?? Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ));
  }
}

class SocialButton extends StatefulWidget {
 final MainAxisAlignment? mainAxisAlignment;
  final String text;
  final String url;
  final VoidCallback onTap;
  final Color? backGroundColor;

  const SocialButton(
      {Key? key,
      required this.text,
      required this.url,
      required this.onTap,this.backGroundColor,
      this.mainAxisAlignment})
      : super(key: key);

  @override
  _SocialButtonState createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  @override
  Widget build(BuildContext context) {
    return
Padding(padding: const EdgeInsets.only(bottom: 20),child:       TextButton(
      style: TextButton.styleFrom(
        backgroundColor:widget.backGroundColor?? const Color(0xff475a96),
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        splashFactory: InkSplash.splashFactory,
        shadowColor: Colors.grey,
      ),
      onPressed: widget.onTap,
      child: Row(
        mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.center,
        children: [
          widget.mainAxisAlignment == MainAxisAlignment.start
              ? const SizedBox(
            width: 20,
          )
              : const SizedBox(),
          Image.asset(
            widget.url,
            width: 30,
            height: 30,
          ),
          widget.mainAxisAlignment == MainAxisAlignment.start
              ? const SizedBox(
            width: 35,
          )
              :           const SizedBox(
            width: 10,
          ),
          Text(
            widget.text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
  fontWeight: FontWeight.w400          ),
          ),
        ],
      ),
    ));
      }
}

class IconButtonWidget extends StatefulWidget {
  final String text;
  final IconData icon;

  const IconButtonWidget({Key? key, required this.text, required this.icon})
      : super(key: key);

  @override
  _IconButtonWidgetState createState() => _IconButtonWidgetState();
}

class _IconButtonWidgetState extends State<IconButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: 8,
          primary: AppColors.kPrimary,
          minimumSize: const Size.fromHeight(60),
          splashFactory: InkSplash.splashFactory,
          shadowColor: Colors.white,
        ),
        onPressed: () {
          AppNavigation().pop(context);
        },
        icon: Icon(
          widget.icon,
          size: 30,
          color: Colors.black,
        ),
        label: Text(
          widget.text,
          style: const TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ));
  }
}
