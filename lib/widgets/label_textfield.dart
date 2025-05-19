import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class LabelTextfield extends StatelessWidget {
  final String? label;
  final double spacing;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final bool obscureText;
  final void Function(String)? onSubmitted;
  final bool autofocus;
  final int? maxLines;
  final bool enabled;
  final bool isNumber;
  final bool isUpperCase;
  final TextAlign textAlign;
  final String? hintText;
  final bool readOnly;
  final void Function()? onTap;
  final Widget? trailing;
  final FocusNode? focusNode;
  final bool isDouble;
  final int? maxLength;
  final TextStyle? style;
  final Color? color;
  const LabelTextfield({
    super.key,
    this.label,
    this.spacing = 10,
    this.isNumber = false,
    this.isDouble = false,
    this.isUpperCase = false,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.autofocus = false,
    this.controller,
    this.obscureText = false,
    this.onSubmitted,this.hintText,
    this.focusNode,
    this.textAlign = TextAlign.start, this.readOnly = false, this.onTap, this.trailing, this.maxLength, this.style, this.color
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: spacing,
      children: [
        if (label != null) Text(label ?? '', style: TextStyle(fontSize: 13,color: !enabled?Colors.gray.shade400:null)).medium(),
        Expanded(
          child: TextField(
            maxLength: maxLength,
            readOnly: readOnly,
            decoration: color!=null? BoxDecoration(color: color,border: Border.all(color: Colors.blue.shade900,width: .5),borderRadius: BorderRadius.circular(3)) : null,
            placeholder: Text(hintText??''),
            enabled: enabled,
            maxLines: maxLines,
            onChanged: onChanged,
            controller: controller,
            obscureText: obscureText,
            onSubmitted: onSubmitted,
            focusNode: focusNode,
            onTap: onTap,
            trailing: trailing,
            textAlign: textAlign,
            autofocus: autofocus,
            style: style,
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            inputFormatters: [
              if(isUpperCase)TextInputFormatters.toUpperCase,
              if (isNumber) FilteringTextInputFormatter.allow(RegExp(r'[\d\,]')),
              if (isDouble) FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
            ],
          ),
        ),
      ],
    );
  }
}
