import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/views/muaban/muahang/component/pdf_bcmuahang.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../application/providers/phieunhap_provider.dart';
import '../../../core/core.dart';
import '../../../widgets/widgets.dart';

class BaoCaoMuaHangView extends ConsumerStatefulWidget {
  const BaoCaoMuaHangView({super.key});

  @override
  ConsumerState createState() => _BaoCaoMuaHangViewState();
}

class _BaoCaoMuaHangViewState extends ConsumerState<BaoCaoMuaHangView> {
  late TrinaGridStateManager _stateManager;
  String selected = "Quý";
  String quy = Helper.getQuarterNow();
  String thang = DateTime.now().month.toString();
  final txtNam = TextEditingController(text: DateTime.now().year.toString());

  Map<String, String> _mapThucHien = {
    'Select': 'Quý',
    'Quy': Helper.getQuarterNow(),
    'Thang': DateTime.now().month.toString(),
    'Nam': DateTime.now().year.toString(),
  };
  Map<String, List<dynamic>> filters = {
    PhieuNhapString.kyHieu: [],
    PhieuNhapString.ngayCT: [],
    PhieuNhapString.soCT: [],
    KhachHangString.tenKH: [],
    KhachHangString.mst: [],
    PhieuNhapString.congTien: [],
    PhieuNhapString.tienThue: [],
    PhieuNhapString.dienGiai: [],
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
    _stateManager.setFilter((TrinaRow row) {
      bool kyHieu =
          filters[PhieuNhapString.kyHieu]!.isEmpty ||
          filters[PhieuNhapString.kyHieu]!.contains(row.cells[PhieuNhapString.kyHieu]!.value);
      bool ngayCT =
          filters[PhieuNhapString.ngayCT]!.isEmpty ||
          filters[PhieuNhapString.ngayCT]!.contains(row.cells[PhieuNhapString.ngayCT]!.value);
      bool soHD =
          filters[PhieuNhapString.soCT]!.isEmpty ||
          filters[PhieuNhapString.soCT]!.contains(row.cells[PhieuNhapString.soCT]!.value);
      bool tenKH =
          filters[KhachHangString.tenKH]!.isEmpty ||
          filters[KhachHangString.tenKH]!.contains(row.cells[KhachHangString.tenKH]!.value);
      bool mst =
          filters[KhachHangString.mst]!.isEmpty ||
          filters[KhachHangString.mst]!.contains(row.cells[KhachHangString.mst]!.value);
      bool congTien =
          filters[PhieuNhapString.congTien]!.isEmpty ||
          filters[PhieuNhapString.congTien]!.contains(row.cells[PhieuNhapString.congTien]!.value);
      bool tienThue =
          filters[PhieuNhapString.tienThue]!.isEmpty ||
          filters[PhieuNhapString.tienThue]!.contains(row.cells[PhieuNhapString.tienThue]!.value);
      bool ghiChu =
          filters[PhieuNhapString.dienGiai]!.isEmpty ||
          filters[PhieuNhapString.dienGiai]!.contains(row.cells[PhieuNhapString.dienGiai]!.value);
      return kyHieu && ngayCT && soHD && tenKH && mst && congTien && tienThue && ghiChu;
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
    final qlXBC =
        ref.read(tuyChonProvider).firstWhere((e) => e.nhom == 'qlXBC').giaTri == 1; //Nếu bằng 1 thi xem bc truoc khi in
    ref.listen(bcPhieuNhapProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state.map((e) {
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: e.stt),
              PhieuNhapString.kyHieu: TrinaCell(value: e.kyHieu),
              PhieuNhapString.soCT: TrinaCell(value: e.soCT),
              PhieuNhapString.ngayCT: TrinaCell(value: e.ngayCT),
              KhachHangString.tenKH: TrinaCell(value: e.tenKH),
              KhachHangString.mst: TrinaCell(value: e.mst),
              PhieuNhapString.congTien: TrinaCell(value: e.congTien),
              PhieuNhapString.tienThue: TrinaCell(value: e.tienThue),
              PhieuNhapString.dienGiai: TrinaCell(value: e.dienGiai),
            },
          );
        }).toList(),
      );
    });
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          leading: [
            iconPrinter(
              onPressed: () async {
                if (qlXBC) {
                  showViewPrinter(context, PdfBCMuaHang(
                    stateManager: _stateManager,
                    dateNow: Helper.dateNowDMY(),
                    mapThucHien: _mapThucHien,
                  ),isPortrait: false);
                } else {
                  PdfWidget().onPrint(
                    onLayout: pdfBCMuaHang(
                      stateManager: _stateManager,
                      dateNow: Helper.dateNowDMY(),
                      mapThucHien: _mapThucHien,
                    ),
                    format: PdfPageFormat.a4.landscape,
                  );
                }
              },
            ),
            iconExcel(
              onPressed: () {
                excelBCMuaHang(_stateManager);
              },
            ),
            Gap(30),
            SizedBox(
              width: 130,
              child: LabelCombobox(
                selected: selected,
                items: [
                  ComboboxItem(value: 'Tháng', title: ['Tháng']),
                  ComboboxItem(value: 'Quý', title: ['Quý']),
                  ComboboxItem(value: 'Năm', title: ['Năm']),
                ],
                label: 'Chọn',
                readOnly: true,
                onChanged: (val, o) {
                  setState(() {
                    selected = val!;
                    quy = Helper.getQuarterNow();
                    thang = DateTime.now().month.toString();
                  });
                },
              ),
            ),
            Gap(10),
            SizedBox(
              width: 100,
              child:
                  !['Quý', 'Tháng'].contains(selected)
                      ? null
                      : LabelCombobox(
                        selected: selected == 'Quý' ? quy : thang,
                        items: List.generate(selected == 'Quý' ? 4 : 12, (index) {
                          return ComboboxItem(value: '${index + 1}', title: ['${index + 1}']);
                        }),
                        label: selected,
                        readOnly: false,
                        onChanged: (val, o) {
                          if (selected == "Quý") {
                            quy = val!;
                          } else {
                            thang = val!;
                          }
                          setState(() {});
                        },
                      ),
            ),
            Gap(10),
            SizedBox(width: 100, child: LabelTextfield(label: 'Năm', controller: txtNam, isNumber: true)),
            PrimaryButton(
              onPressed: () {
                ref
                    .read(bcPhieuNhapProvider.notifier)
                    .getBCPhieuNhap(
                      nam: txtNam.text,
                      thang: selected == 'Tháng' ? thang : null,
                      quy: selected == 'Quý' ? quy : null,
                    );
                setState(() {
                  filters = {
                    PhieuNhapString.kyHieu: [],
                    PhieuNhapString.ngayCT: [],
                    PhieuNhapString.soCT: [],
                    KhachHangString.tenKH: [],
                    KhachHangString.mst: [],
                    PhieuNhapString.congTien: [],
                    PhieuNhapString.tienThue: [],
                    PhieuNhapString.dienGiai: [],
                  };
                });

                _mapThucHien = {'Select': selected, 'Thang': thang, 'Quy': quy, 'Nam': txtNam.text};
              },
              size: ButtonSize(.8),
              child: Text('Thực hiện'),
            ),
          ],
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(5),
        child: DataGrid(
          onRowDoubleTap: (event) {
            if (event.cell.column.field == PhieuNhapString.soCT) {
              showMuaHang(context, stt: event.row.cells['null']!.value);
            }
          },
          onLoaded: (e) {
            e.stateManager.columnFooterHeight = 25;
            _stateManager = e.stateManager;
          },
          rows: [],
          columns: [
            DataGridColumn(
              title: '',
              field: 'null',
              titleRenderer: (re) => DataGridTitle(title: ''),
              type: TrinaColumnTypeText(),
              width: 20,
              renderer: (re) => DataGridContainer(),
              cellPadding: EdgeInsets.zero,
            ),
            DataGridColumn(
              title: 'Ký hiệu',
              width: 80,
              field: PhieuNhapString.kyHieu,
              type: TrinaColumnTypeText(),
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[PhieuNhapString.kyHieu]!.isNotEmpty,
                  title: re.column.title,
                  onPressed: () => onShowFilter(PhieuNhapString.kyHieu, titleFiler: 'KY HIEU'),
                );
              },
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
              title: 'Số HD',
              width: 80,
              field: PhieuNhapString.soCT,
              type: TrinaColumnTypeText(),
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[PhieuNhapString.soCT]!.isNotEmpty,

                  title: re.column.title,
                  onPressed: () => onShowFilter(PhieuNhapString.soCT, titleFiler: 'SO HD'),
                );
              },
              renderer: (re) {
                return Text(re.cell.value, style: TextStyle(color: Colors.red));
              },
            ),
            DataGridColumn(
              title: 'Ngày HD',
              width: 100,
              field: PhieuNhapString.ngayCT,
              type: TrinaColumnType.date(format: 'dd/MM/yyyy'),
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[PhieuNhapString.ngayCT]!.isNotEmpty,
                  title: re.column.title,
                  onPressed: () => onShowFilter(PhieuNhapString.ngayCT, titleFiler: 'NGAY HD', isNgay: true),
                );
              },
            ),
            DataGridColumn(
              title: 'Tên khách hàng',
              width: 300,
              field: KhachHangString.tenKH,
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[KhachHangString.tenKH]!.isNotEmpty,
                  title: re.column.title,
                  onPressed: () => onShowFilter(KhachHangString.tenKH, titleFiler: 'TEN KH'),
                );
              },
              type: TrinaColumnTypeText(),
            ),
            DataGridColumn(
              title: 'Mã số thuế',
              width: 120,
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[KhachHangString.mst]!.isNotEmpty,
                  title: re.column.title,
                  onPressed: () => onShowFilter(KhachHangString.mst, titleFiler: 'MST'),
                );
              },
              field: KhachHangString.mst,
              type: TrinaColumnTypeText(),
            ),
            DataGridColumn(
              title: 'Tiền chưa VAT',
              width: 120,
              field: PhieuNhapString.congTien,
              textAlign: TrinaColumnTextAlign.end,
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[PhieuNhapString.congTien]!.isNotEmpty,
                  title: re.column.title,
                  onPressed: () => onShowFilter(PhieuNhapString.congTien, titleFiler: 'TIEN CHUA VAT', isNumber: true),
                );
              },
              footerRenderer: (re) {
                return TrinaAggregateColumnFooter(
                  rendererContext: re,
                  type: TrinaAggregateColumnType.sum,
                  alignment: Alignment.centerRight,
                  titleSpanBuilder: (text) {
                    return [
                      TextSpan(text: text, style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                    ];
                  },
                );
              },
              type: TrinaColumnType.number(),
            ),
            DataGridColumn(
              title: 'Tiền thuế',
              width: 120,
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[PhieuNhapString.tienThue]!.isNotEmpty,
                  title: re.column.title,
                  onPressed: () => onShowFilter(PhieuNhapString.tienThue, titleFiler: 'TIEN THUE', isNumber: true),
                );
              },
              textAlign: TrinaColumnTextAlign.end,
              footerRenderer: (re) {
                return TrinaAggregateColumnFooter(
                  rendererContext: re,
                  type: TrinaAggregateColumnType.sum,
                  alignment: Alignment.centerRight,
                  titleSpanBuilder: (text) {
                    return [
                      TextSpan(text: text, style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                    ];
                  },
                );
              },
              field: PhieuNhapString.tienThue,
              type: TrinaColumnType.number(),
            ),
            DataGridColumn(
              title: 'Ghi chú',
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[PhieuNhapString.dienGiai]!.isNotEmpty,
                  title: re.column.title,
                  onPressed: () => onShowFilter(PhieuNhapString.dienGiai, titleFiler: 'GHI CHU'),
                );
              },
              width: 250,
              field: PhieuNhapString.dienGiai,
              type: TrinaColumnTypeText(),
            ),
          ],
        ),
      ),
    );
  }
}
