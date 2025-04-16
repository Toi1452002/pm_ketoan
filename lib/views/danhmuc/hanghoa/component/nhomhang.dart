import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/widgets/datagrid.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../../application/application.dart';
import '../../../../data/data.dart';
import '../../../../widgets/widgets.dart';


class NhomHangView extends ConsumerStatefulWidget {
  const NhomHangView({super.key});

  @override
  ConsumerState createState() => _NhomHangViewState();
}

class _NhomHangViewState extends ConsumerState<NhomHangView> {
  late TrinaGridStateManager _stateManager;
  late NhomHangNotifier _nhomHangNotifier;

  @override
  void initState() {
    // TODO: implement initState
    _nhomHangNotifier = ref.read(nhomHangProvider.notifier);
    super.initState();
  }
  void _onChange(TrinaGridOnChangedEvent e) async{
    final id = e.row.cells['delete']!.value;
    final field = e.column.field;
    if(id == ''){///Insert
      int id = await _nhomHangNotifier.add(field: field, value: e.value).catchError((e,t)=>0);
      if(id != 0){
        _stateManager.rows[e.rowIdx].cells['delete']!.value = id;//set id when insert
        _stateManager.appendNewRows();
      }else{
        _stateManager.rows[e.rowIdx].cells[field]!.value = ''; // set null if error
      }
    }else{///Update
      int result = await _nhomHangNotifier.update(value: e.value,id: id,field: field);
      if (result == 0) {
        _stateManager.rows[e.rowIdx].cells[field]!.value = e.oldValue;
      }
    }
  }

  void _onDelete(TrinaColumnRendererContext re) async{
    _stateManager.setCurrentCell(re.cell, re.rowIdx);
    if (re.cell.value != '') {
      final btn = await CustomAlert().warning(AppString.delete, title: 'DANH MỤC NHÓM');
      if (btn == AlertButton.okButton) {
        int result = await _nhomHangNotifier.delete(re.cell.value);
        if (result != 0) {
          _stateManager.removeCurrentRow();
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    ref.listen(nhomHangProvider, (context, state){
      _stateManager.removeAllRows();
      _stateManager.appendRows(state.map((e){
        return TrinaRow(cells: {
          'null': TrinaCell(value: ''),
          'delete': TrinaCell(value: e.id),
          NhomHangString.nhomHang : TrinaCell(value: e.nhomHang)
        });
      }).toList());
      _stateManager.appendNewRows();
    });
    return DataGrid( onLoaded: (e)=>_stateManager = e.stateManager,
        onChanged: (e)=>_onChange(e),rows: [], columns: [
      DataGridColumn(
        title: '',
        field: 'null',
        width: 20,
        cellPadding: EdgeInsets.zero,
        type: TrinaColumnType.text(),
        renderer: (re) => DataGridContainer(),
        titleRenderer: (re)=>DataGridTitle(title: ''),
      ),
          DataGridColumn(
        title: '',
        field: 'delete',
        width: 25,
        type: TrinaColumnType.text(),
        renderer: (re) => DataGridDelete(onTap: ()=>_onDelete(re),),
            titleRenderer: (re)=>DataGridTitle(title: ''),
      ),
          DataGridColumn(
        title: 'Nhóm hàng',
        width: 220,
        enableEditingMode: true,
        field: NhomHangString.nhomHang,
        type: TrinaColumnType.text(),
            titleRenderer: (re)=>DataGridTitle(title: re.column.title),
      ),
    ]);
  }
}
