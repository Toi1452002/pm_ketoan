import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/views/danhmuc/khachhang/component/pdf_khachhang.dart';
import 'package:app_ketoan/views/danhmuc/khachhang/component/thongtinkhachhang.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../application/application.dart';
import '../../../data/data.dart';
import '../../../widgets/widgets.dart';

class KhachHangView extends ConsumerStatefulWidget {
  KhachHangView({super.key});

  @override
  KhachHangViewState createState() => KhachHangViewState();
}

class KhachHangViewState extends ConsumerState<KhachHangView> {
  late TrinaGridStateManager _stateManager;
  List<KhachHangModel> lstKH = [];
  final TrinaGridFuntion trinaGridFuntion = TrinaGridFuntion();
  bool enabelFilter = false;

  Map<String, List<dynamic>> filters = {
    KhachHangString.maKhach: [],
    KhachHangString.tenKH: [],
    KhachHangString.diaChi: [],
    KhachHangString.mst: [],
    KhachHangString.diDong: [],
    KhachHangString.maNhom: [],
    KhachHangString.loaiKH: [],
  };

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

  Widget _buildTitle(TrinaColumnTitleRendererContext render, {bool isNgay = false, bool isNummber = false}) {
    return trinaGridFuntion.builTitle(
      render,
      filters,
      _applyFilters,
      isNgay: isNgay,
      isNummber: isNummber,
      enabelFilter: enabelFilter,
    );
  }
  void _applyFilters() {
    _stateManager.setFilter((row) {
      bool maKH =
          filters[KhachHangString.maKhach]!.isEmpty ||
          filters[KhachHangString.maKhach]!.contains(row.cells[KhachHangString.maKhach]!.value);
      bool tenKH =
          filters[KhachHangString.tenKH]!.isEmpty ||
          filters[KhachHangString.tenKH]!.contains(row.cells[KhachHangString.tenKH]!.value);
      bool diaChi =
          filters[KhachHangString.diaChi]!.isEmpty ||
          filters[KhachHangString.diaChi]!.contains(row.cells[KhachHangString.diaChi]!.value);
      bool mst =
          filters[KhachHangString.mst]!.isEmpty ||
          filters[KhachHangString.mst]!.contains(row.cells[KhachHangString.mst]!.value);
      bool diDong =
          filters[KhachHangString.diDong]!.isEmpty ||
          filters[KhachHangString.diDong]!.contains(row.cells[KhachHangString.diDong]!.value);
      bool nhomKhach =
          filters[KhachHangString.maNhom]!.isEmpty ||
          filters[KhachHangString.maNhom]!.contains(row.cells[KhachHangString.maNhom]!.value);
      bool loaiKhach =
          filters[KhachHangString.loaiKH]!.isEmpty ||
          filters[KhachHangString.loaiKH]!.contains(row.cells[KhachHangString.loaiKH]!.value);

      return maKH && tenKH && diDong && diaChi && mst && nhomKhach && loaiKhach;
    });
    setState(() {});
  }

