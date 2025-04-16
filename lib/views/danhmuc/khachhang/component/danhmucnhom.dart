import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/widgets/widgets.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../../application/application.dart';
import '../../../../data/data.dart';


class DanhMucNhomView extends ConsumerStatefulWidget {
  const DanhMucNhomView({super.key});

  @override
  ConsumerState createState() => _DanhMucNhomState();
}

class _DanhMucNhomState extends ConsumerState<DanhMucNhomView> {
  late TrinaGridStateManager _stateManager;
  late NhomKhachNotifier _nhomKhachNotifier;

  @override
  void initState() {
    _nhomKhachNotifier = ref.read(nhomKhachProvider.notifier);
    super.initState();
  }
  void _onChange(TrinaGridOnChangedEvent e) async {
    final id = e.row.cells['delete']!.value;
    final field = e.column.field;
    if (id == '') {
      ///Insert
      int id = await _nhomKhachNotifier.addNhomKhach(field: field, value: e.value).catchError((e, t) => 0);
      if (id != 0) {
        _stateManager.rows[e.rowIdx].cells['delete']!.value = id; //set id when insert
        _stateManager.appendNewRows();
      } else {
        _stateManager.rows[e.rowIdx].cells[field]!.value = ''; // set null if error
      }
    } else {
      ///Update
      int result = await _nhomKhachNotifier.updateNhomKhach(value: e.value, id: id, field: field);
      if (result == 0) {
        _stateManager.rows[e.rowIdx].cells[field]!.value = e.oldValue;
      }
    }
  }

  void _onDelete(TrinaColumnRendererContext re) async {
    _stateManager.setCurrentCell(re.cell, re.rowIdx);
    if (re.cell.value != '') {
      final btn = await CustomAlert().warning(AppString.delete, title: 'DANH MỤC NHÓM');
      if (btn == AlertButton.okButton) {
        int result = await _nhomKhachNotifier.deleteNhomKhach(re.cell.value);
        if (result != 0) {
          _stateManager.removeCurrentRow();
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    ref.listen(nhomKhachProvider, (context, state) {
      if (state.isNotEmpty) {
        _stateManager.removeAllRows();
        _stateManager.appendRows(state.map((e) {
          return TrinaRow(cells: {
            'null': TrinaCell(value: ''),
            'delete': TrinaCell(value: e.id),
            NhomKhachString.maNhom: TrinaCell(value: e.maNhom),
            NhomKhachString.tenNhom: TrinaCell(value: e.tenNhom),
          });
        }).toList());
      }
      _stateManager.appendNewRows();
    });
    return Scaffold(child: DataGrid(  onLoaded: (e) => _stateManager = e.stateManager,
        onChanged: (e) => _onChange(e),rows: [], columns: [
      DataGridColumn(
        title: '',
        field: 'null',
        type: TrinaColumnType.text(),
        cellPadding: EdgeInsets.zero,
        width: 20,
        titleRenderer: (re)=>DataGridTitle(title: ''),
        renderer: (re) => const DataGridContainer(),
      ),
      DataGridColumn(
          title: '',
          field: 'delete',
          type: TrinaColumnType.text(),
          width: 30,
          titleRenderer: (re)=>DataGridTitle(title: ''),
          renderer: (re) {
            return DataGridDelete(
              onTap: () => _onDelete(re),
            );
          }),
      DataGridColumn(
        enableEditingMode: true,
        title: 'Mã nhóm',
        field: NhomKhachString.maNhom,
        width: 100,
        titleRenderer: (re)=>DataGridTitle(title: re.column.title),
        type: TrinaColumnType.text(),
      ),
      DataGridColumn(
        enableEditingMode: true,
        title: 'Mô tả nhóm khách',
        field: NhomKhachString.tenNhom,
        titleRenderer: (re)=>DataGridTitle(title: re.column.title),
        width: 245,
        type: TrinaColumnType.text(),
      ),
    ]));
  }
}
