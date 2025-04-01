import 'package:app_ketoan/application/providers/nhanvien_provider.dart';
import 'package:app_ketoan/views/danhmuc/nhanvien/component/thongtinnhanvien.dart';
import 'package:app_ketoan/widgets/datagrid.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../widgets/widgets.dart';

class NhanVienView extends ConsumerWidget {
  NhanVienView({super.key});

  late TrinaGridStateManager _stateManager;
  List<NhanVienModel> lstNhanVien = [];
  
  void _showThongTinNhanVien(BuildContext context,{NhanVienModel? nhanVien}) {
    showCustomDialog(context,
        title: 'THÔNG TIN NHÂN VIÊN',
        width: 700,
        height: 600,
        child: ThongTinNhanVienView(nhanVien: nhanVien,),
        onClose: () {});
  }
  void _onDelete(TrinaColumnRendererContext re, WidgetRef ref) async {
    _stateManager.setCurrentCell(re.cell, re.rowIdx);
    if (re.cell.value != '') {
      final btn = await CustomAlert().warning(AppString.delete, title: 'KHÁCH HÀNG');
      if (btn == AlertButton.okButton) {
        int result = await ref.read(nhanVienProvider.notifier).deleteNhanVien(re.cell.value);
        if (result != 0) {
          _stateManager.removeCurrentRow();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(nhanVienProvider, (context, state) {
      if (state.isNotEmpty) {
        _stateManager.removeAllRows();
        lstNhanVien = state;
        _stateManager.appendRows(
          List.generate(state.length, (index) {
            final x = state[index];
            return TrinaRow(
              cells: {
                'null': TrinaCell(value: (index + 1).toString()),
                'delete': TrinaCell(value: x.maNV),
                NhanVienString.maNV: TrinaCell(value: x.maNV),
                NhanVienString.hoTen: TrinaCell(value: x.hoTen),
                NhanVienString.phai: TrinaCell(value: x.phai ? 'Nữ' : 'Nam'),
                NhanVienString.ngaySinh: TrinaCell(value: Helper.stringFormatDMY(x.ngaySinh!)),
                NhanVienString.diaChi: TrinaCell(value: x.diaChi),
                NhanVienString.trinhDo: TrinaCell(value: x.trinhDo),
                NhanVienString.chuyenMon: TrinaCell(value: x.chuyenMon),
              },
            );
          }),
        );
      }
    });
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5),
          leading: [
            IconButton.outline(
              icon: Icon(Icons.add),
              onPressed: ()=>_showThongTinNhanVien(context),
              size: ButtonSize.normal,
            ),
          ],
        )
      ],
      child: Padding(
        padding: EdgeInsets.all(5),
        child: DataGrid(
          onLoaded: (e) => _stateManager = e.stateManager,
          onRowDoubleTap: (event){
            if (event.cell.column.field == NhanVienString.maNV) {
              final nv = lstNhanVien.firstWhere((e) => e.maNV == event.cell.value);
              _showThongTinNhanVien(context,nhanVien: nv);
            }
          },
          rows: [],
          columns: [
            DataGridColumn(
              title: '',
              field: 'null',
              type: TrinaColumnType.text(),
              width: 20,
              cellPadding: EdgeInsets.zero,
              renderer: (re) => DataGridContainer(),
            ),
            DataGridColumn(
              title: '',
              field: 'delete',
              cellPadding: EdgeInsets.zero,
              type: TrinaColumnType.text(),
              width: 25,
              renderer: (re) => DataGridDelete(onTap: () => _onDelete(re, ref)),
            ),
            DataGridColumn(
              title: 'Mã NV',
              width: 100,
              field: NhanVienString.maNV,
              renderer: (re) => Text(re.cell.value, style: TextStyle(color: Colors.red)),
              type: TrinaColumnType.text(),
            ),
            DataGridColumn(title: 'Họ tên', field: NhanVienString.hoTen, type: TrinaColumnType.text()),
            DataGridColumn(title: 'Phái', width: 80, field: NhanVienString.phai, type: TrinaColumnType.text()),
            DataGridColumn(title: 'Ngày sinh', field: NhanVienString.ngaySinh, type: TrinaColumnType.text(),width: 120),
            DataGridColumn(title: 'Địa chỉ', field: NhanVienString.diaChi, type: TrinaColumnType.text(),width: 200),
            DataGridColumn(title: 'Trình độ', field: NhanVienString.trinhDo, type: TrinaColumnType.text(),width: 130),
            DataGridColumn(title: 'Chuyên môn', field: NhanVienString.chuyenMon, type: TrinaColumnType.text(),width: 130),
          ],
        ),
      ),
    );
  }
}
