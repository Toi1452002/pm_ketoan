import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as sh;
import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

export 'label_combobox.dart';
class Combobox extends StatefulWidget {
  final List<ComboboxItem> items;
  final bool? readOnly;
  final bool? enabled;
  final List<double>? columnWidth;
  final Function(String? val,dynamic o)? onChanged;
  final String? selected;
  final bool isChangeEmpty;
  final double? menuWidth;
  const Combobox(
      {super.key,
        required this.items,
        this.readOnly,
        this.selected,
        this.enabled,
        required this.onChanged,
        this.columnWidth,
        this.menuWidth,
        this.isChangeEmpty = true});
  @override
  State<Combobox> createState() => _ComboboxState();
}

class _ComboboxState extends State<Combobox> {
  late OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final _textFocus = FocusNode();
  final _txtController = TextEditingController();

  ScrollController _scrollController = ScrollController();
  bool _isOpen = false;
  bool _onTapList = false; // Có thao tác vào list hay không
  // String? _selectedValue;
  int? _indexSearch;
  final ValueNotifier<String?> _selectValue = ValueNotifier<String?>(null);
  double? _lastScrollOffset; // Lưu trữ vị trí cuộn trước đó


  @override
  void initState() {
    // TODO: implement initState
    if (widget.selected != null) {
      _txtController.text = widget.selected!;
      _selectValue.value = widget.selected!;
    }

    _textFocus.addListener(() {
      if (_textFocus.hasFocus) {
        _open();
      } else if (!_textFocus.hasFocus && !_onTapList) {
        if (_indexSearch != null) {
          // Có tìm kiếm
          if (_indexSearch != -1) {
            // Có giá trị
            final item = widget.items[_indexSearch!];
            _txtController.text = item.title.first;
            widget.onChanged!(item.value, item.valueOther);
            _saveOffset();
          }
        } else if (_indexSearch == null) {
          // Không có giá trị tìm kiếm
          if (_selectValue.value == null) {
            if (widget.selected != null && widget.selected!.isNotEmpty && _txtController.text.isNotEmpty) {
              _txtController.text = widget.items.firstWhere((e) => e.value == widget.selected, orElse: () => ComboboxItem(value: '', title: [''])).title.first;
              _selectValue.value = widget.selected;
            } else {
              _txtController.clear();
              _saveOffset(value: 0);
              _indexSearch = null;
            }
          } else if (_selectValue.value != null) {
            // widget.onChanged!('');
            _txtController.text = widget.items
                .firstWhere((e) => e.value == _selectValue.value,
                orElse: () => ComboboxItem(value: '', title: ['']))
                .title
                .first;
            _indexSearch = null;
          }
        }
        _indexSearch = null;
        _close();
      }
    });
    super.initState();
  }

