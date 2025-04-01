import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/views/danhmuc/khachhang/component/thongtinkhachhang.dart';
import 'package:app_ketoan/widgets/combobox/combobox.dart';
import 'package:app_ketoan/widgets/datagrid.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../application/providers/khachhang_provider.dart';
import '../../../data/data.dart';
import '../../../widgets/dialog_windows/dialog_windows.dart';

class KhachHangView extends ConsumerWidget {
  KhachHangView({super.key});

  late TrinaGridStateManager _stateManager;
  List<KhachHangModel> lstKH = [];

  _showInfoKhach(BuildContext context, {KhachHangModel? khach}) {
    showCustomDialog(
      context,
      title: 'THÔNG TIN KHÁCH HÀNG',
      width: 700,
      height: 550,
      child: ThongTinKhachHangView(khach: khach),
      onClose: () {},
    );
  }

  void _onDelete(TrinaColumnRendererContext re, WidgetRef ref) async {
    _stateManager.setCurrentCell(re.cell, re.rowIdx);
    if (re.cell.value != '') {
      final btn = await CustomAlert().warning(AppString.delete, title: 'KHÁCH HÀNG');
      if (btn == AlertButton.okButton) {
        int result = await ref.read(khachHangProvider.notifier).deleteKhach(re.cell.value);
        if (result != 0) {
          _stateManager.removeCurrentRow();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(khachHangProvider, (context, state) {
        lstKH = state;
        _stateManager.removeAllRows();
        _stateManager.appendRows(
          List.generate(state.length, (i) {
            final k = state[i];
            return TrinaRow(
              cells: {
                'null': TrinaCell(value: i + 1),
                'delete': TrinaCell(value: k.maKhach),
                KhachHangString.maKhach: TrinaCell(value: k.maKhach),
                KhachHangString.tenKH: TrinaCell(value: k.tenKH),
                KhachHangString.diaChi: TrinaCell(value: k.diaChi),
                KhachHangString.mst: TrinaCell(value: k.mst),
                KhachHangString.diDong: TrinaCell(value: k.diDong),
                KhachHangString.maNhom: TrinaCell(value: k.maNhom),
                KhachHangString.loaiKH: TrinaCell(value: k.loaiKH),
              },
            );
          }),
        );
    });
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5),
          leading: [
            IconButton.outline(
              icon: Icon(Icons.add),
              onPressed: () => _showInfoKhach(context),
              size: ButtonSize.normal,
            ),
            IconButton.outline(icon: Icon(PhosphorIcons.printer()), onPressed: () {}, size: ButtonSize.normal),
            IconButton.outline(
              icon: Icon(PhosphorIcons.microsoftExcelLogo()),
              onPressed: () {},
              size: ButtonSize.normal,
            ),
          ],
          trailing: [
            SizedBox(
              width: 300,
              child: Combobox(
                  selected: ref.watch(khachHangTheoDoiProvider).value,
                readOnly: true,

                items: [
                  ComboboxItem(
                    value: 'Danh sách khách hàng đang theo dõi',
                    title: ['Danh sách khách hàng đang theo dõi'],
                    valueOther: 1
                  ),
                  ComboboxItem(
                    value: 'Danh sách khách hàng ngưng theo dõi',
                    title: ['Danh sách khách hàng ngưng theo dõi'],
                    valueOther: 0
                  ),
                  ComboboxItem(value: 'Tất cả', title: ['Tất cả'],valueOther: 2),
                ],
                onChanged: (val, o) {
                  ref.read(khachHangTheoDoiProvider.notifier).state =ComboboxItem(value: val!, title:[],valueOther: o);
                  ref.read(khachHangProvider.notifier).getAll(theoDoi: o);
                  // ref.refresh(khachHangFilterProvider);
                },
              ),
            ),
          ],
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(5),
        child: DataGrid(
          onLoaded: (e) => _stateManager = e.stateManager,
          onRowDoubleTap: (event) {
            if (event.cell.column.field == KhachHangString.maKhach) {
              final kh = lstKH.firstWhere((e) => e.maKhach == event.cell.value);
              _showInfoKhach(context, khach: kh);
            }
          },
          rows: [],
          columns: [
            DataGridColumn(
              title: '',
              field: 'null',
              cellPadding: EdgeInsets.zero,
              type: TrinaColumnTypeText(),
              width: 20,
              renderer: (re) => DataGridContainer(),
            ),
            DataGridColumn(
              title: '',
              field: 'delete',
              cellPadding: EdgeInsets.zero,
              type: TrinaColumnTypeText(),
              width: 25,
              renderer: (re) => DataGridDelete(onTap: () => _onDelete(re, ref)),
            ),
            DataGridColumn(
              title: 'Mã KH',
              field: KhachHangString.maKhach,
              type: TrinaColumnTypeText(),
              width: 120,
              renderer: (re) {
                return Text(re.cell.value, style: TextStyle(color: Colors.red)).small();
              },
            ),
            DataGridColumn(
              title: 'Tên khách hàng',
              field: KhachHangString.tenKH,
              type: TrinaColumnTypeText(),
              width: 300,
            ),
            DataGridColumn(title: 'Địa chỉ', field: KhachHangString.diaChi, type: TrinaColumnTypeText(), width: 300),
            DataGridColumn(title: 'MST', field: KhachHangString.mst, type: TrinaColumnTypeText(), width: 120),
            DataGridColumn(title: 'Di động', field: KhachHangString.diDong, type: TrinaColumnTypeText(), width: 120),
            DataGridColumn(
              title: 'Nhóm khách',
              field: KhachHangString.maNhom,
              type: TrinaColumnTypeText(),
              width: 100,
              textAlign: TrinaColumnTextAlign.center,
            ),
            DataGridColumn(
              title: 'Loại',
              field: KhachHangString.loaiKH,
              type: TrinaColumnTypeText(),
              width: 80,
              textAlign: TrinaColumnTextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
