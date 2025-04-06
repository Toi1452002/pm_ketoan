import 'package:app_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

class GroupButtonNumberPage extends StatelessWidget {
  final void Function()? first;
  final void Function()? back;
  final void Function()? next;
  final void Function()? last;
  final String text;
  const GroupButtonNumberPage({super.key, required this.text, required this.first,required this.last,required this.back,required this.next});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        iconFirst(onPressed: first),
        iconBack(onPressed: back),
        SizedBox(width: 100,child: ColoredBox(color: context.theme.colorScheme.card,child: LabelTextfield(
          readOnly: true,
          textAlign: TextAlign.center,
          controller: TextEditingController(text: text),
        ))),
        iconNext(onPressed: next),
        iconLast(onPressed: last)

      ],
    );
  }
}
