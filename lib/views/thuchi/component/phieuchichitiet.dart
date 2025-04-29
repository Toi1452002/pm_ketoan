import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../application/application.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../widgets/widgets.dart';

class PhieuChiCTView extends ConsumerStatefulWidget {
  final int maID;
  final bool khoa;

  const PhieuChiCTView({super.key, required this.maID, this.khoa = true});

  @override
  ConsumerState createState() => _PhieuChiChiTietState();
}

class _PhieuChiChiTietState extends ConsumerState<PhieuChiCTView> {
  late TrinaGridStateManager _stateManager;
  late PhieuChiCTNotifier _phieuChiCTNotifier;
  TrinaGridMode mode = TrinaGridMode.readOnly; // Mặc định là chế độ nhập liệu

  void _onChange(TrinaGridOnChangedEvent e) async {
    final id = e.row.cells['delete']!.value;
    final field = e.column.field;
    if (id == '') {
      ///Insert

      int id = await _phieuChiCTNotifier.addPhieuChiCT(field, e.value, widget.maID).catchError((e, t) => 0);
      if (id != 0) {
        _stateManager.rows[e.rowIdx].cells['delete']!.value = id; //set id when insert
        _stateManager.appendNewRows();
      } else {
        _stateManager.rows[e.rowIdx].cells[field]!.value = ''; // set null if error
      }
    } else {
      ///Update
      int result = await _phieuChiCTNotifier.updatePhieuChiCT(field, e.value, id);
      if (result == 0) {
        _stateManager.rows[e.rowIdx].cells[field]!.value = e.oldValue;
      }
    }
  }

  void _onDelete(TrinaColumnRendererContext re) async {
    _stateManager.setCurrentCell(re.cell, re.rowIdx);
    if (re.cell.value != '') {
      final btn = await CustomAlert().warning(AppString.delete, title: 'PHIẾU THU');
      if (btn == AlertButton.okButton) {
        int result = await _phieuChiCTNotifier.deletePhieuChiCT(re.cell.value);
        if (result != 0) {
          _stateManager.removeCurrentRow();
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _phieuChiCTNotifier = ref.read(phieuChiCTProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wPhieuChiCT = ref.watch(phieuChiCTProvider);
    ref.listen(phieuChiCTProvider, (context, state) {
      // if(state.isNotEmpty){
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state
            .map(
              (e) => TrinaRow(
                cells: {
                  'null': TrinaCell(value: ''),
                  'delete': TrinaCell(value: e.id),
                  PhieuChiCTString.dienGiai: TrinaCell(value: e.dienGiai),
                  PhieuChiCTString.soTien: TrinaCell(value: e.soTien),
                },
              ),
            )
            .toList(),
      );
      _stateManager.appendNewRows();
      // }
    });

    ref.listen(phieuChiProvider, (context, state) {
      if (state != null) {
        mode = state.khoa ? TrinaGridMode.readOnly : TrinaGridMode.normal;
      }
    });
    return DataGrid(
      onLoaded: (e) {
        _stateManager = e.stateManager;
        _stateManager.columnFooterHeight = 25;
        _stateManager.removeAllRows();
        _stateManager.appendRows(
          wPhieuChiCT
              .map(
                (e) => TrinaRow(
                  cells: {
                    'null': TrinaCell(value: ''),
                    'delete': TrinaCell(value: e.id),
                    PhieuChiCTString.dienGiai: TrinaCell(value: e.dienGiai),
                    PhieuChiCTString.soTien: TrinaCell(value: e.soTien),
                  },
                ),
              )
              .toList(),
        );
        _stateManager.appendNewRows();
        e.stateManager.setGridMode(widget.khoa! ? TrinaGridMode.readOnly : TrinaGridMode.normal);
      },
      onChanged: (e) => _onChange(e),
      rows: [],
      mode: mode,
      columns: [
        DataGridColumn(
          title: '',
          width: 20,
          field: 'null',
          type: TrinaColumnType.text(),
          cellPadding: EdgeInsets.zero,
          titleRenderer: (re) => DataGridTitle(title: ''),
          renderer: (re) => const DataGridContainer(),
        ),
        DataGridColumn(
          title: '',
          width: 30,
          field: 'delete',
          type: TrinaColumnType.text(),
          titleRenderer: (re) => DataGridTitle(title: ''),
          renderer:
              (re) => DataGridDelete(
                enabled: _stateManager.mode.isEditableMode,
                onTap: () {
                  _onDelete(re);
                },
              ),
        ),
        DataGridColumn(
          title: 'Diễn giải',
          enableEditingMode: true,
          field: 'DienGiai',
          type: TrinaColumnType.text(),
          titleRenderer: (re) => DataGridTitle(title: re.column.title),
        ),
        DataGridColumn(
          title: 'Số tiền',
          textAlign: TrinaColumnTextAlign.end,
          enableEditingMode: true,
          field: 'SoTien',
          titleRenderer: (re) => DataGridTitle(title: re.column.title),
          footerRenderer:
              (e) => TrinaAggregateColumnFooter(
                rendererContext: e,
                type: TrinaAggregateColumnType.sum,
                alignment: Alignment.centerRight,
              ),
          type: TrinaColumnType.number(),
        ),
      ],
    );
  }
}
