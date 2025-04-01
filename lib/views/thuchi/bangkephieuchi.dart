import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../application/application.dart';
import '../../core/core.dart';
import '../../data/data.dart';
import '../../widgets/widgets.dart';


class BangKePhieuChiView extends ConsumerWidget {
  BangKePhieuChiView({super.key});
  late TrinaGridStateManager _stateManager;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(bangKePhieuChiProvider, (context, state) {
      if (state.isNotEmpty) {
        _stateManager.removeAllRows();
        _stateManager.appendRows(List.generate(state.length, (index) {
          final x = state[index];
          return TrinaRow(cells: {
            'null': TrinaCell(value: x.stt),
            PhieuChiString.ngay: TrinaCell(value: Helper.stringFormatDMY(x.ngay)),
            PhieuChiString.phieu: TrinaCell(value: x.phieu),
            PhieuChiString.maTC: TrinaCell(value: x.maTC),
            PhieuChiString.maKhach: TrinaCell(value: x.maKhach),
            PhieuChiString.tenKhach: TrinaCell(value: x.tenKhach),
            PhieuChiString.pttt: TrinaCell(value: x.pttt),
            PhieuChiString.noiDung: TrinaCell(value: x.noiDung),
            PhieuChiString.soTien: TrinaCell(value: x.soTien),
            PhieuChiString.tkNo: TrinaCell(value: x.tkNo),
            PhieuChiString.tkCo: TrinaCell(value: x.tkCo),
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
            if (event.cell.column.field == PhieuChiString.phieu) {
              // ref.read(phieuThuProvider.notifier).onMovePhieuThu(event.row.cells['null']!.value, ref: ref);

              showPhieuChi(context,stt: event.row.cells['null']!.value);
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
            DataGridColumn(title: 'Ngày', field: PhieuChiString.ngay, type: TrinaColumnType.text(), width: 80),
            DataGridColumn(
              title: 'Phiếu',
              field: PhieuChiString.phieu,
              type: TrinaColumnType.text(),
              width: 70,
              renderer: (re) => Text(re.cell.value, style: TextStyle(color: Colors.red,fontSize: 13.5)),
            ),
            DataGridColumn(
              title: 'Kiểu thu',
              field: PhieuChiString.maTC,
              type: TrinaColumnType.text(),
              width: 75,
              textAlign: TrinaColumnTextAlign.center,
            ),
            DataGridColumn(title: 'Mã KH', field: PhieuChiString.maKhach, type: TrinaColumnType.text(), width: 80),
            DataGridColumn(
              title: 'Tên khách',
              field: PhieuChiString.tenKhach,
              type: TrinaColumnType.text(),
              width: 300,
            ),
            DataGridColumn(
              title: 'PTTT',
              field: PhieuChiString.pttt,
              type: TrinaColumnType.text(),
              width: 75,
              textAlign: TrinaColumnTextAlign.center,
            ),
            DataGridColumn(title: 'Lý do thu', field: PhieuChiString.noiDung, type: TrinaColumnType.text(), width: 300),
            DataGridColumn(
              title: 'Số tiền',
              field: PhieuChiString.soTien,
              type: TrinaColumnType.number(),
              width: 100,
              textAlign: TrinaColumnTextAlign.end,
            ),
            DataGridColumn(
              title: 'TK nợ',
              field: PhieuChiString.tkNo,
              type: TrinaColumnType.text(),
              width: 75,
              textAlign: TrinaColumnTextAlign.center,
            ),
            DataGridColumn(
              title: 'TK có',
              field: PhieuChiString.tkCo,
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