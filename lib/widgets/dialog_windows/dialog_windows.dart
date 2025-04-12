import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
export 'dialog_funtion.dart';
class DialogWindows extends StatefulWidget {
  Offset position;
  double width;
  double height;
  String title;
  Widget child;
  void Function() onClose;

  DialogWindows(
      {super.key,
      required this.position,
      required this.width,
      required this.height,
      required this.child,
      required this.onClose,
      required this.title});

  @override
  State<DialogWindows> createState() => _DialogWindowsState();
}

class _DialogWindowsState extends State<DialogWindows> {
  Offset _offset = const Offset(100, 100); // Vị trí ban đầu của dialog

  void _close() {
    widget.onClose();
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    _offset = widget.position;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: SizedBox(
            width: widget.width,
            child: Dialog(

              shadowColor: Colors.black,
              elevation: 15,
              insetPadding: EdgeInsets.zero,
              child: ClipRRect(

                borderRadius: BorderRadius.circular(3),
                child: Container(

                  decoration: BoxDecoration(
                      color: Colors.grey,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.6), blurRadius: 2,offset: const Offset(0,1),spreadRadius: 1)
                      ]),
                  // padding: const EdgeInsets.all(10),
                  width: widget.width,
                  height: widget.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onPanUpdate: (details) {
                          _onDragUpdate(details, widget.width, widget.height);
                        },
                        child: Container(
                          height: 25,
                          // width: double.infinity,
                          color: context.theme.colorScheme.muted,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Text(
                                  widget.title,
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                                const Spacer(),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    // hoverColor: Colors.red,
                                    onTap: () => _close(),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: widget.child)
                      // Expanded(child: widget.child)
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _onDragUpdate(
      DragUpdateDetails details, double dialogWidth, double dialogHeight) {
    // Lấy kích thước của màn hình desktop
    var screenSize = MediaQuery.of(context).size;

    // Kích thước của dialog
    // const dialogWidth = 300.0;
    // const dialogHeight = 300.0;

    // Tính toán vị trí mới
    double newX = _offset.dx + details.delta.dx;
    double newY = _offset.dy + details.delta.dy;

    // Giới hạn di chuyển ở các cạnh của màn hình
    if (newX < -200) newX = -200;
    if (newX + dialogWidth > screenSize.width) {
      newX = screenSize.width - dialogWidth;
    }

    if (newY < -10) newY = -10;
    if (newY + dialogHeight > screenSize.height + dialogHeight - 25) {
      newY = screenSize.height - 100;
    }

    setState(() {
      _offset = Offset(newX, newY);
    });
  }
}
