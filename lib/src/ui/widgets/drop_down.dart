import 'package:doingdubai/src/utils/colors.dart';
import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  final List<String> list;
  final String? select;
  final String? hint;
  final Function(String) onChanged;

  const DropDownWidget({
    Key? key,
    required this.onChanged,
    required this.list,
    this.hint,
    required this.select,
  }) : super(key: key);

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String? select;

  @override
  void initState() {
    super.initState();
    select = widget.select;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
   margin: const EdgeInsets.only(bottom: 30),   padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: AppColors.kPrimary),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Text(
          widget.hint ?? 'Drop-down Selection',
        ),
        underline: const SizedBox(),
        value: select,
        // dropdownColor: Colors.grey,
        items: widget.list.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
            ),
          );
        }).toList(),
        onChanged: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
          FocusScope.of(context).requestFocus(FocusNode());

          setState(() {
            select = _!;
          });
          widget.onChanged(select!);
        },
      ),
    );
  }
}
