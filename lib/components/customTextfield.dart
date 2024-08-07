import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maha_kundali_app/theme/colors.dart';

class KTextField extends StatelessWidget {
  TextEditingController? controller;
  String title;
  TextInputType? textInputType;
  int? textLimit;
  String? prefixText;
  Widget? suffixButton;
  Function(String)? onChanged;
  bool? obscureText;
  bool? readOnly;
  bool? fillColor;
  String? errorText;
  Function()? onClick;
  var validation;
  KTextField({
    Key? key,
    required this.title,
    this.controller,
    this.textInputType,
    this.textLimit,
    this.prefixText,
    this.suffixButton,
    this.onChanged,
    this.obscureText,
    this.readOnly,
    this.validation,
    this.errorText,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
      child: TextFormField(
        onTap: onClick ?? () {},
        readOnly: readOnly ?? false,
        obscureText: obscureText ?? false,
        keyboardType: textInputType,
        controller: controller,
        inputFormatters: [
          LengthLimitingTextInputFormatter(textLimit),
        ],
        onChanged: onChanged,
        style: TextStyle(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          border: outlineBorderStyle(),
          focusedBorder: focusBorderStyle(),
          enabledBorder: enableBorderStyle(),
          errorText: errorText ?? null,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          filled: fillColor ?? true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          hintText: title,
          hintStyle: hintTextStyle(context),
          labelText: title,
          prefixIcon: textLimit == 10
              ? Padding(
                  padding: EdgeInsets.only(left: 10, top: 12.0),
                  child: Text('+91'))
              : null,
          suffixIcon: suffixButton,
          prefixText: prefixText ?? '',
          suffixIconColor: Colors.grey,
        ),
        validator: validation ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return 'Please enter some text';
        //   }
        //   return null;
        // },
      ),
    );
  }
}

TextStyle hintTextStyle(BuildContext context) {
  return TextStyle(
    color: Theme.of(context).scaffoldBackgroundColor != Colors.black
        ? Colors.black
        : Colors.white,
    fontWeight: FontWeight.w400,
  );
}

OutlineInputBorder outlineBorderStyle() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5),
  );
}

OutlineInputBorder focusBorderStyle() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    borderSide: BorderSide(width: 1, color: Colors.grey),
  );
}

OutlineInputBorder enableBorderStyle() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    borderSide: BorderSide(width: 0.5, color: Colors.grey.shade400),
  );
}

class SearchTextField extends StatelessWidget {
  TextEditingController? controller;
  Function()? onClear;
  Function(String)? onChanged;
  bool? readOnly;
  String? hintText;
  Function()? onClick;
  SearchTextField(
      {Key? key,
      this.controller,
      this.onClear,
      this.onChanged,
      this.readOnly,
      this.hintText,
      this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 3,
            color: kMainColor.withOpacity(0.4),
            offset: Offset(1, 3),
          ),
        ],
      ),
      child: TextField(
        onTap: onClick ?? () {},
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly ?? false,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: kMainColor, size: 30),
          hintText: hintText ?? 'Search',
          hintStyle: TextStyle(color: kMainColor),
          suffixIcon: onClear != null
              ? IconButton(
                  onPressed: onClear,
                  icon: Icon(Icons.clear),
                )
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}

class MessageTextField extends StatelessWidget {
  String title;
  TextEditingController? controller;
  bool? validate;
  bool? fillColor;
  Function(String)? onChanged;
  MessageTextField(
      {Key? key,
      required this.title,
      this.controller,
      this.validate,
      this.fillColor,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
      child: TextFormField(
        maxLines: 3,
        keyboardType: TextInputType.text,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: outlineBorderStyle(),
          focusedBorder: focusBorderStyle(),
          enabledBorder: enableBorderStyle(),
          filled: fillColor ?? true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          labelText: title,
          errorText: validate == true ? 'Fill the required field' : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
  }
}

class SmallTextField extends StatelessWidget {
  String title;
  TextEditingController? controller;
  Widget? suffixButton;
  bool? readOnly;
  Function()? onClick;
  SmallTextField({
    super.key,
    required this.title,
    this.controller,
    this.suffixButton,
    this.readOnly,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        onTap: onClick ?? () {},
        readOnly: readOnly ?? false,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 5),
          hintText: title,
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          suffixIcon: suffixButton,
        ),
      ),
    );
  }
}
