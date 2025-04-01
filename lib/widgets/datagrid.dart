import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

class DataGrid extends StatelessWidget {
  final List<TrinaColumn> columns;
  final List<TrinaRow<dynamic>> rows;
  final void Function(TrinaGridOnRowDoubleTapEvent)? onRowDoubleTap;
  final void Function(TrinaGridOnLoadedEvent)? onLoaded;
  final void Function(TrinaGridOnChangedEvent)? onChanged;
  final Color Function(TrinaRowColorContext)? rowColorCallback;
  final Widget Function(TrinaGridStateManager)? createFooter;
  final TrinaGridMode mode;

  const DataGrid({
    super.key,
    required this.rows,
    required this.columns,
    this.onChanged,
    this.onLoaded,
    this.onRowDoubleTap,
    this.rowColorCallback,
    this.createFooter,
    this.mode = TrinaGridMode.normal,
  });

  @override
  Widget build(BuildContext context) {
    return TrinaGrid(
      columns: columns,

      rows: rows,
      onLoaded: onLoaded,
      mode: mode,
      onChanged: onChanged,
      onRowDoubleTap: onRowDoubleTap,
      rowColorCallback: rowColorCallback,
      createFooter: createFooter,
      configuration: TrinaGridConfiguration(
        tabKeyAction: TrinaGridTabKeyAction.moveToNextOnEdge,
        enterKeyAction: TrinaGridEnterKeyAction.editingAndMoveRight,

        columnSize: const TrinaGridColumnSizeConfig(autoSizeMode: TrinaAutoSizeMode.none),
        shortcut: TrinaGridShortcut(
          actions: {
            ...TrinaGridShortcut.defaultActions,
            LogicalKeySet(LogicalKeyboardKey.escape): CustomEscKeyAction(),
            // LogicalKeySet(LogicalKeyboardKey.keyN,LogicalKeyboardKey.control): CustomEnterKeyAction(),
          },
        ),
        localeText: const TrinaGridLocaleText(),
        style: TrinaGridStyleConfig(
          borderColor: Colors.grey,
          gridBorderRadius: BorderRadius.circular(2),
          gridBackgroundColor: Colors.grey.shade100,

          enableRowHoverColor: true,
          rowHoveredColor: Colors.grey.shade100,
          columnHeight: 25,
          rowHeight: 25,
          columnTextStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          rowColor: Colors.white,

          cellTextStyle: const TextStyle(fontSize: 13, color: Colors.black),
          defaultCellPadding: const EdgeInsets.only(left: 2, right: 4),
        ),
      ),
    );
  }
}

class CustomEscKeyAction extends TrinaGridShortcutAction {
  @override
  void execute({required TrinaKeyManagerEvent keyEvent, required TrinaGridStateManager stateManager}) {
    stateManager.clearCurrentSelecting();
    stateManager.clearCurrentCell();
    stateManager.setKeepFocus(false);
  }
}

TrinaColumn DataGridColumn({
  required String title,
  required String field,
  required TrinaColumnType type,
  double? width,
  TrinaColumnTextAlign? textAlign,
  Widget Function(TrinaColumnRendererContext)? renderer,
  EdgeInsets? cellPadding,
  bool? enableEditingMode = false,
  bool enableDropToResize = false,
  bool enableContextMenu = false,
  bool enableSorting = false,
  Widget Function(TrinaColumnFooterRendererContext)? footerRenderer,
  Widget Function(Widget, TrinaCell, TextEditingController, FocusNode, dynamic Function(dynamic)?)? editCellRenderer,
}) {
  return TrinaColumn(
    title: title,
    field: field,

    backgroundColor: Colors.blue.shade100,
    type: type,
    renderer: renderer,
    enableEditingMode: enableEditingMode,
    footerRenderer: footerRenderer,
    textAlign: textAlign ?? TrinaColumnTextAlign.start,
    width: width ?? TrinaGridSettings.columnWidth,
    enableColumnDrag: false,
    // suppressedAutoSize: true,
    editCellRenderer: editCellRenderer,
    enableContextMenu: enableContextMenu,
    minWidth: 10,
    enableAutoEditing: true,
    enableSorting: enableSorting,
    enableFilterMenuItem: false,
    cellPadding: cellPadding,
    readOnly: false,
    enableDropToResize: enableDropToResize,
  );
}

class DataGridContainer extends StatelessWidget {
  final String? text;

  const DataGridContainer({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade200.withValues(alpha: .5),

        border: const Border(right: BorderSide(color: Colors.grey)),
      ),
      child: Text(text ?? '', style: const TextStyle(fontSize: 13)),
    );
  }
}

class DataGridDelete extends StatelessWidget {
  const DataGridDelete({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ColoredBox(
        color: Colors.transparent,
        child: Icon(
          PhosphorIcons.trash(),
          size: 20,
          color: onTap == null ? Colors.grey : Colors.red.withValues(alpha: .8),
        ),
      ),
    );
  }
}
