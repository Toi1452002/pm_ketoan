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

class NhanVienView extends ConsumerStatefulWidget {
  NhanVienView({super.key});

  @override
  NhanVienViewState createState() => NhanVienViewState();
}

class NhanVienViewState extends ConsumerState<NhanVienView> {
  late TrinaGridStateManager _stateManager;
  List<NhanVienModel> lstNhanVien = [];
  final TrinaGridFuntion trinaGridFuntion = TrinaGridFuntion();
  bool enabelFilter = false;
  Map<String, List<dynamic>> filters = {
    NhanVienString.maNV: [],
    NhanVienString.hoTen: [],
    NhanVienString.phai: [],
    NhanVienString.ngaySinh: [],
    NhanVienString.diaChi: [],
    NhanVienString.trinhDo: [],
    NhanVienString.chuyenMon: [],
  };

  void _showThongTinNhanVien(BuildContext context, {NhanVienModel? nhanVien}) {
    showCustomDialog(
      context,
      title: 'THÔNG TIN NHÂN VIÊN',
      width: 700,
      height: 600,
      child: ThongTinNhanVienView(nhanVien: nhanVien),
      onClose: () {},
    );
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

  void clearFilter() {
    filters = {
      NhanVienString.maNV: [],
      NhanVienString.hoTen: [],
      NhanVienString.phai: [],
      NhanVienString.ngaySinh: [],
      NhanVienString.diaChi: [],
      NhanVienString.trinhDo: [],
      NhanVienString.chuyenMon: [],
    };
    _applyFilters();
  }

  // // Lấy giá trị duy nhất từ cột dựa trên dữ liệu đã lọc
  //
  // List<dynamic> _getUniqueValues(String field, List<TrinaRow> currentRows, {bool isNgay = false}) {
  //   final data = currentRows.map((row) => row.cells[field]!.value).toSet().toList();
  //
  //   if (isNgay) {
  //     List<DateTime?> dateList = data.map((e) => Helper.stringToDate(e)).toList();
  //     dateList.sort();
  //     return dateList.map((e) => Helper.dateFormatDMY(e!)).toList();
  //   }
  //   data.sort();
  //   return data;
  // }
  //
  // void onShowFilter(String field, {String titleFiler = '', bool isNumber = false, bool isNgay = false}) {
  //   final List<TrinaRow> filteredRows =
  //       _stateManager.filterRows.isNotEmpty ? _stateManager.filterRows : _stateManager.rows;
  //
  //   List<dynamic> availableValues = _getUniqueValues(field, filteredRows, isNgay: isNgay);
  //   Map<String, bool> filterOptions = {
  //     for (var value in availableValues) value.toString(): filters[field]!.contains(value),
  //   };
  //   showCustomDialog(
  //     context,
  //     title: "Filter $titleFiler",
  //     width: 250,
  //     height: 400,
  //     barrierDismissible: true,
  //     child: FilterWidget(
  //       isNumber: isNumber,
  //       items: filterOptions,
  //       onChanged: (val) {
  //         filters[field] =
  //             val.entries
  //                 .where((e) => e.value)
  //                 .map((e) => availableValues.firstWhere((v) => v.toString() == e.key))
  //                 .toList();
  //         _applyFilters();
  //       },
  //     ),
  //     onClose: () {},
  //   );
  // }

  void _applyFilters() {
    _stateManager.setFilter((row) {
      bool maNV =
          filters[NhanVienString.maNV]!.isEmpty ||
          filters[NhanVienString.maNV]!.contains(row.cells[NhanVienString.maNV]!.value);
      bool tenNV =
          filters[NhanVienString.hoTen]!.isEmpty ||
          filters[NhanVienString.hoTen]!.contains(row.cells[NhanVienString.hoTen]!.value);
      bool phai =
          filters[NhanVienString.phai]!.isEmpty ||
          filters[NhanVienString.phai]!.contains(row.cells[NhanVienString.phai]!.value);
      bool ngaySinh =
          filters[NhanVienString.ngaySinh]!.isEmpty ||
          filters[NhanVienString.ngaySinh]!.contains(row.cells[NhanVienString.ngaySinh]!.value);
      bool diaChi =
          filters[NhanVienString.diaChi]!.isEmpty ||
          filters[NhanVienString.diaChi]!.contains(row.cells[NhanVienString.diaChi]!.value);
      bool trinhDo =
          filters[NhanVienString.trinhDo]!.isEmpty ||
          filters[NhanVienString.trinhDo]!.contains(row.cells[NhanVienString.trinhDo]!.value);
      bool chuyenMon =
          filters[NhanVienString.chuyenMon]!.isEmpty ||
          filters[NhanVienString.chuyenMon]!.contains(row.cells[NhanVienString.chuyenMon]!.value);
      return maNV && tenNV && phai && ngaySinh && diaChi && trinhDo && chuyenMon;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            IconAdd(onPressed: () => _showThongTinNhanVien(context)),
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
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(5),
        child: DataGrid(
          onLoaded: (e) => _stateManager = e.stateManager,
          onRowDoubleTap: (event) {
            if (event.cell.column.field == NhanVienString.maNV) {
              final nv = lstNhanVien.firstWhere((e) => e.maNV == event.cell.value);
              _showThongTinNhanVien(context, nhanVien: nv);
            }
          },
          rows: [],
          columns: [
            DataGridColumn(
              title: '',
              field: 'null',
              type: TrinaColumnType.text(),
              width: 25,
              cellPadding: EdgeInsets.zero,
              titleRenderer: (re) => DataGridTitle(title: ''),
              renderer: (re) => DataGridContainer(text: "${re.rowIdx + 1}"),
            ),
            DataGridColumn(
              title: '',
              field: 'delete',
              cellPadding: EdgeInsets.zero,
              type: TrinaColumnType.text(),
              width: 25,
              titleRenderer: (re) => DataGridTitle(title: ''),
              renderer: (re) => DataGridDelete(onTap: () => _onDelete(re, ref)),
            ),
            DataGridColumn(
              title: 'Mã NV',
              width: 100,
              field: NhanVienString.maNV,
              renderer: (re) => Text(re.cell.value, style: TextStyle(color: Colors.red)),
              titleRenderer: (re) => _buildTitle(re),
              type: TrinaColumnType.text(),
            ),
            DataGridColumn(
              title: 'Họ tên',
              field: NhanVienString.hoTen,
              type: TrinaColumnType.text(),
              titleRenderer: (re) => _buildTitle(re),
            ),
            DataGridColumn(
              title: 'Phái',
              width: 80,
              field: NhanVienString.phai,
              type: TrinaColumnType.text(),
              titleRenderer: (re) => _buildTitle(re),
            ),
            DataGridColumn(
              title: 'Ngày sinh',
              field: NhanVienString.ngaySinh,
              type: TrinaColumnType.text(),
              width: 120,
              titleRenderer: (re) => _buildTitle(re),
            ),
            DataGridColumn(
              title: 'Địa chỉ',
              field: NhanVienString.diaChi,
              type: TrinaColumnType.text(),
              width: 200,
              titleRenderer: (re) => _buildTitle(re),
            ),
            DataGridColumn(
              title: 'Trình độ',
              field: NhanVienString.trinhDo,
              type: TrinaColumnType.text(),
              width: 130,
              titleRenderer: (re) => _buildTitle(re),
            ),
            DataGridColumn(
              title: 'Chuyên môn',
              field: NhanVienString.chuyenMon,
              type: TrinaColumnType.text(),
              width: 130,
              titleRenderer: (re) => _buildTitle(re),
            ),
          ],
        ),
      ),
    );
  }
}
