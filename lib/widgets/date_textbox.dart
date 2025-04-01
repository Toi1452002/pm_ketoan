import 'package:app_ketoan/widgets/label_textfield.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as sh;

import '../core/utils/helper.dart';

class DateTextbox extends StatefulWidget {
  DateTextbox({super.key, required this.onChanged, this.initialDate, this.label = '', this.openDialog = true, this.showClear = true, this.spacing = 5});
  final bool  showClear;
  final String label;
  final ValueChanged<DateTime?> onChanged;
  DateTime? initialDate;
  final double spacing;
  final bool openDialog;
  @override
  State<DateTextbox> createState() => _DateTextboxState();
}

class _DateTextboxState extends State<DateTextbox> {
  final controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    if(widget.initialDate!=null){
      controller.text = Helper.dateFormatDMY(widget.initialDate!);
    }
    return LabelTextfield(
      label: widget.label,
      controller: controller,
      spacing: widget.spacing,
      hintText: 'dd/mm/yyyy',
      readOnly: true,

      trailing: !widget.showClear? null :InkWell(
        child: const Icon(
          Icons.clear,
          size: 15,
        ),
        onTap: () {
          setState(() {
            widget.initialDate = null;
            controller.clear();
            widget.onChanged.call(null);

          });
        },
      ),
      onTap: !widget.openDialog ? null :  () async {

        final date = await showDatePicker(
          builder: (context, child){
            return Theme(data: ThemeData(
              colorSchemeSeed: Colors.blue,
              datePickerTheme: DatePickerThemeData(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)
                  )
              ),
            ), child: child!);
          },
          context: context,
          helpText: widget.label,
          initialDate: widget.initialDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(3000),
        );

        if (date != null) {
          widget.onChanged.call(date);
          controller.text = Helper.dateFormatDMY(date);
        }
      },
    );
  }
}
