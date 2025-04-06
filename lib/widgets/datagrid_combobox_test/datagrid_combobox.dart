import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'datagrid_combobox_textfield.dart';

class DataGridComboboxItem {
  final String value;
  final List<String> title;

  const DataGridComboboxItem({
    required this.value,
    required this.title,
  });
}

class DataGridCombobox extends StatefulWidget {
  final List<DataGridComboboxItem> items;

  // final bool? readOnly;
  final bool? enabled;
  final String? selected;
  final ValueChanged<DataGridComboboxItem?>? onChanged;
  final List<double>? columnWidth;
  final double? menuWidth;
  final bool isChangeEmpty;
  final ValueChanged<bool> isOpen;

  const DataGridCombobox({
    super.key,
    required this.items,
    this.selected,
    this.isChangeEmpty = true,
    required this.onChanged,
    this.menuWidth,
    this.columnWidth,
    this.enabled,required this.isOpen
  });

  @override
  State<DataGridCombobox> createState() => _DataGridComboboxState();
}

class _DataGridComboboxState extends State<DataGridCombobox> {
  final LayerLink _layerLink = LayerLink();
  final _txtController = TextEditingController();
  late OverlayEntry? _overlayEntry;
  final ValueNotifier<String?> _selectValue = ValueNotifier<String?>(null);
  bool _isOpen = false;
  bool _onTapList = false; // Có thao tác vào list hay không
  ScrollController _scrollController = ScrollController();
  int? _indexSearch;
  final _textFocus = FocusNode();
  double? _lastScrollOffset; // Lưu trữ vị trí cuộn trước đó

  @override
  void initState() {
    // TODO: implement initState
    if (widget.selected != null && widget.selected != '') {
      _txtController.text = widget.selected!;
      _selectValue.value = widget.selected!;
    }
    _textFocus.addListener(() {
      if (!_textFocus.hasFocus && !_onTapList) {
        if (_indexSearch != null) {
          // Có tìm kiếm
          if (_indexSearch != -1) {
            // Có giá trị
            final item = widget.items[_indexSearch!];
            _txtController.text = item.title.first;
            widget.onChanged!(item);
            _saveOffset();
          }
        } else if (_indexSearch == null) {
          // Không có giá trị tìm kiếm
          if (_selectValue.value == null) {
            if (widget.selected != null && widget.selected!.isNotEmpty && _txtController.text.isNotEmpty) {
              _txtController.text = widget.items.firstWhere((e) => e.value == widget.selected).title.first;
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
                    orElse: () => const DataGridComboboxItem(value: '', title: ['']))
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

      _overlayEntry = _createMenu();
      Overlay.of(context).insert(_overlayEntry!);
      _textFocus.requestFocus();
      if (_selectValue.value != null && widget.items.length > 8) {
        int index = _searchItem(widget.selected!);
        _scrollController = ScrollController(initialScrollOffset: index * 25);
      }

      widget.isOpen(true);
      setState(() {
        _isOpen = true;
      });
    }
  }

  int _searchItem(String value) {
    if (widget.items.isNotEmpty) {
      return widget.items.indexWhere((e) => e.value == value);
    } else {
      return -1;
    }
  }

  void _onChangeText(String val) {
    // if(val.isEmpty) _selectValue.value = null;

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
        widget.onChanged!(null); //Thay doi gia tri
      }
      _indexSearch = null;
      _selectValue.value = null;
    }
  }

  void _close() {
    if (_isOpen) {
      _overlayEntry?.remove();
      _textFocus.unfocus();
      widget.isOpen(false);
      setState(() {
        _isOpen = false;
      });
    }
  }

  void _onTapItem(DataGridComboboxItem item) {
    _close();
    _txtController.text = item.title.first;
    _selectValue.value = item.value;
    // _indexSearchNotifier.value = _searchItem(item.value);
    widget.onChanged!(item);
    _saveOffset();
  }

  void _saveOffset({double? value}) {
    _lastScrollOffset = value ?? _scrollController.offset;
  }

  OverlayEntry _createMenu() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return OverlayEntry(builder: (context) {
      return Positioned(
          width: widget.menuWidth ?? size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 0),
            child: Material(
              color: Colors.white,
              elevation: 5,
              child: Container(
                height: widget.items.length < 8 ? widget.items.length * 25.75 + 25.75 : 206,
                decoration: BoxDecoration(
                  border: Border.all(width: .4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width-1,
                      child: KeyboardListener(
                        focusNode: FocusNode(),
                        onKeyEvent: (event){
                          if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
                            if (_textFocus.hasFocus) {
                              _close();
                            }
                          }
                        },
                        child: DataGridComboboxTextfield(
                          controller: _txtController,
                          onChanged: (val) => _onChangeText(val),
                          autofocus: true,
                          focusNode: _textFocus,
                        ),
                      ),
                    ),
                    const Divider(
                      height: .4,
                      color: Colors.black,
                      thickness: .5,
                    ),
                    Expanded(
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
                        child: ValueListenableBuilder(
                          builder: (BuildContext context, selectValue, Widget? child) {
                            return SingleChildScrollView(
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
                                                width: widget.columnWidth?[titleIndex],
                                                margin: EdgeInsets.zero,
                                                child: Text(
                                                  rows.title[titleIndex],
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: rows.value == selectValue ? Colors.white : null),
                                                ),
                                              ),
                                              if (titleIndex < rows.title.length - 1)
                                                const VerticalDivider(
                                                  color: Colors.black,
                                                  width: .4,
                                                )
                                            ],
                                          );
                                        }),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                          valueListenable: _selectValue,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selected == null) {
      _selectValue.value = null;
      _txtController.clear();
    } else if (widget.selected != null && widget.selected != '' && !_isOpen) {
      _selectValue.value = widget.selected;
      _txtController.text = widget.selected!;
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: DataGridComboboxTextfield(
        noBoder: true,
        onTap: () {
          _isOpen ? _close() : _open();
        },
        autofocus: true,
        readOnly: true,
        controller: _txtController,
        suffix: const Icon(Icons.arrow_drop_down),
      ),
    );
  }
}
