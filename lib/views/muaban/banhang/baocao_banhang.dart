import 'package:app_ketoan/application/providers/phieuxuat_provider.dart';
import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/views/muaban/banhang/component/pdf_bcbanhang.dart';
import 'package:printing/printing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../application/application.dart';
import '../../../data/data.dart';
import '../../../widgets/widgets.dart';

class BaoCaoBanHangView extends ConsumerStatefulWidget {
  const BaoCaoBanHangView({super.key});

  @override
  ConsumerState createState() => _BaoCaoBanHangViewState();
}

class _BaoCaoBanHangViewState extends ConsumerState<BaoCaoBanHangView> {
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
    PhieuXuatString.kyHieu: [],
    PhieuXuatString.ngayCT: [],
    PhieuXuatString.soHD: [],
    KhachHangString.tenKH: [],
    KhachHangString.mst: [],
    PhieuXuatString.congTien: [],
    PhieuXuatString.tienThue: [],
    PhieuXuatString.dienGiai: [],
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
          filters[PhieuXuatString.kyHieu]!.isEmpty ||
          filters[PhieuXuatString.kyHieu]!.contains(row.cells[PhieuXuatString.kyHieu]!.value);
      bool ngayCT =
          filters[PhieuXuatString.ngayCT]!.isEmpty ||
          filters[PhieuXuatString.ngayCT]!.contains(row.cells[PhieuXuatString.ngayCT]!.value);
      bool soHD =
          filters[PhieuXuatString.soHD]!.isEmpty ||
          filters[PhieuXuatString.soHD]!.contains(row.cells[PhieuXuatString.soHD]!.value);
      bool tenKH =
          filters[KhachHangString.tenKH]!.isEmpty ||
          filters[KhachHangString.tenKH]!.contains(row.cells[KhachHangString.tenKH]!.value);
      bool mst =
          filters[KhachHangString.mst]!.isEmpty ||
          filters[KhachHangString.mst]!.contains(row.cells[KhachHangString.mst]!.value);
      bool congTien =
          filters[PhieuXuatString.congTien]!.isEmpty ||
          filters[PhieuXuatString.congTien]!.contains(row.cells[PhieuXuatString.congTien]!.value);
      bool tienThue =
          filters[PhieuXuatString.tienThue]!.isEmpty ||
          filters[PhieuXuatString.tienThue]!.contains(row.cells[PhieuXuatString.tienThue]!.value);
      bool ghiChu =
          filters[PhieuXuatString.dienGiai]!.isEmpty ||
          filters[PhieuXuatString.dienGiai]!.contains(row.cells[PhieuXuatString.dienGiai]!.value);
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
    final qlXBC = ref.read(tuyChonProvider).firstWhere((e)=>e.nhom=='qlXBC').giaTri==1;//Nếu bằng 1 thi xem bc truoc khi in

