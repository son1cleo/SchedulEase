import 'package:flutter/material.dart';
import 'package:client/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed; // Add onPressed as a nullable parameter

  PrimaryButton({required this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Call onPressed when the button is tapped
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.08,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: onPressed != null
              ? kPrimaryColor
              : Colors.grey, // Set color based on onPressed
        ),
        child: Text(
          buttonText,
          style: textButton.copyWith(color: kWhiteColor),
        ),
      ),
    );
  }
}
