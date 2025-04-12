import 'package:app_ketoan/views/thuchi/component/pdf_bangkephieuthu.dart';
import 'package:app_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../application/application.dart';
import '../../core/core.dart';
import '../../data/data.dart';

class BangKePhieuThuView extends ConsumerStatefulWidget {
  BangKePhieuThuView({super.key});

  @override
  BangKePhieuThuViewState createState() => BangKePhieuThuViewState();
}

class BangKePhieuThuViewState extends ConsumerState<BangKePhieuThuView> {
  late TrinaGridStateManager _stateManager;
  DateTime tuNgay = DateTime.now().copyWith(day: 1);
  DateTime denNgay = DateTime.now();
  String strTuNgay = Helper.dateFormatDMY(DateTime.now().copyWith(day: 1));
  String strDenNgay = Helper.dateFormatDMY(DateTime.now());

  Map<String, List<dynamic>> filters = {
    PhieuThuString.ngay: [],
    PhieuThuString.phieu: [],
    PhieuThuString.maTC: [],
    PhieuThuString.maKhach: [],
    PhieuThuString.tenKhach: [],
    PhieuThuString.pttt: [],
    PhieuThuString.noiDung: [],
    PhieuThuString.soTien: [],
    PhieuThuString.tkNo: [],
    PhieuThuString.tkCo: [],
  };

  // Lấy giá trị duy nhất từ cột dựa trên dữ liệu đã lọc

  List<dynamic> _getUniqueValues(String field, List<TrinaRow> currentRows, {bool isNgay = false}) {
    final data = currentRows.map((row) => row.cells[field]!.value).toSet().toList();

    if (isNgay) {
      List<DateTime?> dateList = data.map((e) => Helper.stringToDate(e)).toList();
      dateList.sort();
      return dateList.map((e) => Helper.dateFormatDMY(e!)).toList();
    }
    data.sort();
    return data;
  }

  // Áp dụng bộ lọc cho tất cả cột
  void _applyFilters() {
    _stateManager.setFilter((row) {
      bool ngay =
          filters[PhieuThuString.ngay]!.isEmpty ||
          filters[PhieuThuString.ngay]!.contains(row.cells[PhieuThuString.ngay]!.value);
      bool phieu =
          filters[PhieuThuString.phieu]!.isEmpty ||
          filters[PhieuThuString.phieu]!.contains(row.cells[PhieuThuString.phieu]!.value);
      bool maTC =
          filters[PhieuThuString.maTC]!.isEmpty ||
          filters[PhieuThuString.maTC]!.contains(row.cells[PhieuThuString.maTC]!.value);
      bool maKH =
          filters[PhieuThuString.maKhach]!.isEmpty ||
          filters[PhieuThuString.maKhach]!.contains(row.cells[PhieuThuString.maKhach]!.value);
      bool tenKH =
          filters[PhieuThuString.tenKhach]!.isEmpty ||
          filters[PhieuThuString.tenKhach]!.contains(row.cells[PhieuThuString.tenKhach]!.value);
      bool pttt =
          filters[PhieuThuString.pttt]!.isEmpty ||
          filters[PhieuThuString.pttt]!.contains(row.cells[PhieuThuString.pttt]!.value);
      bool noiDung =
          filters[PhieuThuString.noiDung]!.isEmpty ||
          filters[PhieuThuString.noiDung]!.contains(row.cells[PhieuThuString.noiDung]!.value);
      bool soTien =
          filters[PhieuThuString.soTien]!.isEmpty ||
          filters[PhieuThuString.soTien]!.contains(row.cells[PhieuThuString.soTien]!.value);
      bool tkNo =
          filters[PhieuThuString.tkNo]!.isEmpty ||
          filters[PhieuThuString.tkNo]!.contains(row.cells[PhieuThuString.tkNo]!.value);
      bool tkCo =
          filters[PhieuThuString.tkCo]!.isEmpty ||
          filters[PhieuThuString.tkCo]!.contains(row.cells[PhieuThuString.tkCo]!.value);

      return ngay && phieu && maTC && maKH && tenKH && pttt && noiDung && soTien && tkNo && tkCo;
    });
    setState(() {});
  }