  void _open() {
    if (!_isOpen) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      if (_lastScrollOffset != null && widget.items.length > 8) {
        if(widget.selected!=null && (_lastScrollOffset!-(_searchItem(widget.selected!)*25)>120 || _lastScrollOffset!-(_searchItem(widget.selected!)*25)<0) ){
          _scrollController = ScrollController(initialScrollOffset: _searchItem(widget.selected!)*25);
        }else{
          _scrollController = ScrollController(initialScrollOffset: _lastScrollOffset!);
        }
      } else if (_selectValue.value != null && widget.items.length > 8 && _lastScrollOffset == null) {
        int index = _searchItem(widget.selected!);
        _scrollController = ScrollController(initialScrollOffset: index * 25);
      }
      setState(() {
        _isOpen = true;
      });
    }
  }

  void _close() {
    if (_isOpen) {
      _overlayEntry?.remove();
      _textFocus.unfocus();

      setState(() {
        _isOpen = false;
      });
    }
  }

  void _onTapItem(ComboboxItem item) {
    _close();
    _txtController.text = item.title.first;
    _selectValue.value = item.value;
    // _indexSearchNotifier.value = _searchItem(item.value);
    widget.onChanged!(item.value,item.valueOther);
    _saveOffset();
  }

  void _onChangeText(String val) {
    if (val.isNotEmpty) {
      int index = widget.items.indexWhere((e) => e.title.first.toLowerCase().contains(val.toLowerCase()));
      if (index != -1) {
        if (index != _indexSearch) {
          _scrollController.jumpTo(index * 25);
          _selectValue.value = widget.items[index].value;
          _indexSearch = index;

          // _indexSearchNotifier.value = index;
        }
      } else if (index == -1) {
        _scrollController.jumpTo(0);
        _selectValue.value = null;
        _indexSearch = null;
      }
    } else {
      _scrollController.jumpTo(0);
      if (widget.isChangeEmpty) {
        widget.onChanged!(null,null); //Thay doi gia tri
        _selectValue.value = null;
      }
      _indexSearch = null;
      // setState(() {

      // });


    }
  }

  int _searchItem(String value) {
    if (widget.items.isNotEmpty) {
      return widget.items.indexWhere((e) => e.value == value);
    } else {
      return -1;
    }
  }

  void _saveOffset({double? value}) {
    _lastScrollOffset = value ?? _scrollController.offset;
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return OverlayEntry(builder: (context) {
      return Positioned(
        width: widget.menuWidth ?? size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Material(
            color: context.theme.colorScheme.card,
            elevation: 5,
            child: Listener(
              onPointerDown: (e) {
                if (e.kind == PointerDeviceKind.mouse) {
                  _onTapList = true;
                }
              },
              onPointerUp: (e) {
                _textFocus.requestFocus();
                if (e.kind == PointerDeviceKind.mouse) {
                  _onTapList = false;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: .4),
                ),
                height: widget.items.length < 8 ? widget.items.length * 25 : 200,
                child: ValueListenableBuilder(
                  valueListenable: _selectValue,
                  builder: (context, selectValue, child) => SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: List.generate(widget.items.length, (rowIndex) {
                        final rows = widget.items[rowIndex];
                        return InkWell(
                          onTap: () {
                            _onTapItem(rows);
                          },
                          child: Container(
                            height: 25,
                            margin: EdgeInsets.zero,
                            color: rows.value == selectValue ? Colors.blue.shade800 : null,
                            child: Row(
                              children: List.generate(rows.title.length, (titleIndex) {
                                return Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 3),
                                      width:
                                      widget.columnWidth != null ? widget.columnWidth![titleIndex] : size.width - 1,
                                      margin: EdgeInsets.zero,
                                      child: Text(
                                        rows.title[titleIndex],
                                        maxLines: 1,
                                        // overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(
                                            fontSize: 13.5, color: rows.value == selectValue ? Colors.white : null),
                                      ),
                                    ),
                                    if (titleIndex < rows.title.length - 1 && rows.title.length > 1)
                                       VerticalDivider(
                                        color:context.theme.colorScheme.secondaryForeground,
                                        width: 1,
                                        thickness: .3,
                                        // width: .1,
                                      )
                                  ],
                                );
                              }),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selected == null) {
      _selectValue.value = null;
      _txtController.clear();
    }
    if(widget.selected != null  && widget.selected!=''){
      _selectValue.value  = widget.selected;
      _txtController.text = widget.selected!;
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event){
          if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
            if (_textFocus.hasFocus) {
              _close();
            }
          }
        },
        child: sh.TextField(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          enabled: widget.enabled ?? true,
          readOnly: widget.readOnly??false,
          focusNode: _textFocus,
          controller: _txtController,
          onChanged: (val) => _onChangeText(val),
          trailing: SizedBox(),
          features: [
            sh.InputFeature.trailing(
              GestureDetector(
                child: Icon(sh.RadixIcons.chevronDown),
                onTap: () {
                  _isOpen ? _textFocus.unfocus() : _textFocus.requestFocus();

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ComboboxItem {
  String value;
  List<String> title;
  final dynamic valueOther;

  ComboboxItem({required this.value, required this.title, this.valueOther});
}
