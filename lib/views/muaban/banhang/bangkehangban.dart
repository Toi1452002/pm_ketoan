import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/widgets/icon_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../application/providers/tuychon_provider.dart';
import '../../../core/core.dart';
import '../../../widgets/widgets.dart';

class BangKeHangBanView extends ConsumerStatefulWidget {
  const BangKeHangBanView({super.key});

  @override
  ConsumerState createState() => _BangKeHangBanViewState();
}

class _BangKeHangBanViewState extends ConsumerState<BangKeHangBanView> {
  late TrinaGridStateManager _stateManager;
  String selected = "Quý";
  String quy = Helper.getQuarterNow();
  String thang = DateTime.now().month.toString();
  final txtNam = TextEditingController(text: DateTime.now().year.toString());
  final TrinaGridFuntion trinaGridFuntion = TrinaGridFuntion();
  bool enabelFilter = false;

  Map<String, String> _mapThucHien = {
    'Select': 'Quý',
    'Quy': Helper.getQuarterNow(),
    'Thang': DateTime.now().month.toString(),
    'Nam': DateTime.now().year.toString(),
  };

  Map<String, List<dynamic>> filters = {
    HangHoaString.maHH: [],
    HangHoaString.tenHH: [],
    PhieuXuatCTString.dvt: [],
    PhieuXuatCTString.soLg: [],
    PhieuXuatCTString.thanhTien: [],
    PhieuXuatString.thueSuat: [],
    PhieuXuatString.tienThue: [],
    PhieuXuatString.congTien: [],
  };

