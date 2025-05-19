import 'package:app_ketoan/application/providers/dauky_provider.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:flutter/material.dart' as mt;
import '../../../core/core.dart';
import '../../../widgets/widgets.dart';

class NoDauKyView extends ConsumerStatefulWidget {
  const NoDauKyView({super.key});

  @override
  NoDauKyViewState createState() => NoDauKyViewState();
}

class NoDauKyViewState extends ConsumerState<NoDauKyView> {
  late TrinaGridStateManager _stateManager;
  final TrinaGridFuntion trinaGridFuntion = TrinaGridFuntion();
  bool enabelFilter = false;

  Map<String, List<dynamic>> filters = {
    DauKyKhachHangString.ngay: [],
    DauKyKhachHangString.maKhach: [],
    DauKyKhachHangString.tenKH: [],
    DauKyKhachHangString.soDuNo: [],
  };

  void _applyFilters() {
    _stateManager.setFilter((row) {
      bool ngay =
          filters[DauKyKhachHangString.ngay]!.isEmpty ||
              filters[DauKyKhachHangString.ngay]!.contains(row.cells[DauKyKhachHangString.ngay]!.value);
      bool maKH =
          filters[DauKyKhachHangString.maKhach]!.isEmpty ||
              filters[DauKyKhachHangString.maKhach]!.contains(row.cells[DauKyKhachHangString.maKhach]!.value);
      bool tenKH =
          filters[DauKyKhachHangString.tenKH]!.isEmpty ||
              filters[DauKyKhachHangString.tenKH]!.contains(row.cells[DauKyKhachHangString.tenKH]!.value);
      bool soDuNo =
          filters[DauKyKhachHangString.soDuNo]!.isEmpty ||
              filters[DauKyKhachHangString.soDuNo]!.contains(row.cells[DauKyKhachHangString.soDuNo]!.value.toString());
      return ngay && maKH && tenKH && soDuNo;
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
      enabelFilter: enabelFilter,
    );
  }

  void onCapNhatDauKy() async {
    _stateManager.setCurrentCell(_stateManager.firstCell, 0);
    _stateManager.setKeepFocus(false);
    final x = _stateManager.rows.where((e) => e.cells[DauKyKhachHangString.soDuNo]!.value != 0);
    final btn = await CustomAlert().question(
      'Danh sách trên sẽ được cập nhật vào SỔ ĐẦU KỲ',
      title: 'DAU KY KHACH HANG',
    );
    if (btn == AlertButton.okButton && x.isNotEmpty) {
      final lst =
      x.map((e) {
        final date = e.cells[DauKyKhachHangString.ngay]!.value;
        final a = Helper.stringToDate(date);
        final b = DateFormat('yyyy-MM').format(DateTime(a!.year, a.month - 1));
        return DauKyKhachHangModel(
          thang: b,
          maKhach: e.cells[DauKyKhachHangString.maKhach]!.value,
          tenKH: e.cells[DauKyKhachHangString.tenKH]!.value,
          soDuNo: double.parse(e.cells[DauKyKhachHangString.soDuNo]!.value.toString()),
          ngay: Helper.stringDateFormatYMD(e.cells[DauKyHangHoaString.ngay]!.value),
        );
      }).toList();
      final result = await ref.read(dKyKhachHangProvider.notifier).capNhatDKyKhachHang(lst);
      if (result) {
        CustomAlert().success('Cập nhật thành công');
        ref.read(dKyKhachHangProvider.notifier).getDKyKhachHang();
      } else {
        CustomAlert().error('Cập nhật thất bại');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    ref.listen(dKyKhachHangProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state
            .map(
              (e) => TrinaRow(
            cells: {
              'null': TrinaCell(value: e.maKhach),
              DauKyKhachHangString.ngay: TrinaCell(value: e.ngay),
              DauKyKhachHangString.maKhach: TrinaCell(value: e.maKhach),
              DauKyKhachHangString.tenKH: TrinaCell(value: e.tenKH),
              DauKyKhachHangString.soDuNo: TrinaCell(value: e.soDuNo),
            },
          ),
        )
            .toList(),
      );
    });
    return Scaffold(headers: [
      AppBar(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        leading: [
          IconFilter(
            onPressed: () {
              enabelFilter = !enabelFilter;
              if (!enabelFilter) {
                filters =  {
                  DauKyKhachHangString.ngay: [],
                  DauKyKhachHangString.maKhach: [],
                  DauKyKhachHangString.tenKH: [],
                  DauKyKhachHangString.soDuNo: [],
                };
                _applyFilters();
              }
              setState(() {});
            },
            isFilter: enabelFilter,
          ),
        ],
        trailing: [
          PrimaryButton(
            child: Text('Cập nhật'),
            onPressed: () {
              onCapNhatDauKy();
            },
          ),
        ],
      ),
    ],
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: DataGrid(
          onLoaded: (e) => _stateManager = e.stateManager,
          rows: [],

          columns: [
            DataGridColumn(
              title: '',
              field: 'null',
              type: TrinaColumnType.text(),
              titleRenderer: (re) => DataGridTitle(title: ''),
              cellPadding: EdgeInsets.zero,
              width: 25,
              renderer: (re) => DataGridContainer(text: "${re.rowIdx + 1}"),
            ),
            DataGridColumn(
              title: 'Ngày',
              field: DauKyKhachHangString.ngay,
              titleRenderer: (re) => _buildTitle(re, isNgay: true),
              type: TrinaColumnType.date(format: 'dd/MM/yyyy'),
              editCellRenderer: (a, b, c, d, e) {
                return GestureDetector(
                  onTap: () async {
                    final date = await mt.showDatePicker(
                      builder: (context, child){
                        return mt.Theme(data: mt.ThemeData(
                          colorSchemeSeed: mt.Colors.blue,
                          datePickerTheme: mt.DatePickerThemeData(
                              shape: mt.RoundedRectangleBorder(
                                  borderRadius: mt.BorderRadius.circular(2)
                              )
                          ),
                        ), child: child!);
                      },
                      context: context,
                      initialDate: Helper.stringToDate(b.value),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(4000),
                    );
                    if (date != null) {
                      b.value = Helper.dateFormatDMY(date);
                      _stateManager.notifyListeners();
                    }
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(b.value, style: TextStyle(fontSize: 13)).medium(),
                  ),
                );
              },
              renderer:
                  (re) => Align(
                alignment: Alignment.center,
                child: Text(re.cell.value, style: TextStyle(fontSize: 13)).medium(),
              ),
              enableEditingMode: true,
              width: 85,
            ),
            DataGridColumn(
              title: 'Mã khách hàng',
              titleRenderer: (re) => _buildTitle(re),
              renderer:
                  (re) => Text(re.cell.value, style: TextStyle(fontSize: 13, color: Colors.blue.shade900)).medium(),
              field: DauKyKhachHangString.maKhach,
              type: TrinaColumnType.text(),
              width: 150,
            ),
            DataGridColumn(
              title: 'Tên khách hàng',
              field: DauKyKhachHangString.tenKH,

              titleRenderer: (re) => _buildTitle(re),
              type: TrinaColumnType.text(),
              renderer:
                  (re) => Text(re.cell.value, style: TextStyle(fontSize: 13, color: Colors.blue.shade800)).medium(),
              width: 300,
            ),
            DataGridColumn(
              title: 'Số đầu kỳ',
              field: DauKyKhachHangString.soDuNo,
              type: TrinaColumnType.number(allowFirstDot: true, format: '#,###.#'),
              width: 100,
              enableEditingMode: true,
              titleRenderer: (re) => _buildTitle(re, isNummber: true),
              textAlign: TrinaColumnTextAlign.end,
              footerRenderer: (re)=>DataGridFooter(re)
            ),
          ],
        ),
      ),);
  }
}

