import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../core/core.dart';

class BangTaiKhoanView extends ConsumerStatefulWidget {
  const BangTaiKhoanView({super.key});

  @override
  ConsumerState createState() => _BangTaiKhoanViewState();
}

class _BangTaiKhoanViewState extends ConsumerState<BangTaiKhoanView> {
  late TrinaGridStateManager _stateManager;
  final TrinaGridFuntion trinaGridFuntion = TrinaGridFuntion();
  Map<String, List<dynamic>> filters = {
    BangTaiKhoanString.maTK: [],
    BangTaiKhoanString.tenTK: [],
    BangTaiKhoanString.tinhChat: [],
    BangTaiKhoanString.ghiChu: [],
    BangTaiKhoanString.maXL: [],
  };

  // Lấy giá trị duy nhất từ cột dựa trên dữ liệu đã lọc
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
      bool maTk =
          filters[BangTaiKhoanString.maTK]!.isEmpty ||
          filters[BangTaiKhoanString.maTK]!.contains(row.cells[BangTaiKhoanString.maTK]!.value);
      bool tenTk =
          filters[BangTaiKhoanString.tenTK]!.isEmpty ||
          filters[BangTaiKhoanString.tenTK]!.contains(row.cells[BangTaiKhoanString.tenTK]!.value);
      bool tC =
          filters[BangTaiKhoanString.tinhChat]!.isEmpty ||
          filters[BangTaiKhoanString.tinhChat]!.contains(row.cells[BangTaiKhoanString.tinhChat]!.value);
      bool ghiChu =
          filters[BangTaiKhoanString.ghiChu]!.isEmpty ||
          filters[BangTaiKhoanString.ghiChu]!.contains(row.cells[BangTaiKhoanString.ghiChu]!.value);
      bool nhom =
          filters[BangTaiKhoanString.maXL]!.isEmpty ||
          filters[BangTaiKhoanString.maXL]!.contains(row.cells[BangTaiKhoanString.maXL]!.value);
      return maTk && tenTk && tC && ghiChu && nhom;
    });
    setState(() {});
  }

  Widget _buildTitle(TrinaColumnTitleRendererContext render, {bool isNgay = false, bool isNummber = false}) {
    return trinaGridFuntion.builTitle(
      render,
      filters,
      _applyFilters,
      isNgay: isNgay,
      isNummber: isNummber,
      enabelFilter: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(bangTaiKhoanProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state
            .map(
              (e) => TrinaRow(
                cells: {
                  'null': TrinaCell(value: ''),
                  BangTaiKhoanString.maTK: TrinaCell(value: e.maTK),
                  BangTaiKhoanString.tenTK: TrinaCell(value: e.tenTK),
                  BangTaiKhoanString.tinhChat: TrinaCell(value: e.tinhChat),
                  BangTaiKhoanString.ghiChu: TrinaCell(value: e.ghiChu),
                  BangTaiKhoanString.maXL: TrinaCell(value: e.maXL ? 'Me' : 'Con'),
                },
              ),
            )
            .toList(),
      );
      _stateManager.notifyListeners();
    });
    return Scaffold(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              color: Colors.blue.shade900,
              padding: EdgeInsets.symmetric(vertical: 2),
              alignment: Alignment.center,
              width: double.infinity,
              height: 25,
              child: Text('Quyết định 46/2000 QD-BTC', style: TextStyle(color: Colors.white)).medium(),
            ),
            Expanded(
              child: DataGrid(
                onLoaded: (e) => _stateManager = e.stateManager,
                rows: [],
                rowColorCallback: (re) {
                  if (re.row.cells[BangTaiKhoanString.maXL]!.value == 'Me') {
                    return Colors.gray.shade300;
                  }
                  return Colors.white;
                },
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
                    title: 'Mã TK',
                    width: 100,
                    titleRenderer: (re) => _buildTitle(re),
                    field: BangTaiKhoanString.maTK,
                    type: TrinaColumnType.text(),
                  ),
                  DataGridColumn(
                    title: 'Mô tả',
                    titleRenderer: (re) => _buildTitle(re),
                    width: 350,
                    field: BangTaiKhoanString.tenTK,
                    type: TrinaColumnType.text(),
                  ),
                  DataGridColumn(
                    title: 'TC',
                    titleRenderer: (re) => _buildTitle(re),
                    textAlign: TrinaColumnTextAlign.center,
                    width: 70,
                    field: BangTaiKhoanString.tinhChat,
                    type: TrinaColumnType.text(),
                  ),
                  DataGridColumn(
                    title: 'Ghi chú',
                    width: 300,
                    titleRenderer: (re) => _buildTitle(re),
                    field: BangTaiKhoanString.ghiChu,
                    type: TrinaColumnType.text(),
                  ),
                  DataGridColumn(
                    title: 'Nhóm',
                    titleRenderer: (re) => _buildTitle(re),
                    width: 100,
                    textAlign: TrinaColumnTextAlign.center,
                    field: BangTaiKhoanString.maXL,
                    type: TrinaColumnType.text(),
                    renderer: (re) {
                      return Center(
                        child: Text(
                          re.cell.value,
                          style: TextStyle(color: re.cell.value == 'Me' ? Colors.red : Colors.blue.shade900),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
