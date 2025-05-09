import 'package:flutter/material.dart' as ma;
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'combobox.dart';

class LabelCombobox extends StatelessWidget {
  const LabelCombobox(
      {super.key,
        this.width,
        this.label = '',
        this.spacing = 5,
        required this.items,
        required this.onChanged,
        this.columnWidth,
        this.readOnly,
        this.selected,this.menuWidth,
        this.enabled = true, this.iconColor, this.isChangeEmpty = true});

  final String label;
  final double? width;
  final double spacing;
  final List<ComboboxItem> items;
  final void Function(String? val, dynamic o)? onChanged;
  // final void Function(String?)? onLongPress;
  final List<double>? columnWidth;
  final bool? readOnly;
  final bool enabled;
  final String? selected;
  final double? menuWidth;
  final Color? iconColor;
  final bool isChangeEmpty;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: spacing,
      children: [
        if (label != '')
          Text(
            label,
            style: TextStyle(fontSize: 13,color: !enabled?Colors.gray.shade400:null),
          ).medium(),
        if (width == null) Expanded(child: combobox()),
        if (width != null) SizedBox(width: width, child: combobox()),
      ],
    );
  }

  Widget combobox() => Combobox(
    items: items,
    menuWidth: menuWidth,
    onChanged: onChanged,
    columnWidth: columnWidth,
    readOnly: readOnly,
    selected: selected,
    enabled: enabled,
    isChangeEmpty: isChangeEmpty,
  );
}
