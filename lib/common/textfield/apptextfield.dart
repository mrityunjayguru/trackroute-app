import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    required this.controller,
    required this.hintText,
    this.title,
    this.border,
    this.errorText = '',
    this.obscureText = false,
    this.clearIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.maxLength,
    this.hintTextSize,
    this.readOnly = false,
    this.onTap,
    this.onClearTap,
    this.prefixIcon,
    this.inputFormatters,
    this.validator,
    this.height,
    this.boxShadow,
    this.color,
    this.decoration,
    super.key,
    this.maxLines = 1,
    this.minLine,
    this.textInputAction,
    this.contentPadding, this.suffixIconHeight,
  });
  final TextEditingController controller;
  final String? title;
  final String hintText;
  final String errorText;
  final BoxBorder? border;
  final bool obscureText;
  final String? clearIcon;
  final double? hintTextSize;
  final String? suffixIcon;
  final String? prefixIcon;
  final GestureTapCallback? onSuffixTap;
  final GestureTapCallback? onClearTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final GestureTapCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final double? height;
  final List<BoxShadow>? boxShadow;
  final Color? color;
  final Decoration? decoration;
  final int? maxLines;
  final int? minLine;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final EdgeInsetsGeometry? contentPadding;
  final double? suffixIconHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 2),
              child: Text(
                title ?? '',
                style: AppTextStyles(context)
                    .display15W500
                    .copyWith(color: AppColors.black),
              ),
            ),
            Container(
              height: height ?? 60,
              decoration: decoration ??
                  BoxDecoration(
                    border: border,
                    //  Border.all(
                    //     color: errorText.isNotEmpty
                    //         ? Colors.red
                    //         : Colors.transparent
                    //     // color ??
                    //     //     (()
                    //     //         ? Colors.red
                    //     //         : AppColors.grayLight),
                    //     ),
                    color: color ?? AppColors.whiteOff.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: boxShadow,
                  ),
              child: Row(
                children: [
                  if (prefixIcon != null) ...[
                    const SizedBox(width: 10),
                    InkWell(
                      child: SvgPicture.asset(
                        prefixIcon ?? '',
                        color: AppColors.black,
                        height: 30,
                      ),
                    ),
                  ],
                  Expanded(
                    child: TextFormField(
                      onTap: onTap,
                      readOnly: readOnly,
                      controller: controller,
                      obscureText: obscureText,
                      onChanged: onChanged,
                      cursorColor: AppColors.black,
                      style: AppTextStyles(context)
                          .display16W500
                          .copyWith(color: AppColors.black),
                      inputFormatters: inputFormatters,
                      validator: validator,
                      maxLines: maxLines,
                      minLines: minLine,
                      maxLength: maxLength,
                      textInputAction: textInputAction ?? TextInputAction.next,
                      decoration: InputDecoration(
                        fillColor: AppColors.textfield,
                        contentPadding: contentPadding ??
                            const EdgeInsets.only(
                              right: 16,
                              bottom: 4,
                              left: 16,
                            ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.red)),
                        disabledBorder: InputBorder.none,
                        hintText: hintText.tr,
                        hintStyle: AppTextStyles(context)
                            .display16W400
                            .copyWith(color: AppColors.grayLight),
                      ),
                    ),
                  ),
                  if (clearIcon != null) ...[
                    InkWell(
                      onTap: onClearTap,
                      child: SvgPicture.asset(clearIcon ?? ''),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (suffixIcon != null) ...[
                    InkWell(
                      onTap: onSuffixTap,
                      child: SvgPicture.asset(
                        suffixIcon ?? '',
                        height: suffixIconHeight,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (errorText.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            errorText.tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles(context)
                .display14W400
                .copyWith(color: AppColors.dangerDark),
          ).paddingOnly(left: 5),
        ],
      ],
    );
  }
}
