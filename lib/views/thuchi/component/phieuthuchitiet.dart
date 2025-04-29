import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/widgets/custom_title_datagrid/datagrid_title.dart';
import 'package:app_ketoan/widgets/datagrid.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../application/application.dart';
import '../../../data/data.dart';

class PhieuThuChiTietView extends ConsumerStatefulWidget {
  final int maID;
  final bool khoa;

  const PhieuThuChiTietView({super.key, required this.maID, this.khoa = true});

  @override
  ConsumerState createState() => _PhieuThuChiTietState();
}

class _PhieuThuChiTietState extends ConsumerState<PhieuThuChiTietView> {
  late TrinaGridStateManager _stateManager;
  late PhieuThuCTNotifier _phieuThuCTNotifier;
  TrinaGridMode mode = TrinaGridMode.readOnly; // Mặc định là chế độ nhập liệu

  @override
  void initState() {
    // TODO: implement initState
    _phieuThuCTNotifier = ref.read(phieuThuCTProvider.notifier);

    super.initState();
  }

  void _onChange(TrinaGridOnChangedEvent e) async {
    final id = e.row.cells['delete']!.value;
    final field = e.column.field;
    if (id == '') {
      ///Insert

      int id = await _phieuThuCTNotifier.addPhieuThuCT(field, e.value, widget.maID).catchError((e, t) => 0);
      if (id != 0) {
        _stateManager.rows[e.rowIdx].cells['delete']!.value = id; //set id when insert
        _stateManager.appendNewRows();
      } else {
        _stateManager.rows[e.rowIdx].cells[field]!.value = ''; // set null if error
      }
    } else {
      ///Update
      int result = await _phieuThuCTNotifier.updatePhieuThuCT(field, e.value, id);
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
        int result = await _phieuThuCTNotifier.deletePhieuThuCT(re.cell.value);
        if (result != 0) {
          _stateManager.removeCurrentRow();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wPhieuThuCT = ref.watch(phieuThuCTProvider);
    ref.listen(phieuThuCTProvider, (context, state) {
      // if(state.isNotEmpty){
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state
            .map(
              (e) => TrinaRow(
                cells: {
                  'null': TrinaCell(value: ''),
                  'delete': TrinaCell(value: e.id),
                  PhieuThuCTString.dienGiai: TrinaCell(value: e.dienGiai),
                  PhieuThuCTString.soTien: TrinaCell(value: e.soTien),
                },
              ),
            )
            .toList(),
      );
      _stateManager.appendNewRows();
      // }
    });

    ref.listen(phieuThuProvider, (context, state) {
      if (state != null) {
        mode = state.khoa ? TrinaGridMode.readOnly : TrinaGridMode.normal;
      }
    });
    return DataGrid(
      onLoaded: (e) {
        _stateManager = e.stateManager;
        _stateManager.removeAllRows();
        _stateManager.appendRows(
          wPhieuThuCT
              .map(
                (e) => TrinaRow(
                  cells: {
                    'null': TrinaCell(value: ''),
                    'delete': TrinaCell(value: e.id),
                    PhieuThuCTString.dienGiai: TrinaCell(value: e.dienGiai),
                    PhieuThuCTString.soTien: TrinaCell(value: e.soTien),
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
