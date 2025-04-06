import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../../application/application.dart';
import '../../../../data/data.dart';

class DanhsachHanghoa extends ConsumerWidget {
  final String? maHH;
  final void Function(HangHoaModel? value)? onChanged;

  DanhsachHanghoa({super.key, required this.maHH, this.onChanged});

  late TrinaGridStateManager _stateManager;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final lstHang = ref.watch(hangHoaGetListProvider);

    ref.listen(hangHoaProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state.map((e) {
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: e.id),
              HangHoaString.maHH: TrinaCell(value: e.maHH),
              HangHoaString.tenHH: TrinaCell(value: e.tenHH),
              DVTString.dvt: TrinaCell(value: e.donViTinh),
              HangHoaString.giaBan: TrinaCell(value: e.giaBan),
            },
          );
        }).toList(),
      );
      _stateManager.setKeepFocus(true);
      final index = state.indexWhere((e) => e.maHH == maHH);
      if (index != -1) {
        _stateManager.moveScrollByRow(TrinaMoveDirection.down, index);
        _stateManager.setCurrentCell(_stateManager.rows[index].cells[HangHoaString.maHH], index);
      }
    });
    return DataGrid(
      onLoaded: (e) {
        _stateManager = e.stateManager;
        _stateManager.setShowColumnFilter(true);
      },
      rows: [],
      columns: [
        DataGridColumn(
          title: '',
          field: 'null',
          enableFilterMenuItem: false,
          type: TrinaColumnType.text(),
          width: 20,
          renderer: (re) => DataGridContainer(),
          cellPadding: EdgeInsets.zero,
        ),
        DataGridColumn(title: 'Mã',renderer: (re){
          return Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                    final data = ref.read(hangHoaProvider).firstWhere((e) => e.maHH == re.cell.value);
                    onChanged?.call(data);
                    Navigator.pop(context);
                  },
                  child: Text(re.cell.value,style: TextStyle(color: Colors.red),),
                ),
              ),
              InkWell(child: Icon(Icons.info_outline_rounded,size: 15,color: Colors.grey,),onTap: (){
                final data = ref.read(hangHoaProvider).firstWhere((e) => e.maHH == re.cell.value);
                showThongTinHangHoa(context,hangHoa: data);
              },)
            ],
          );
        }, field: HangHoaString.maHH, type: TrinaColumnTypeText(), width: 150),
        DataGridColumn(
          title: 'Tên vật tư-hàng hóa',
          field: HangHoaString.tenHH,

          type: TrinaColumnTypeText(),
          width: 300,
        ),
        DataGridColumn(title: 'Đơn vị tính', field: DVTString.dvt, type: TrinaColumnTypeText(), width: 100),
        DataGridColumn(
          title: 'Giá bán',
          field: HangHoaString.giaBan,
          type: TrinaColumnType.number(),
          textAlign: TrinaColumnTextAlign.end,
          enableSorting: true,
          width: 150,
        ),
      ],
    );
  }
}
