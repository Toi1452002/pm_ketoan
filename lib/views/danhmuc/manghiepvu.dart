import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/widgets/datagrid.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/application.dart';
import '../../data/data.dart';


class MaNghiepVuView extends ConsumerStatefulWidget {
  const MaNghiepVuView({super.key});

  @override
  ConsumerState createState() => _MaNghiepVuViewState();
}

class _MaNghiepVuViewState extends ConsumerState<MaNghiepVuView> {
  late TrinaGridStateManager _stateManager;
  late MaNghiepVuNotifier _maNghiepVuNotifier;

  @override
  void initState() {
    // TODO: implement initState
    _maNghiepVuNotifier = ref.read(maNghiepVuProvider.notifier);
    super.initState();
  }

  void _onChange(TrinaGridOnChangedEvent e) async{
    final id = e.row.cells['delete']!.value;
    final field = e.column.field;
    if(id == ''){///Insert

      int id = await _maNghiepVuNotifier.add(field, e.value).catchError((e,t)=>0);
      if(id != 0){
        _stateManager.rows[e.rowIdx].cells['delete']!.value = id;//set id when insert
        _stateManager.appendNewRows();
      }else{
        _stateManager.rows[e.rowIdx].cells[field]!.value = ''; // set null if error
      }
    }else{///Update
      int result = await _maNghiepVuNotifier.update(field,e.value,id);
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
        int result = await _maNghiepVuNotifier.delete(re.cell.value);
        if (result != 0) {
          _stateManager.removeCurrentRow();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(maNghiepVuProvider, (context, state){
      _stateManager.removeAllRows();
      _stateManager.appendRows(state.map((e)=>TrinaRow(cells: {
        'null': TrinaCell(value: ''),
        'delete': TrinaCell(value: e.id),
        MaNghiepVuString.maNV : TrinaCell(value: e.maNghiepVu),
        MaNghiepVuString.moTa: TrinaCell(value: e.moTa)
      })).toList());
      _stateManager.appendNewRows();

    });
    return DataGrid(onLoaded: (e)=>_stateManager = e.stateManager,
        onChanged: (e)=>_onChange(e),rows: [], columns: [
      DataGridColumn(
        title: '',
        field: 'null',
        type: TrinaColumnType.text(),
        width: 20,
        renderer: (re) => const DataGridContainer(),
        cellPadding: EdgeInsets.zero,
      ),
      DataGridColumn(
        title: '',
        field: 'delete',
        type: TrinaColumnType.text(),
        width: 25,
        renderer: (re) => DataGridDelete(
          onTap: ()=>_onDelete(re),
        ),
      ),
      DataGridColumn(
        title: 'Mã',
        field: MaNghiepVuString.maNV,
        type: TrinaColumnType.text(),
        enableEditingMode: true,
        width: 100
      ),
      DataGridColumn(
        title: 'Mô tả',
        field: MaNghiepVuString.moTa,
        width: 200,
        type: TrinaColumnType.text(),
        enableEditingMode: true,
      ),
    ]);
  }
}
