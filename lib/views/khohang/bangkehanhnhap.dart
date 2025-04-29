import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/views/khohang/component/pdf_bangkehangnhap.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../widgets/widgets.dart';

class BangKeHangNhapView extends ConsumerStatefulWidget {
  const BangKeHangNhapView({super.key});

  @override
  ConsumerState createState() => _BangKeHangNhapViewState();
}

class _BangKeHangNhapViewState extends ConsumerState<BangKeHangNhapView> {
  late TrinaGridStateManager _stateManager;
  DateTime tuNgay = DateTime.now().copyWith(day: 1);
  DateTime denNgay = DateTime.now();
  String strTuNgay = Helper.dateFormatDMY(DateTime.now().copyWith(day: 1));
  String strDenNgay = Helper.dateFormatDMY(DateTime.now());
  final TrinaGridFuntion trinaGridFuntion = TrinaGridFuntion();
  bool enabelFilter = false;
  Map<String, List<dynamic>> filters = {
    PhieuNhapString.ngay: [],
    PhieuNhapString.phieu: [],
    PhieuNhapString.maNX: [],
    PhieuNhapString.maKhach: [],
    HangHoaString.maHH: [],
    HangHoaString.tenHH: [],
    PhieuNhapCTString.dvt: [],
    PhieuNhapCTString.soLg: [],
    PhieuNhapCTString.donGia: [],
    PhieuNhapCTString.thanhTien: [],
  };

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
      PhieuNhapString.ngay: [],
      PhieuNhapString.phieu: [],
      PhieuNhapString.maNX: [],
      PhieuNhapString.maKhach: [],
      HangHoaString.maHH: [],
      HangHoaString.tenHH: [],
      PhieuNhapCTString.dvt: [],
      PhieuNhapCTString.soLg: [],
      PhieuNhapCTString.donGia: [],
      PhieuNhapCTString.thanhTien: [],
    };
    _applyFilters();
  }

  // Áp dụng bộ lọc cho tất cả cột
  void _applyFilters() {
    _stateManager.setFilter((row) {
      bool ngay =
          filters[PhieuNhapString.ngay]!.isEmpty ||
          filters[PhieuNhapString.ngay]!.contains(row.cells[PhieuNhapString.ngay]!.value);
      bool phieu =
          filters[PhieuNhapString.phieu]!.isEmpty ||
          filters[PhieuNhapString.phieu]!.contains(row.cells[PhieuNhapString.phieu]!.value);
      bool kieu =
          filters[PhieuNhapString.maNX]!.isEmpty ||
          filters[PhieuNhapString.maNX]!.contains(row.cells[PhieuNhapString.maNX]!.value);
      bool maKH =
          filters[PhieuNhapString.maKhach]!.isEmpty ||
          filters[PhieuNhapString.maKhach]!.contains(row.cells[PhieuNhapString.maKhach]!.value);
      bool maHH =
          filters[HangHoaString.maHH]!.isEmpty ||
          filters[HangHoaString.maHH]!.contains(row.cells[HangHoaString.maHH]!.value);
      bool tenHH =
          filters[HangHoaString.tenHH]!.isEmpty ||
          filters[HangHoaString.tenHH]!.contains(row.cells[HangHoaString.tenHH]!.value);
      bool dvt =
          filters[PhieuNhapCTString.dvt]!.isEmpty ||
          filters[PhieuNhapCTString.dvt]!.contains(row.cells[PhieuNhapCTString.dvt]!.value);
      bool soLg =
          filters[PhieuNhapCTString.soLg]!.isEmpty ||
          filters[PhieuNhapCTString.soLg]!.contains(row.cells[PhieuNhapCTString.soLg]!.value.toString());
      bool donGia =
          filters[PhieuNhapCTString.donGia]!.isEmpty ||
          filters[PhieuNhapCTString.donGia]!.contains(row.cells[PhieuNhapCTString.donGia]!.value.toString());
      bool thanhTien =
          filters[PhieuNhapCTString.thanhTien]!.isEmpty ||
          filters[PhieuNhapCTString.thanhTien]!.contains(row.cells[PhieuNhapCTString.thanhTien]!.value.toString());
      return ngay && phieu && kieu && maKH && maHH && tenHH && dvt && soLg && donGia && thanhTien;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(bangKePhieuNhapProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state.map((e) {
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: e.stt),
              PhieuNhapString.ngay: TrinaCell(value: Helper.stringFormatDMY(e.ngay)),
              PhieuNhapString.phieu: TrinaCell(value: e.phieu),
              PhieuNhapString.maNX: TrinaCell(value: e.maNX),
              PhieuNhapString.maKhach: TrinaCell(value: e.maKhach),
              HangHoaString.maHH: TrinaCell(value: e.maHang),
              HangHoaString.tenHH: TrinaCell(value: e.tenHang),
              PhieuNhapCTString.dvt: TrinaCell(value: e.dvt),
              PhieuNhapCTString.soLg: TrinaCell(value: e.soLg),
              PhieuNhapCTString.donGia: TrinaCell(value: e.donGia),
              PhieuNhapCTString.thanhTien: TrinaCell(value: e.thanhTien),
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
            IconPrinter(
              onPressed: () {
                final qlXBC =
                    ref.read(tuyChonProvider).firstWhere((e) => e.nhom == 'qlXBC').giaTri ==
                    1; //Nếu bằng 1 thi xem bc truoc khi in
                if (qlXBC) {
                  showViewPrinter(
                    context,
                    PdfBangKeHangNhapView(tuNgay: strTuNgay, denNgay: strDenNgay, stateManager: _stateManager),
                  );
                } else {
                  PdfWidget().onPrint(
                    onLayout: pdfBangKeHangNhap(
                      tN: strTuNgay,
                      dN: strDenNgay,
                      dateNow: Helper.dateNowDMY(),
                      stateManager: _stateManager,
                    ),
                  );
                }
              },
            ),
            IconExcel(
              onPressed: () {
                excelBangKeHangNhap(_stateManager);
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
                    .read(bangKePhieuNhapProvider.notifier)
                    .getBangKeHangNhap(tN: Helper.dateFormatYMD(tuNgay), dN: Helper.dateFormatYMD(denNgay));

                setState(() {
                  strTuNgay = Helper.dateFormatDMY(tuNgay);
                  strDenNgay = Helper.dateFormatDMY(denNgay);
                  filters = {
                    PhieuNhapString.ngay: [],
                    PhieuNhapString.phieu: [],
                    PhieuNhapString.maNX: [],
                    PhieuNhapString.maKhach: [],
                    HangHoaString.maHH: [],
                    HangHoaString.tenHH: [],
                    PhieuNhapCTString.dvt: [],
                    PhieuNhapCTString.soLg: [],
                    PhieuNhapCTString.donGia: [],
                    PhieuNhapCTString.thanhTien: [],
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
          onLoaded: (e) => _stateManager = e.stateManager,
          onRowDoubleTap: (event) {
            if (event.cell.column.field == PhieuNhapString.phieu) {
              showMuaHang(context, stt: event.row.cells['null']!.value);
            }
          },
          rows: [],
          columns: [
            DataGridColumn(
              title: '',
              field: 'null',
              type: TrinaColumnType.text(),
              cellPadding: EdgeInsets.zero,
              width: 25,
              renderer: (re) => DataGridContainer(text: "${re.rowIdx + 1}"),
              titleRenderer: (re) => DataGridTitle(title: ''),
            ),

            DataGridColumn(
              title: 'Ngày',
              field: PhieuNhapString.ngay,
              type: TrinaColumnType.text(),
              width: 80,
              titleRenderer: (re) => _buildTitle(re, isNgay: true),
            ),
            DataGridColumn(
              title: 'Phiếu',
              field: PhieuNhapString.phieu,
              type: TrinaColumnType.text(),
              width: 80,
              titleRenderer: (re) => _buildTitle(re),
              renderer: (re) => Text(re.cell.value, style: TextStyle(color: Colors.red)),
            ),
            DataGridColumn(
              title: 'Kiểu',
              field: PhieuNhapString.maNX,
              type: TrinaColumnType.text(),
              width: 70,
              titleRenderer: (re) => _buildTitle(re),
            ),
            DataGridColumn(
              title: 'Mã khách',
              field: PhieuNhapString.maKhach,
              type: TrinaColumnType.text(),
              width: 100,
              titleRenderer: (re) => _buildTitle(re),
            ),
            DataGridColumn(
              title: 'Mã hàng',
              field: HangHoaString.maHH,
              type: TrinaColumnType.text(),
              width: 120,
              titleRenderer: (re) => _buildTitle(re),
            ),
            DataGridColumn(
              title: 'Tên hàng',
              field: PhieuNhapCTString.tenHH,
              type: TrinaColumnType.text(),
              titleRenderer: (re) => _buildTitle(re),
            ),
            DataGridColumn(
              title: 'ĐVT',
              field: PhieuNhapCTString.dvt,
              type: TrinaColumnType.text(),
              width: 70,
              titleRenderer: (re) => _buildTitle(re),
            ),
            DataGridColumn(
              title: 'SoLg',
              field: PhieuNhapCTString.soLg,
              type: TrinaColumnType.number(allowFirstDot: true, format: '#,###.##'),
              width: 80,
              textAlign: TrinaColumnTextAlign.end,
              titleRenderer: (re) => _buildTitle(re, isNummber: true),
              footerRenderer: (re) => DataGridFooter(re),
            ),
            DataGridColumn(
              title: 'Đơn giá',
              field: PhieuNhapCTString.donGia,
              type: TrinaColumnType.number(),
              width: 100,
              textAlign: TrinaColumnTextAlign.end,
              titleRenderer: (re) => _buildTitle(re, isNummber: true),
              footerRenderer: (re) => DataGridFooter(re),
            ),
            DataGridColumn(
              title: 'Thành tiền',
              field: PhieuNhapCTString.thanhTien,
              type: TrinaColumnType.number(),
              width: 100,
              textAlign: TrinaColumnTextAlign.end,
              titleRenderer: (re) => _buildTitle(re, isNummber: true),
              footerRenderer: (re) => DataGridFooter(re),
            ),
          ],
        ),
      ),
    );
  }
}