  // Áp dụng bộ lọc cho tất cả cột
  void _applyFilters() {
    _stateManager.setFilter((TrinaRow row) {
      bool maHH =
          filters[HangHoaString.maHH]!.isEmpty ||
          filters[HangHoaString.maHH]!.contains(row.cells[HangHoaString.maHH]!.value);
      bool tenHH =
          filters[HangHoaString.tenHH]!.isEmpty ||
          filters[HangHoaString.tenHH]!.contains(row.cells[HangHoaString.tenHH]!.value);
      bool dvt =
          filters[PhieuXuatCTString.dvt]!.isEmpty ||
          filters[PhieuXuatCTString.dvt]!.contains(row.cells[PhieuXuatCTString.dvt]!.value);
      bool soLg =
          filters[PhieuXuatCTString.soLg]!.isEmpty ||
          filters[PhieuXuatCTString.soLg]!.contains(row.cells[PhieuXuatCTString.soLg]!.value.toString());
      bool thanhTien =
          filters[PhieuXuatCTString.thanhTien]!.isEmpty ||
          filters[PhieuXuatCTString.thanhTien]!.contains(row.cells[PhieuXuatCTString.thanhTien]!.value.toString());
      bool thueSuat =
          filters[PhieuXuatString.thueSuat]!.isEmpty ||
          filters[PhieuXuatString.thueSuat]!.contains(row.cells[PhieuXuatString.thueSuat]!.value.toString());
      bool tienThue =
          filters[PhieuXuatString.tienThue]!.isEmpty ||
          filters[PhieuXuatString.tienThue]!.contains(row.cells[PhieuXuatString.tienThue]!.value.toString());
      bool congTien =
          filters[PhieuXuatString.congTien]!.isEmpty ||
          filters[PhieuXuatString.congTien]!.contains(row.cells[PhieuXuatString.congTien]!.value.toString());
      return maHH && tenHH && dvt && soLg && thanhTien && thueSuat && tienThue && congTien;
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

  void clearFilter() {
    filters = {
      HangHoaString.maHH: [],
      HangHoaString.tenHH: [],
      PhieuXuatCTString.dvt: [],
      PhieuXuatCTString.soLg: [],
      PhieuXuatCTString.thanhTien: [],
      PhieuXuatString.thueSuat: [],
      PhieuXuatString.tienThue: [],
      PhieuXuatString.congTien: [],
    };
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final qlXBC =
        ref.read(tuyChonProvider).firstWhere((e) => e.nhom == 'qlXBC').giaTri == 1; //Nếu bằng 1 thi xem bc truoc khi in

    ref.listen(vnxBangKeHangBanProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state
            .map(
              (e) => TrinaRow(
                cells: {
                  'null': TrinaCell(value: ''),
                  HangHoaString.maHH: TrinaCell(value: e.maHH),
                  HangHoaString.tenHH: TrinaCell(value: e.tenHH),
                  PhieuXuatCTString.dvt: TrinaCell(value: e.dvt),
                  PhieuXuatCTString.soLg: TrinaCell(value: e.soLg),
                  PhieuXuatCTString.thanhTien: TrinaCell(value: e.tienChuaVat),
                  PhieuXuatString.thueSuat: TrinaCell(value: e.thue),
                  PhieuXuatString.tienThue: TrinaCell(value: e.tienThue),
                  PhieuXuatString.congTien: TrinaCell(value: e.congTien),
                },
              ),
            )
            .toList(),
      );
    });
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          leading: [
            IconPrinter(
              onPressed: () async {
                // if(qlXBC){
                //   showViewPrinter(context, PdfBCBanHang(
                //     stateManager: _stateManager,
                //     dateNow: Helper.dateNowDMY(),
                //     mapThucHien: _mapThucHien,
                //   ),isPortrait: false);
                // }else{
                //   PdfWidget().onPrint(onLayout: pdfBCBanHang(
                //     stateManager: _stateManager,
                //     dateNow: Helper.dateNowDMY(),
                //     mapThucHien: _mapThucHien,
                //   ),format: PdfPageFormat.a4.landscape);
                // }
              },
            ),
            IconExcel(
              onPressed: () {
                // excelBCBanHang(_stateManager);
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
            SizedBox(
              width: 100,
              child: LabelTextfield(
                label: 'Năm',
                controller: txtNam,
                isNumber: true,
                textAlign: TextAlign.center,
                maxLength: 4,
              ),
            ),
            PrimaryButton(
              onPressed: () {
                ref
                    .read(vnxBangKeHangBanProvider.notifier)
                    .getBanKeHangBan(
                      nam: txtNam.text,
                      thang: selected == 'Tháng' ? thang : null,
                      quy: selected == 'Quý' ? quy : null,
                    );
                setState(() {});

                _mapThucHien = {'Select': selected, 'Thang': thang, 'Quy': quy, 'Nam': txtNam.text};
              },
              size: ButtonSize(.8),
              child: Text('Thực hiện'),
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
              cellPadding: EdgeInsets.zero,
              titleRenderer: (re) => DataGridTitle(title: ''),
              renderer: (re) => DataGridContainer(text: "${re.rowIdx + 1}"),
              width: 25,
            ),
            DataGridColumn(title: 'Mã hàng', field: HangHoaString.maHH, type: TrinaColumnType.text(), width: 100,titleRenderer: (re)=>_buildTitle(re)),
            DataGridColumn(title: 'Tên hàng', field: HangHoaString.tenHH, type: TrinaColumnType.text(), width: 300,titleRenderer: (re)=>_buildTitle(re)),
            DataGridColumn(
              title: 'ĐVT',
              field: PhieuXuatCTString.dvt,
              type: TrinaColumnType.text(),
              width: 80,
              textAlign: TrinaColumnTextAlign.center,
                titleRenderer: (re)=>_buildTitle(re)
            ),
            DataGridColumn(
              title: 'Số lg',
              field: PhieuXuatCTString.soLg,
              type: TrinaColumnType.number(),
              width: 80,
              textAlign: TrinaColumnTextAlign.end,
                titleRenderer: (re)=>_buildTitle(re,isNummber: true)
            ),
            DataGridColumn(
              title: 'Tiền chưa VAT',
              field: PhieuXuatCTString.thanhTien,
              type: TrinaColumnType.number(),
              textAlign: TrinaColumnTextAlign.end,
              width: 130,
              footerRenderer: (re) => DataGridFooter(re),
                titleRenderer: (re)=>_buildTitle(re,isNummber: true)
            ),
            DataGridColumn(
              title: 'Thuế',
              field: PhieuXuatString.thueSuat,
              type: TrinaColumnType.number(),
              renderer: (re) => Align(alignment: Alignment.centerRight, child: Text("${re.cell.value}%")),
              width: 100,
              textAlign: TrinaColumnTextAlign.end,
                titleRenderer: (re)=>_buildTitle(re,isNummber: true)
            ),
            DataGridColumn(
              title: 'Tiền Thuế',
              field: PhieuXuatString.tienThue,
              type: TrinaColumnType.number(),
              width: 130,
              textAlign: TrinaColumnTextAlign.end,
              footerRenderer: (re) => DataGridFooter(re),
                titleRenderer: (re)=>_buildTitle(re,isNummber: true)
            ),
            DataGridColumn(
              title: 'Cộng tiền',
              field: PhieuXuatString.congTien,
              type: TrinaColumnType.number(),
              width: 130,
              textAlign: TrinaColumnTextAlign.end,
              footerRenderer: (re) => DataGridFooter(re),
                titleRenderer: (re)=>_buildTitle(re,isNummber: true)
            ),
          ],
        ),
      ),
    );
  }
}