  void clearFilter(){
    filters = {
      KhachHangString.maKhach: [],
      KhachHangString.tenKH: [],
      KhachHangString.diaChi: [],
      KhachHangString.mst: [],
      KhachHangString.diDong: [],
      KhachHangString.maNhom: [],
      KhachHangString.loaiKH: [],
    };
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
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
              KhachHangString.dienThoai: TrinaCell(value: k.dienThoai),
            },
          );
        }),
      );
    });
    final qlXBC = ref.read(tuyChonProvider).firstWhere((e) => e.nhom == MaTuyChon.qlXBC).giaTri == 1;

    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5),
          leading: [
            IconAdd(onPressed: () => _showInfoKhach(context)),
            IconPrinter(
              onPressed: () {
                if (qlXBC) {
                  showViewPrinter(context, PdfKhachHangView(stateManager: _stateManager),isPortrait: false);
                } else {
                  PdfWidget().onPrint(
                    onLayout: pdfKhachHang(dateNow: Helper.dateNowDMY(), stateManager: _stateManager),
                    format: PdfPageFormat.a4.landscape,
                  );
                }
              },
            ),
            IconExcel(
              onPressed: () {
                excelKhachHang(_stateManager);
              },
            ),
            IconFilter(
              onPressed: () {
                enabelFilter = !enabelFilter;
                if (!enabelFilter) {
                  clearFilter();
                }
                setState(() {});
              },
              isFilter: enabelFilter,
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
                    valueOther: 1,
                  ),
                  ComboboxItem(
                    value: 'Danh sách khách hàng ngưng theo dõi',
                    title: ['Danh sách khách hàng ngưng theo dõi'],
                    valueOther: 0,
                  ),
                  ComboboxItem(value: 'Tất cả', title: ['Tất cả'], valueOther: 2),
                ],
                onChanged: (val, o) {
                  ref.read(khachHangTheoDoiProvider.notifier).state = ComboboxItem(
                    value: val!,
                    title: [],
                    valueOther: o,
                  );
                  ref.read(khachHangProvider.notifier).getAll(theoDoi: o);

                  setState(() {
                    filters = {
                      KhachHangString.maKhach: [],
                      KhachHangString.tenKH: [],
                      KhachHangString.diaChi: [],
                      KhachHangString.mst: [],
                      KhachHangString.diDong: [],
                      KhachHangString.maNhom: [],
                      KhachHangString.loaiKH: [],
                    };
                  });
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
              titleRenderer: (re) => DataGridTitle(title: ""),
              width: 25,
              renderer: (re) => DataGridContainer(text: "${re.rowIdx + 1}"),
            ),
            DataGridColumn(
              title: '',
              field: 'delete',
              cellPadding: EdgeInsets.zero,
              type: TrinaColumnTypeText(),
              width: 25,
              titleRenderer: (re) => DataGridTitle(title: ''),
              renderer: (re) => DataGridDelete(onTap: () => _onDelete(re, ref)),
            ),
            DataGridColumn(
              title: 'Mã KH',
              field: KhachHangString.maKhach,
              type: TrinaColumnTypeText(),
              titleRenderer: (re)=>_buildTitle(re),
              width: 120,
              renderer: (re) {
                return Text(re.cell.value, style: TextStyle(color: Colors.red)).small();
              },
            ),
            DataGridColumn(
              title: 'Tên khách hàng',
              field: KhachHangString.tenKH,
              type: TrinaColumnTypeText(),
              titleRenderer: (re)=>_buildTitle(re),
              width: 300,
            ),
            DataGridColumn(
              title: 'Địa chỉ',
              field: KhachHangString.diaChi,
              titleRenderer: (re)=>_buildTitle(re),
              type: TrinaColumnTypeText(),
              width: 285,
            ),
            DataGridColumn(
              title: 'MST',
              field: KhachHangString.mst,
              titleRenderer: (re)=>_buildTitle(re),
              type: TrinaColumnTypeText(),
              width: 120,
            ),
            DataGridColumn(
              title: 'Di động',
              field: KhachHangString.diDong,
              titleRenderer: (re)=>_buildTitle(re),
              type: TrinaColumnTypeText(),
              width: 120,
            ),
            DataGridColumn(
              title: 'Nhóm khách',
              field: KhachHangString.maNhom,
              type: TrinaColumnTypeText(),
              width: 110,
              textAlign: TrinaColumnTextAlign.center,
              titleRenderer: (re)=>_buildTitle(re),
            ),
            DataGridColumn(
              title: 'Loại',
              field: KhachHangString.loaiKH,
              type: TrinaColumnTypeText(),
              width: 80,
              textAlign: TrinaColumnTextAlign.center,
              titleRenderer: (re)=>_buildTitle(re),
            ),
            DataGridColumn(
              title: 'DienThoai',
              field: KhachHangString.dienThoai,
              type: TrinaColumnTypeText(),
              hide: true,
            ),
          ],
        ),
      ),
    );
  }
}