    ref.listen(bcPhieuXuatProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state.map((e) {
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: e.stt),
              PhieuXuatString.kyHieu: TrinaCell(value: e.kyHieu),
              PhieuXuatString.soHD: TrinaCell(value: e.soHD),
              PhieuXuatString.ngayCT: TrinaCell(value: e.ngayCT),
              KhachHangString.tenKH: TrinaCell(value: e.tenKH),
              KhachHangString.mst: TrinaCell(value: e.mst),
              PhieuXuatString.congTien: TrinaCell(value: e.congTien),
              PhieuXuatString.tienThue: TrinaCell(value: e.tienThue),
              PhieuXuatString.dienGiai: TrinaCell(value: e.dienGiai),
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
                if(qlXBC){
                  showViewPrinter(context, PdfBCBanHang(
                    stateManager: _stateManager,
                    dateNow: Helper.dateNowDMY(),
                    mapThucHien: _mapThucHien,
                  ),isPortrait: false);
                }else{
                  PdfWidget().onPrint(onLayout: pdfBCBanHang(
                    stateManager: _stateManager,
                    dateNow: Helper.dateNowDMY(),
                    mapThucHien: _mapThucHien,
                  ),format: PdfPageFormat.a4.landscape);
                }


              },
            ),
            iconExcel(onPressed: () {
              excelBCBanHang(_stateManager);
            }),
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
                    .read(bcPhieuXuatProvider.notifier)
                    .getBCPhieuXuat(
                      nam: txtNam.text,
                      thang: selected == 'Tháng' ? thang : null,
                      quy: selected == 'Quý' ? quy : null,
                    );
                setState(() {
                  filters = {
                    PhieuXuatString.kyHieu: [],
                    PhieuXuatString.ngayCT: [],
                    PhieuXuatString.soHD: [],
                    KhachHangString.tenKH: [],
                    KhachHangString.mst: [],
                    PhieuXuatString.congTien: [],
                    PhieuXuatString.tienThue: [],
                    PhieuXuatString.dienGiai: [],
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
            if (event.cell.column.field == PhieuXuatString.soHD) {
              showBanHang(context, stt: event.row.cells['null']!.value);
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
              type: TrinaColumnTypeText(),
              width: 20,
              renderer: (re) => DataGridContainer(),
              titleRenderer: (re) => DataGridTitle(title: ''),
              cellPadding: EdgeInsets.zero,
            ),
            DataGridColumn(
              title: 'Ký hiệu',
              width: 80,
              field: PhieuXuatString.kyHieu,
              type: TrinaColumnTypeText(),
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[PhieuXuatString.kyHieu]!.isNotEmpty,
                  title: re.column.title,
                  onPressed: () => onShowFilter(PhieuXuatString.kyHieu, titleFiler: 'KY HIEU'),
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
              field: PhieuXuatString.soHD,
              type: TrinaColumnTypeText(),
              renderer: (re) {
                return Text(re.cell.value, style: TextStyle(color: Colors.red));
              },
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[PhieuXuatString.soHD]!.isNotEmpty,

                  title: re.column.title,
                  onPressed: () => onShowFilter(PhieuXuatString.soHD, titleFiler: 'SO HD'),
                );
              },
            ),
            DataGridColumn(
              title: 'Ngày HD',
              width: 100,
              field: PhieuXuatString.ngayCT,
              type: TrinaColumnType.date(format: 'dd/MM/yyyy'),
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[PhieuXuatString.ngayCT]!.isNotEmpty,
                  title: re.column.title,
                  onPressed: () => onShowFilter(PhieuXuatString.ngayCT, titleFiler: 'NGAY HD', isNgay: true),
                );
              },
            ),
            DataGridColumn(
              title: 'Tên khách hàng',
              width: 300,
              field: KhachHangString.tenKH,
              type: TrinaColumnTypeText(),
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[KhachHangString.tenKH]!.isNotEmpty,
                  title: re.column.title,
                  onPressed: () => onShowFilter(KhachHangString.tenKH, titleFiler: 'TEN KH'),
                );
              },
            ),
            DataGridColumn(
              title: 'Mã số thuế',
              width: 120,
              field: KhachHangString.mst,
              type: TrinaColumnTypeText(),
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[KhachHangString.mst]!.isNotEmpty,
                  title: re.column.title,
                  onPressed: () => onShowFilter(KhachHangString.mst, titleFiler: 'MST'),
                );
              },
            ),
            DataGridColumn(
              title: 'Tiền chưa VAT',
              width: 120,
              field: PhieuXuatString.congTien,
              textAlign: TrinaColumnTextAlign.end,
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[PhieuXuatString.congTien]!.isNotEmpty,
                  title: re.column.title,
                  onPressed: () => onShowFilter(PhieuXuatString.congTien, titleFiler: 'TIEN CHUA VAT', isNumber: true),
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
              field: PhieuXuatString.tienThue,
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
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[PhieuXuatString.tienThue]!.isNotEmpty,
                  title: re.column.title,
                  onPressed: () => onShowFilter(PhieuXuatString.tienThue, titleFiler: 'TIEN THUE', isNumber: true),
                );
              },
              type: TrinaColumnType.number(),
            ),
            DataGridColumn(
              title: 'Ghi chú',
              width: 250,
              field: PhieuXuatString.dienGiai,
              type: TrinaColumnTypeText(),
              titleRenderer: (re) {
                return DataGridTitleFilter(
                  isFilter: filters[PhieuXuatString.dienGiai]!.isNotEmpty,
                  title: re.column.title,
                  onPressed: () => onShowFilter(PhieuXuatString.dienGiai, titleFiler: 'GHI CHU'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
