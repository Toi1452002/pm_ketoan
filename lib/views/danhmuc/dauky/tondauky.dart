import 'package:app_ketoan/application/providers/dauky_provider.dart';
import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter/material.dart' as mt;
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';
import '../../../widgets/widgets.dart';

class TonDauKyView extends ConsumerStatefulWidget {
  const TonDauKyView({super.key});

  @override
  TonDauKyViewState createState() => TonDauKyViewState();
}

class TonDauKyViewState extends ConsumerState<TonDauKyView> {
  late TrinaGridStateManager _stateManager;
  final TrinaGridFuntion trinaGridFuntion = TrinaGridFuntion();
  bool enabelFilter = false;
  Map<String, List<dynamic>> filters = {
    DauKyHangHoaString.ngay: [],
    DauKyHangHoaString.maHH: [],
    DauKyHangHoaString.tenHH: [],
    DauKyHangHoaString.soTon: [],
    DauKyHangHoaString.giaVon: [],
  };

  void _applyFilters() {
    _stateManager.setFilter((row) {
      bool ngay =
          filters[DauKyHangHoaString.ngay]!.isEmpty ||
          filters[DauKyHangHoaString.ngay]!.contains(row.cells[DauKyHangHoaString.ngay]!.value);
      bool maHH =
          filters[DauKyHangHoaString.maHH]!.isEmpty ||
          filters[DauKyHangHoaString.maHH]!.contains(row.cells[DauKyHangHoaString.maHH]!.value);
      bool tenHH =
          filters[DauKyHangHoaString.tenHH]!.isEmpty ||
          filters[DauKyHangHoaString.tenHH]!.contains(row.cells[DauKyHangHoaString.tenHH]!.value);
      bool soTon =
          filters[DauKyHangHoaString.soTon]!.isEmpty ||
          filters[DauKyHangHoaString.soTon]!.contains(row.cells[DauKyHangHoaString.soTon]!.value.toString());
      bool giaVon =
          filters[DauKyHangHoaString.giaVon]!.isEmpty ||
          filters[DauKyHangHoaString.giaVon]!.contains(row.cells[DauKyHangHoaString.giaVon]!.value.toString());
      return ngay && maHH && tenHH && soTon && giaVon;
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
    final x = _stateManager.rows.where((e) => e.cells[DauKyHangHoaString.soTon]!.value != 0);

    final btn = await CustomAlert().question(
      '${x.length} dòng sẽ được cập nhật vào SỔ ĐẦU KỲ',
      title: 'DAU KY HANG HOA',
    );
    if (btn == AlertButton.okButton && x.isNotEmpty) {
      final lst =
          x.map((e) {
            final date = e.cells[DauKyHangHoaString.ngay]!.value;
            final a = Helper.stringToDate(date);
            final b = DateFormat('yyyy-MM').format(DateTime(a!.year, a.month - 1));
            return DauKyHangHoaModel(
              thang: b,
              itemID: e.cells['null']!.value,
              soTon: double.parse(e.cells[DauKyHangHoaString.soTon]!.value.toString()),
              giaVon: double.parse(e.cells[DauKyHangHoaString.giaVon]!.value.toString()),
              ngay: Helper.stringDateFormatYMD(e.cells[DauKyHangHoaString.ngay]!.value),
            );
          }).toList();
      final result = await ref.read(dauKyHangHoaProvider.notifier).capNhatDauKy(lst);
      if (result) {
        CustomAlert().success('Cập nhật thành công');
        ref.read(dauKyHangHoaProvider.notifier).getTonDauKy();
      } else {
        CustomAlert().error('Cập nhật thất bại');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(dauKyHangHoaProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state
            .map(
              (e) => TrinaRow(
                cells: {
                  'null': TrinaCell(value: e.itemID),
                  DauKyHangHoaString.ngay: TrinaCell(value: e.ngay),
                  DauKyHangHoaString.maHH: TrinaCell(value: e.maHH),
                  DauKyHangHoaString.tenHH: TrinaCell(value: e.tenHH),
                  DauKyHangHoaString.soTon: TrinaCell(value: e.soTon),
                  DauKyHangHoaString.giaVon: TrinaCell(value: e.giaVon),
                },
              ),
            )
            .toList(),
      );
    });

    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          leading: [
            IconFilter(
              onPressed: () {
                enabelFilter = !enabelFilter;
                if (!enabelFilter) {
                  filters = {
                    DauKyHangHoaString.ngay: [],
                    DauKyHangHoaString.maHH: [],
                    DauKyHangHoaString.tenHH: [],
                    DauKyHangHoaString.soTon: [],
                    DauKyHangHoaString.giaVon: [],
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
              field: DauKyHangHoaString.ngay,
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
              title: 'Mã hàng',
              titleRenderer: (re) => _buildTitle(re),
              renderer:
                  (re) => Text(re.cell.value, style: TextStyle(fontSize: 13, color: Colors.blue.shade900)).medium(),
              field: DauKyHangHoaString.maHH,
              type: TrinaColumnType.text(),
              width: 100,
            ),
            DataGridColumn(
              title: 'Tên hàng hóa',
              field: DauKyHangHoaString.tenHH,

              titleRenderer: (re) => _buildTitle(re),
              type: TrinaColumnType.text(),
              renderer:
                  (re) => Text(re.cell.value, style: TextStyle(fontSize: 13, color: Colors.blue.shade800)).medium(),
              width: 300,
            ),
            DataGridColumn(
              title: 'Số lượng',
              field: DauKyHangHoaString.soTon,
              type: TrinaColumnType.number(allowFirstDot: true, format: '#,###.#'),
              width: 90,
              enableEditingMode: true,
              titleRenderer: (re) => _buildTitle(re, isNummber: true),
              textAlign: TrinaColumnTextAlign.end,
            ),
            DataGridColumn(
              title: 'Giá vốn',
              field: DauKyHangHoaString.giaVon,
              type: TrinaColumnType.number(allowFirstDot: true, format: '#,###.##'),
              width: 100,
              enableEditingMode: true,
              titleRenderer: (re) => _buildTitle(re, isNummber: true),
              textAlign: TrinaColumnTextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}
