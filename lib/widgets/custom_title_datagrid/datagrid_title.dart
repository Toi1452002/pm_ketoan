import 'package:app_ketoan/widgets/custom_title_datagrid/filter_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class DataGridTitle extends StatefulWidget {
  final bool isFilter;
  final String title;
  final void Function(Map<String, bool>)? onChanged;
  final Map<String, bool>? items;
  final bool isNumber;
  final bool enabelFilter;

  const DataGridTitle({
    super.key,
    this.isFilter = false,
    this.onChanged,
    this.items,
    this.isNumber = false,
    this.enabelFilter = false,
    required this.title,
  });

  @override
  State<DataGridTitle> createState() => _DataGridTitleState();
}

class _DataGridTitleState extends State<DataGridTitle> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  OverlayEntry _createOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                _close();
              },
            ),
            Positioned(
              width: 180,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(-80, size.height-5),
                child: Container(
                  height: 300,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [BoxShadow(color: Colors.gray, blurRadius: 5,offset: Offset(0, 4))],
                  ),
                  child: FilterWidget(
                    items: widget.items??{},
                    onChanged: widget.onChanged,
                    overlayEntry: _overlayEntry,
                    isNumber: widget.isNumber,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _open() {
    _overlayEntry = _createOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: widget.isFilter ? Colors.green.shade200 : Colors.blue.shade200,
        border: Border(right: BorderSide(width: .5)),
      ),
      child: Row(
        children: [
          Text(widget.title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          Spacer(),
          if (widget.enabelFilter)
            CompositedTransformTarget(
              link: _layerLink,
              child: IconButton.text(
                size: ButtonSize.small,
                onPressed: () {
                  _open();
                },
                icon: Icon(PhosphorIcons.funnel(), color: widget.isFilter ? Colors.green.shade500 : null),
              ),
            ),
        ],
      ),
    );
  }
}
