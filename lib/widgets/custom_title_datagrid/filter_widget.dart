import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/widgets/label_textfield.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_debounce/easy_debounce.dart';

class FilterWidget extends ConsumerStatefulWidget {
  final Map<String, bool> items;
  final void Function(Map<String, bool>)? onChanged;
  final bool isNumber;
  final OverlayEntry? overlayEntry;

  const FilterWidget({super.key, required this.items, this.onChanged, this.isNumber = false, this.overlayEntry});

  @override
  ConsumerState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends ConsumerState<FilterWidget> {
  Map<String, bool> checkValue = {};
  Map<String, bool> tmp = {};

  @override
  void initState() {
    // TODO: implement initState
    checkValue = {...widget.items};
    tmp = {...widget.items};
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    checkValue.clear();
    tmp.clear();
    EasyDebounce.cancelAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: context.theme.colorScheme.border,
      footers: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: PrimaryButton(
                child: Text('Ok'),
                onPressed: () {
                  widget.onChanged?.call(checkValue);
                  widget.overlayEntry?.remove();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: OutlineButton(
                child: Text('Cancel'),
                onPressed: () {
                  widget.overlayEntry?.remove();
                  // Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: OutlinedContainer(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: LabelTextfield(
                  hintText: 'Search',
                  onChanged: (val) {
                    EasyDebounce.debounce('search', Duration(milliseconds: 300), () {
                      if (val.isNotEmpty) {
                        final filter =
                            checkValue.entries.where((e) => e.key.toLowerCase().contains(val.toLowerCase())).toList();
                        tmp = Map.fromEntries(filter);
                      } else {
                        tmp = checkValue;
                      }
                      setState(() {});
                    });
                  },
                ),
              ),
              Row(
                children: [
                  GhostButton(
                    child: Text('Select All',style: TextStyle(color: Colors.blue.shade700),),
                    onPressed: () {
                      checkValue = checkValue.map((k, v) => MapEntry(k, true));
                      setState(() {});
                    },
                  ),
                  GhostButton(
                    child: Text('Clear',style: TextStyle(color: Colors.blue.shade700),),
                    onPressed: () {
                      checkValue = checkValue.map((k, v) => MapEntry(k, false));
                      setState(() {});
                    },
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ListView(
                    children:
                        tmp.keys.map((String key) {
                          final item = checkValue[key];
                          String? keyItem = key;
                          if (keyItem.isEmpty) {
                            keyItem = '(Blank)';
                          }
                          if (widget.isNumber && keyItem.isNotEmpty) {
                            keyItem = Helper.numFormat(key);
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Checkbox(
                              trailing: Expanded(
                                child: Text(keyItem!, overflow: TextOverflow.ellipsis, softWrap: false),
                              ),
                              state: item! ? CheckboxState.checked : CheckboxState.unchecked,
                              onChanged: (val) {
                                setState(() {
                                  checkValue[key] = val.index == 0;
                                });
                              },
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