  void onShowFilter(String field, {String titleFiler = '', bool isNumber = false, bool isNgay = false}) {
    final List<TrinaRow> filteredRows =
        _stateManager.filterRows.isNotEmpty ? _stateManager.filterRows : _stateManager.rows;

    List<dynamic> availableValues = _getUniqueValues(field, filteredRows, isNgay: isNgay);
    Map<String, bool> filterOptions = {
      for (var value in availableValues) value.toString(): filters[field]!.contains(value),
    };
    showCustomDialog(
      context,
      title: "FILTER $titleFiler",
      width: 250,
      height: 400,
      barrierDismissible: true,
      child: FilterWidget(
        isNumber: isNumber,
        items: filterOptions,
        onChanged: (val) {
          filters[field] =
              val.entries
                  .where((e) => e.value)
                  .map((e) => availableValues.firstWhere((v) => v.toString() == e.key))
                  .toList();
          _applyFilters();
        },
      ),
      onClose: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(bangKePhieuThuProvider, (context, state) {
      if (state.isNotEmpty) {
        _stateManager.removeAllRows();
        _stateManager.appendRows(
          List.generate(state.length, (index) {
            final x = state[index];
            return TrinaRow(
              cells: {
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
            iconPrinter(
              onPressed: () {
                final qlXBC =
                    ref.read(tuyChonProvider).firstWhere((e) => e.nhom == 'qlXBC').giaTri ==
                    1; //Nếu bằng 1 thi xem bc truoc khi in

                if (qlXBC) {
                  showViewPrinter(
                    context,
                    PdfBangKePhieuThuView(tuNgay: strTuNgay, denNgay: strDenNgay, stateManager: _stateManager),
                  );
                } else {
                  PdfWidget().onPrint(
                    onLayout: pdfBangKePhieuThu(
                      tN: strTuNgay,
                      dN: strDenNgay,
                      dateNow: Helper.dateNowDMY(),
                      stateManager: _stateManager,
                    ),
                  );
                }
              },
            ),
            iconExcel(onPressed: () {excelBangKePhieuThu(_stateManager);
            }),
            Gap(40),
            SizedBox(
              width: 150,
              child: DateTextbox(
                onChanged: (val) {
                  tuNgay = val!;
                  setState(() {});
                },
                initialDate: tuNgay,
                label: 'Từ ngày',
                showClear: false,
              ),
            ),
            Gap(10),
            SizedBox(
              width: 160,
              child: DateTextbox(
                onChanged: (val) {
                  denNgay = val!;
                  setState(() {});
                },
                initialDate: denNgay,
                label: 'Đến ngày',
                showClear: false,
              ),
            ),
            PrimaryButton(
              size: ButtonSize(.8),
              child: Text('Thực hiện'),
              onPressed: () {
                ref
                    .read(bangKePhieuThuProvider.notifier)
                    .getBangKePhieuThu(tN: Helper.dateFormatYMD(tuNgay), dN: Helper.dateFormatYMD(denNgay));

                setState(() {
                  strTuNgay = Helper.dateFormatDMY(tuNgay);
                  strDenNgay = Helper.dateFormatDMY(denNgay);
                  filters = {
                    PhieuThuString.ngay: [],
                    PhieuThuString.phieu: [],
                    PhieuThuString.maTC: [],
                    PhieuThuString.maKhach: [],
                    PhieuThuString.tenKhach: [],
                    PhieuThuString.pttt: [],
                    PhieuThuString.noiDung: [],
                    PhieuThuString.soTien: [],
                    PhieuThuString.tkNo: [],
                    PhieuThuString.tkCo: [],
                  };
                });
              },
            ),
          ],
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(5),
        child: DataGrid(
          onLoaded: (e) {
            _stateManager = e.stateManager;
          },
          onRowDoubleTap: (event) async {
            if (event.cell.column.field == PhieuThuString.phieu) {
              showPhieuThu(context, stt: event.row.cells['null']!.value);
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
              titleRenderer: (re) => DataGridTitle(title: ''),
              type: TrinaColumnType.text(),
            ),
            DataGridColumn(
              title: 'Ngày',
              titleRenderer:
                  (re) => DataGridTitleFilter(
                    isFilter: filters[PhieuXuatString.ngay]!.isNotEmpty,
                    title: re.column.title,
                    onPressed: () {
                      onShowFilter(re.column.field, titleFiler: re.column.title, isNgay: true);
                    },
                  ),
              field: PhieuThuString.ngay,
              type: TrinaColumnType.text(),
              width: 80,
              footerRenderer: (re) {
                return TrinaAggregateColumnFooter(
                  rendererContext: re,
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  type: TrinaAggregateColumnType.count,
                  titleSpanBuilder: (text) {
                    return [
                      TextSpan(text: 'Record: ', style: TextStyle(fontSize: 12)),
                      TextSpan(text: text, style: TextStyle(fontSize: 12)),
                    ];
                  },
                );
              },
            ),
            DataGridColumn(
              title: 'Phiếu',
              field: PhieuThuString.phieu,
              type: TrinaColumnType.text(),
              width: 70,
              titleRenderer:
                  (re) => DataGridTitleFilter(
                    isFilter: filters[re.column.field]!.isNotEmpty,
                    title: re.column.title,
                    onPressed: () {
                      onShowFilter(re.column.field, titleFiler: re.column.title);
                    },
                  ),
              renderer: (re) => Text(re.cell.value, style: TextStyle(color: Colors.red, fontSize: 13.5)),
            ),
            DataGridColumn(
              title: 'Kiểu thu',
              field: PhieuThuString.maTC,
              type: TrinaColumnType.text(),
              width: 90,
              titleRenderer:
                  (re) => DataGridTitleFilter(
                    isFilter: filters[re.column.field]!.isNotEmpty,
                    title: re.column.title,
                    onPressed: () {
                      onShowFilter(re.column.field, titleFiler: re.column.title);
                    },
                  ),
              textAlign: TrinaColumnTextAlign.center,
            ),
            DataGridColumn(
              title: 'Mã KH',
              titleRenderer:
                  (re) => DataGridTitleFilter(
                    isFilter: filters[re.column.field]!.isNotEmpty,
                    title: re.column.title,
                    onPressed: () {
                      onShowFilter(re.column.field, titleFiler: re.column.title);
                    },
                  ),
              field: PhieuThuString.maKhach,
              type: TrinaColumnType.text(),
              width: 80,
            ),
            DataGridColumn(
              title: 'Tên khách',
              field: PhieuThuString.tenKhach,
              titleRenderer:
                  (re) => DataGridTitleFilter(
                    isFilter: filters[re.column.field]!.isNotEmpty,
                    title: re.column.title,
                    onPressed: () {
                      onShowFilter(re.column.field, titleFiler: re.column.title);
                    },
                  ),
              type: TrinaColumnType.text(),
              width: 300,
            ),
            DataGridColumn(
              title: 'PTTT',
              field: PhieuThuString.pttt,
              type: TrinaColumnType.text(),
              width: 75,
              titleRenderer:
                  (re) => DataGridTitleFilter(
                    isFilter: filters[re.column.field]!.isNotEmpty,
                    title: re.column.title,
                    onPressed: () {
                      onShowFilter(re.column.field, titleFiler: re.column.title);
                    },
                  ),
              textAlign: TrinaColumnTextAlign.center,
            ),
            DataGridColumn(
              title: 'Lý do thu',
              field: PhieuThuString.noiDung,
              type: TrinaColumnType.text(),
              titleRenderer:
                  (re) => DataGridTitleFilter(
                    isFilter: filters[re.column.field]!.isNotEmpty,
                    title: re.column.title,
                    onPressed: () {
                      onShowFilter(re.column.field, titleFiler: re.column.title);
                    },
                  ),
              width: 285,
            ),
            DataGridColumn(
              title: 'Số tiền',
              field: PhieuThuString.soTien,
              type: TrinaColumnType.number(),
              width: 100,
              titleRenderer:
                  (re) => DataGridTitleFilter(
                    isFilter: filters[re.column.field]!.isNotEmpty,
                    title: re.column.title,
                    onPressed: () {
                      onShowFilter(re.column.field, titleFiler: re.column.title, isNumber: true);
                    },
                  ),
              textAlign: TrinaColumnTextAlign.end,
              footerRenderer: (re) {
                return TrinaAggregateColumnFooter(
                  rendererContext: re,
                  type: TrinaAggregateColumnType.sum,
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  alignment: Alignment.centerRight,
                );
              },
            ),
            DataGridColumn(
              title: 'TK nợ',
              field: PhieuThuString.tkNo,
              type: TrinaColumnType.text(),
              width: 75,
              titleRenderer:
                  (re) => DataGridTitleFilter(
                    isFilter: filters[re.column.field]!.isNotEmpty,
                    title: re.column.title,
                    onPressed: () {
                      onShowFilter(re.column.field, titleFiler: re.column.title);
                    },
                  ),
              textAlign: TrinaColumnTextAlign.center,
            ),
            DataGridColumn(
              title: 'TK có',
              field: PhieuThuString.tkCo,
              type: TrinaColumnType.text(),
              width: 75,
              titleRenderer:
                  (re) => DataGridTitleFilter(
                    isFilter: filters[re.column.field]!.isNotEmpty,
                    title: re.column.title,
                    onPressed: () {
                      onShowFilter(re.column.field, titleFiler: re.column.title);
                    },
                  ),
              textAlign: TrinaColumnTextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
