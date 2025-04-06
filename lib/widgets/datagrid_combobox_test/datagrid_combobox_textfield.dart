import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DataGridComboboxTextfield extends StatelessWidget {
  double? width;
  FocusNode? focusNode;
  Widget? suffix;
  bool? readOnly;
  void Function(String)? onSubmitted;
  void Function(String)? onChanged;
  TextEditingController? controller;
  bool? enabled;
  bool autofocus;
  void Function()? onTap;
  bool noBoder;
  DataGridComboboxTextfield(
      {super.key,
        this.readOnly,
        this.width,
        this.onChanged,
        this.focusNode,
        this.controller,
        this.suffix,
        this.enabled,
        this.autofocus = false,this.onTap,this.noBoder = false,
        this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      // height: 30,
      child: TextField(
        enabled: enabled,
        focusNode: focusNode,
        autofocus: autofocus,
        style: const TextStyle(fontSize: 14, height: 1.4),
        controller: controller,
        readOnly: readOnly ?? false,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        cursorHeight: 19,
        cursorWidth: 1.5,
        onTap: onTap,
        decoration: InputDecoration(
          filled: true,
          isDense: true,
          suffixIconConstraints: const BoxConstraints(
              maxHeight: 35,
              maxWidth: 30,
              minWidth: 30
          ),
          // fillColor: readOnly??false ? Colors.grey.shade200 :  Colors.white,
          fillColor: Colors.transparent,
          suffixIcon: suffix,
          hintStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w400, color: Colors.grey),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 6.5, horizontal: 5),
          border: InputBorder.none,
          // border:OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(2),
          //   borderSide:  BorderSide(
          //       color: noBoder ? Colors.transparent  : Colors.black, strokeAlign: 1, width: .3),
          // ) ,
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0),
          //   borderSide: BorderSide(
          //       color: noBoder ? Colors.transparent  : Colors.black, strokeAlign: 1, width: .3),
          // ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(width: .2, color:noBoder ? Colors.transparent  : Colors.black),
          ),
        ),
      ),
    );
  }
}
