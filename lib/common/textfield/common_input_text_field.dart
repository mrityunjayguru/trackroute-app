import 'package:flutter/material.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';

class CommonAppTextField extends StatelessWidget {
  CommonAppTextField({
    required this.textController,
    this.validator,
    this.hintText,
    this.prefix,
    this.suffix,
    super.key,
  });

  final TextEditingController textController;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController, // Attach the TextEditingController
      textAlign: TextAlign.start, // Center the text horizontally
      decoration: InputDecoration(
        prefix: prefix,
        suffix: suffix,
        filled: true,
        fillColor: AppColors.textfield,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.textfield,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.textfield,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.textfield,
            width: 2.0,
          ),
        ),

        hintText: hintText ?? '',
        contentPadding: EdgeInsets.symmetric(
            vertical: 15.0, horizontal: 12.0), // Adjust padding
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text'; // Error message
            }
            return null; // No error
          },
    );
  }
}
