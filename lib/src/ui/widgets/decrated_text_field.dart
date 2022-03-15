import 'package:doingdubai/src/utils/colors.dart';
import 'package:flutter/material.dart';

class DecoratedTextField extends StatefulWidget {
  final String hintText;
  final IconData? prefix;
  final bool? obscure;
  final TextEditingController controller;
  final TextInputType? textInputType;
  final FormFieldValidator<String>? validator;

  const DecoratedTextField(
      {Key? key,
      this.textInputType,
      this.obscure = false,
      this.prefix,
      required this.controller,
      required this.hintText, this.validator})
      : super(key: key);

  @override
  _DecoratedTextFieldState createState() => _DecoratedTextFieldState();
}

class _DecoratedTextFieldState extends State<DecoratedTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        // color: Colors.grey[100],
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 4, 5, 4),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            scrollPadding: const EdgeInsets.all(150),
            cursorColor: AppColors.kPrimary,
            obscureText: widget.obscure!,
            validator: widget.validator,
            onChanged: (_) {
              setState(() {});
            },
            controller: widget.controller,
            keyboardType: widget.textInputType,
            // validator: widget.validator,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText,
                suffixIcon: widget.controller.text.isEmpty
                    ? const SizedBox()
                    : Icon(
                        Icons.check,
                        size: 20,
                        color: AppColors.kPrimary,
                      )),
          ),
        ),
      ),
    );
  }
}

class SearchField extends StatefulWidget {
  final String hintText;
  final IconData? prefix;
  final bool? obscure;
  final Function(String)? onChange;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? textInputType;

  const SearchField(
      {Key? key,
      this.textInputType,
      this.obscure = false,
      this.prefix,
      required this.controller,
      required this.hintText, this.validator, this.onChange})
      : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Material(
      // color: Colors.white,elevation: 0.5,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 4, 5, 4),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          scrollPadding: const EdgeInsets.all(150),
          cursorColor: AppColors.kPrimary,
          obscureText: widget.obscure!,
          onChanged: widget.onChange,
          controller: widget.controller,
          keyboardType: widget.textInputType,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              hintText: widget.hintText,
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.kPrimary,
              ),
              suffixIcon: widget.controller.text.isEmpty
                  ? const SizedBox()
                  : Icon(
                      Icons.check,
                      size: 20,
                      color: AppColors.kPrimary,
                    )),
        ),
      ),
    );
  }
}
