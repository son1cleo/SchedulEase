import 'package:flutter/material.dart';
import 'package:client/theme.dart';

class CheckBox extends StatefulWidget {
  final String text;
  final ValueChanged<bool> onChanged;

  CheckBox(this.text, {required this.onChanged});

  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onChanged(_isSelected);
        });
      },
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: kDarkGreyColor),
            ),
            child: _isSelected
                ? Icon(
                    Icons.check,
                    size: 17,
                    color: Colors.green,
                  )
                : null,
          ),
          SizedBox(width: 12),
          Text(widget.text),
        ],
      ),
    );
  }
}
