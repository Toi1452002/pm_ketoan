import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/widgets/datagrid.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../../application/application.dart';
import '../../../../data/data.dart';


class DVTView extends ConsumerStatefulWidget {
  const DVTView({super.key});

  @override
  ConsumerState createState() => _DVTViewState();
}

class _DVTViewState extends ConsumerState<DVTView> {
  late TrinaGridStateManager _stateManager;
  late DonViTinhNotifier _dvtNotifiler;

  @override
  void initState() {
    // TODO: implement initState
    _dvtNotifiler = ref.read(dvtProvider.notifier);
    super.initState();
  }

  void _onChange(TrinaGridOnChangedEvent e) async{
    final id = e.row.cells['delete']!.value;
    final field = e.column.field;
    if(id == ''){///Insert

      int id = await _dvtNotifiler.add(field: field, value: e.value).catchError((e,t)=>0);
      if(id != 0){
        _stateManager.rows[e.rowIdx].cells['delete']!.value = id;//set id when insert
        _stateManager.appendNewRows();
      }else{
        _stateManager.rows[e.rowIdx].cells[field]!.value = ''; // set null if error
      }
    }else{///Update
      int result = await _dvtNotifiler.update(value: e.value,id: id,field: field);
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
        int result = await _dvtNotifiler.delete(re.cell.value);
        if (result != 0) {
          _stateManager.removeCurrentRow();
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    ref.listen(dvtProvider, (context, state){
      _stateManager.removeAllRows();
      _stateManager.appendRows(state.map((e){
        return TrinaRow(cells: {
          'null': TrinaCell(value: ''),
          'delete': TrinaCell(value: e.id),
          DVTString.dvt : TrinaCell(value: e.dvt)
        });
      }).toList());
      _stateManager.appendNewRows();
    });
    return DataGrid(   onLoaded: (e) => _stateManager = e.stateManager,
        onChanged: (e)=>_onChange(e),rows: [], columns: [
          DataGridColumn(
            title: '',
            field: 'null',
            width: 20,
            cellPadding: EdgeInsets.zero,
            type: TrinaColumnType.text(),
            renderer: (re) => const DataGridContainer(),
          ),
          DataGridColumn(
            title: '',
            field: 'delete',
            width: 30,
            type: TrinaColumnType.text(),
            renderer: (re) => DataGridDelete(onTap: ()=>_onDelete(re),),
          ),
          DataGridColumn(
            title: 'Đơn vị tính',
            width: 225,
            enableEditingMode: true,
            field: DVTString.dvt,
            type: TrinaColumnType.text(),
          ),
        ]);
  }
}
