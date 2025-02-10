
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:track_route_pro/utils/style.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../config/theme/app_colors.dart';

// typedef SearchDropDownCallback = void Function(T?)?;
enum SearchMatch {
  ID,
  NAME,
  TAG,
}

class SearchDropDownModel {
  final String? id;
  final String? name;
  final String? tag;

  SearchDropDownModel({this.id, this.name, this.tag});

  @override
  String toString() {
    return name ?? "";
  }
}

class SearchDropDown<T extends SearchDropDownModel> extends StatelessWidget {
  final String label, hint;
  final T? selectedItem;
  final List<T> items;
  final Color dropDownColor, dropDownFillColor;
  final Color? itemBuilderUnselectedColor,
      itemBuilderSelectedColor,
      textSelectedColor,
      textUnselectedColor, containerColor;

  final SearchMatch matchingPattern;

  final TextStyle? dropDownTextStyle, itemTextStyle;
  final TextStyle hintStyle;

  final void Function(T?)? onChanged;
  final double borderOpacity;
  final bool showSearch, showBorder;
  final double? height;
  final double? width;
  final BorderRadius radius;

  SearchDropDown({
    super.key,
    this.height,
    this.selectedItem,
    required this.items,
    this.onChanged,
    this.dropDownColor = const Color(0xff3d3d3d),
    this.borderOpacity = 0.3,
    this.label = "",
    this.hint = "",
    this.showSearch = true,
    this.showBorder = true,
    this.radius = const BorderRadius.all(Radius.circular(4.0)),
    this.dropDownFillColor = AppColors.transparent,
    this.itemBuilderUnselectedColor = AppColors.white,
    this.itemBuilderSelectedColor = const Color(0xff3d3d3d),
    this.textSelectedColor = AppColors.white,
    this.textUnselectedColor =const Color(0xff3d3d3d),
    this.dropDownTextStyle,
    this.itemTextStyle,
    this.width,
    this.matchingPattern = SearchMatch.NAME, this.containerColor, required  this.hintStyle,
  }) {
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {

    final inputBorder =  OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.textBlackColor.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(16),
    );
    final transparentBorder =  OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.transparent),
      borderRadius: BorderRadius.circular(16),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Column(
            children: [
              Text(
                label,
                style: text12SemiBold,
              ),
              SizedBox(
                height: 6,
              )
            ],
          ),
        SizedBox(
          height: height ?? 20,
          width: width,
          child: DropdownSearch<T>(

            onChanged: onChanged,
            popupProps: PopupProps.menu(
              scrollbarProps: ScrollbarProps(
                trackVisibility: true,
                thumbVisibility: true,
              ),
              fit: FlexFit.loose,
              constraints: BoxConstraints(maxHeight: 200),
              showSearchBox: showSearch,
              showSelectedItems: true,
              onDismissed: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              itemBuilder: (context, item, isSelected) {
                return Column(
                  children: [
                    Container(
                      color: isSelected
                          ? (itemBuilderSelectedColor ?? AppColors.primaryColor)
                          : (itemBuilderUnselectedColor ?? AppColors.white),
                      width: 300,
                      padding: EdgeInsets.all(8),
                      child: Text(
                        item.name ?? "",
                        maxLines: 1,
                        style: itemTextStyle?.copyWith(
                              color: isSelected
                                  ? (textSelectedColor ?? AppColors.white)
                                  : (textUnselectedColor ??
                                      AppColors.textBlackColor),
                            ) ??
                            text10Medium.copyWith(
                              color: isSelected
                                  ? (textSelectedColor ?? AppColors.white)
                                  : (textUnselectedColor ??
                                      AppColors.textBlackColor),
                            ),
                      ),
                    ),
                    Container(
                    height:1,
                width: width,
                color:  AppColors.textBlackColor.withOpacity(0.5),
                )
                  ],
                );
              },
              containerBuilder: (context, popupWidget) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.textBlackColor.withOpacity(borderOpacity),
                    ),
                    borderRadius: BorderRadius.circular(4),

                  ),
                  child: popupWidget,
                );
              },
              searchFieldProps: TextFieldProps(
                style: text12Medium(),
                cursorColor: AppColors.textBlackColor,

                decoration: InputDecoration(
                  border: inputBorder,
                  focusedBorder: inputBorder,
                  errorBorder: inputBorder,
                  disabledBorder: inputBorder,
                  enabledBorder: inputBorder,
                  focusedErrorBorder: inputBorder,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            compareFn: (item1, item2) {
              switch (matchingPattern) {
                case SearchMatch.ID:
                  return item1.id == item2.id;
                case SearchMatch.NAME:
                  return item1.name == item2.name;
                case SearchMatch.TAG:
                  return item1.tag == item2.tag;
              }
            },
            dropdownButtonProps: DropdownButtonProps(

              icon:Icon(Icons.arrow_drop_down_outlined),
              // iconSize: 10,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: dropDownFillColor,
                hintStyle: hintStyle ?? text10Medium.copyWith(
                  color: AppColors.grayLight
                ),

                border: showBorder? inputBorder : transparentBorder,
                focusedBorder: showBorder? inputBorder : transparentBorder,
                errorBorder: showBorder? inputBorder : transparentBorder,
                disabledBorder: showBorder? inputBorder : transparentBorder,
                enabledBorder: showBorder? inputBorder : transparentBorder,
                focusedErrorBorder: showBorder? inputBorder : transparentBorder,
                contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              ),
            ),
            selectedItem:
                (selectedItem?.name?.isEmpty ?? true) ? null : selectedItem,
            items: items,
            itemAsString: (item) => item.name ?? "",
            // items: items,
            dropdownBuilder: (context, selectedItem) => Text(
              selectedItem?.name ?? hint,
              style: selectedItem != null
                  ? hintStyle.copyWith(
                      color: AppColors.textBlackColor)
                  :  hintStyle,
            ),
          ),
        ),
      ],
    );
  }
}
