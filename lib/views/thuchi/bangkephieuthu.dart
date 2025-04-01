import 'package:app_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../application/application.dart';
import '../../core/core.dart';
import '../../data/data.dart';

class BangKePhieuThuView extends ConsumerWidget {
  BangKePhieuThuView({super.key});

  late TrinaGridStateManager _stateManager;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(bangKePhieuThuProvider, (context, state) {
      if (state.isNotEmpty) {
        _stateManager.removeAllRows();
        _stateManager.appendRows(List.generate(state.length, (index) {
          final x = state[index];
          return TrinaRow(cells: {
            'null': TrinaCell(value: x.stt),
            PhieuThuString.ngay: TrinaCell(value: Helper.stringFormatDMY(x.ngay)),
            PhieuThuString.phieu: TrinaCell(value: x.phieu),
            PhieuThuString.maTC: TrinaCell(value: x.maTC),
            PhieuThuString.maKhach: TrinaCell(value: x.maKhach),
            PhieuThuString.tenKhach: TrinaCell(value: x.tenKhach),
            PhieuThuString.pttt: TrinaCell(value: x.pttt),
            PhieuThuString.noiDung: TrinaCell(value: x.noiDung),
            PhieuThuString.soTien: TrinaCell(value: x.soTien),
            PhieuThuString.tkNo: TrinaCell(value: x.tkNo),
            PhieuThuString.tkCo: TrinaCell(value: x.tkCo),
          });
        }));
      }
    });

    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5),
          leading: [iconPrinter(onPressed: () {}), iconExcel(onPressed: () {})],
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(5),
        child: DataGrid(
          onLoaded: (e) => _stateManager = e.stateManager,
          onRowDoubleTap: (event) async {
            if (event.cell.column.field == PhieuThuString.phieu) {
              // ref.read(phieuThuProvider.notifier).onMovePhieuThu(event.row.cells['null']!.value, ref: ref);

               showPhieuThu(context,stt: event.row.cells['null']!.value);
              // print(event.row.cells['null']!.value);
            }
          },
          rows: [],
          columns: [
            DataGridColumn(
              title: '',
              field: 'null',
              width: 20,
              cellPadding: EdgeInsets.zero,
              renderer: (re) => const DataGridContainer(),
              type: TrinaColumnType.text(),
            ),
            DataGridColumn(title: 'Ngày', field: PhieuThuString.ngay, type: TrinaColumnType.text(), width: 80),
            DataGridColumn(
              title: 'Phiếu',
              field: PhieuThuString.phieu,
              type: TrinaColumnType.text(),
              width: 70,
              renderer: (re) => Text(re.cell.value, style: TextStyle(color: Colors.red,fontSize: 13.5)),
            ),
            DataGridColumn(
              title: 'Kiểu thu',
              field: PhieuThuString.maTC,
              type: TrinaColumnType.text(),
              width: 75,
              textAlign: TrinaColumnTextAlign.center,
            ),
            DataGridColumn(title: 'Mã KH', field: PhieuThuString.maKhach, type: TrinaColumnType.text(), width: 80),
            DataGridColumn(
              title: 'Tên khách',
              field: PhieuThuString.tenKhach,
              type: TrinaColumnType.text(),
              width: 300,
            ),
            DataGridColumn(
              title: 'PTTT',
              field: PhieuThuString.pttt,
              type: TrinaColumnType.text(),
              width: 75,
              textAlign: TrinaColumnTextAlign.center,
            ),
            DataGridColumn(title: 'Lý do thu', field: PhieuThuString.noiDung, type: TrinaColumnType.text(), width: 300),
            DataGridColumn(
              title: 'Số tiền',
              field: PhieuThuString.soTien,
              type: TrinaColumnType.number(),
              width: 100,
              textAlign: TrinaColumnTextAlign.end,
            ),
            DataGridColumn(
              title: 'TK nợ',
              field: PhieuThuString.tkNo,
              type: TrinaColumnType.text(),
              width: 75,
              textAlign: TrinaColumnTextAlign.center,
            ),
            DataGridColumn(
              title: 'TK có',
              field: PhieuThuString.tkCo,
              type: TrinaColumnType.text(),
              width: 75,
              textAlign: TrinaColumnTextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
