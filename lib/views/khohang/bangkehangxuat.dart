import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../widgets/widgets.dart';
import 'component/pdf_bangkehangxuat.dart';

class BangKeHangXuatView extends ConsumerStatefulWidget {
  const BangKeHangXuatView({super.key});

  @override
  ConsumerState createState() => _BangKeHangXuatViewState();
}

class _BangKeHangXuatViewState extends ConsumerState<BangKeHangXuatView> {
  late TrinaGridStateManager _stateManager;
  DateTime tuNgay = DateTime.now().copyWith(day: 1);
  DateTime denNgay = DateTime.now();
  String strTuNgay = Helper.dateFormatDMY(DateTime.now().copyWith(day: 1));
  String strDenNgay = Helper.dateFormatDMY(DateTime.now());
  final TrinaGridFuntion trinaGridFuntion = TrinaGridFuntion();
  bool enabelFilter = false;

  Map<String, List<dynamic>> filters = {
    PhieuXuatString.ngay: [],
    PhieuXuatString.phieu: [],
    PhieuXuatString.maNX: [],
    PhieuXuatString.maKhach: [],
    HangHoaString.maHH: [],
    HangHoaString.tenHH: [],
    PhieuXuatCTString.dvt: [],
    PhieuXuatCTString.soLg: [],
    PhieuXuatCTString.donGia: [],
    PhieuXuatCTString.thanhTien: [],
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
      PhieuXuatString.ngay: [],
      PhieuXuatString.phieu: [],
      PhieuXuatString.maNX: [],
      PhieuXuatString.maKhach: [],
      HangHoaString.maHH: [],
      HangHoaString.tenHH: [],
      PhieuXuatCTString.dvt: [],
      PhieuXuatCTString.soLg: [],
      PhieuXuatCTString.donGia: [],
      PhieuXuatCTString.thanhTien: [],
    };
    _applyFilters();
  }

  // Áp dụng bộ lọc cho tất cả cột
  void _applyFilters() {
    _stateManager.setFilter((row) {
      bool ngay =
          filters[PhieuXuatString.ngay]!.isEmpty ||
          filters[PhieuXuatString.ngay]!.contains(row.cells[PhieuXuatString.ngay]!.value);
      bool phieu =
          filters[PhieuXuatString.phieu]!.isEmpty ||
          filters[PhieuXuatString.phieu]!.contains(row.cells[PhieuXuatString.phieu]!.value);
      bool kieu =
          filters[PhieuXuatString.maNX]!.isEmpty ||
          filters[PhieuXuatString.maNX]!.contains(row.cells[PhieuXuatString.maNX]!.value);
      bool maKH =
          filters[PhieuXuatString.maKhach]!.isEmpty ||
          filters[PhieuXuatString.maKhach]!.contains(row.cells[PhieuXuatString.maKhach]!.value);
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
          filters[PhieuXuatCTString.soLg]!.contains(row.cells[PhieuXuatCTString.soLg]!.value);
      bool donGia =
          filters[PhieuXuatCTString.donGia]!.isEmpty ||
          filters[PhieuXuatCTString.donGia]!.contains(row.cells[PhieuXuatCTString.donGia]!.value);
      bool thanhTien =
          filters[PhieuXuatCTString.thanhTien]!.isEmpty ||
          filters[PhieuXuatCTString.thanhTien]!.contains(row.cells[PhieuXuatCTString.thanhTien]!.value);
      return ngay && phieu && kieu && maKH && maHH && tenHH && dvt && soLg && donGia && thanhTien;
    });
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    ref.listen(bangKePhieuXuatProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state.map((e) {
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: e.stt),
              PhieuXuatString.ngay: TrinaCell(value: Helper.stringFormatDMY(e.ngay)),
              PhieuXuatString.phieu: TrinaCell(value: e.phieu),
              PhieuXuatString.maNX: TrinaCell(value: e.maNX),
              PhieuXuatString.maKhach: TrinaCell(value: e.maKhach),
              HangHoaString.maHH: TrinaCell(value: e.maHang),
              HangHoaString.tenHH: TrinaCell(value: e.tenHang),
              PhieuXuatCTString.dvt: TrinaCell(value: e.dvt),
              PhieuXuatCTString.soLg: TrinaCell(value: e.soLg),
              PhieuXuatCTString.donGia: TrinaCell(value: e.donGia),
              PhieuXuatCTString.thanhTien: TrinaCell(value: e.thanhTien),
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
                    PdfBangKeHangXuatView(tuNgay: strTuNgay, denNgay: strDenNgay, stateManager: _stateManager),
                  );
                } else {
                  PdfWidget().onPrint(
                    onLayout: pdfBangKeHangXuat(
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
                excelBangKeHangXuat(_stateManager);
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
                    .read(bangKePhieuXuatProvider.notifier)
                    .getBangKeHangXuat(tN: Helper.dateFormatYMD(tuNgay), dN: Helper.dateFormatYMD(denNgay));

                setState(() {
                  strTuNgay = Helper.dateFormatDMY(tuNgay);
                  strDenNgay = Helper.dateFormatDMY(denNgay);
                  filters = {
                    PhieuXuatString.ngay: [],
                    PhieuXuatString.phieu: [],
                    PhieuXuatString.maNX: [],
                    PhieuXuatString.maKhach: [],
                    HangHoaString.maHH: [],
                    HangHoaString.tenHH: [],
                    PhieuXuatCTString.dvt: [],
                    PhieuXuatCTString.soLg: [],
                    PhieuXuatCTString.donGia: [],
                    PhieuXuatCTString.thanhTien: [],
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
              field: PhieuXuatString.ngay,
              type: TrinaColumnType.text(),
              width: 80,
              titleRenderer: (re)=>_buildTitle(re,isNgay: true),
            ),
            DataGridColumn(
              title: 'Phiếu',
              field: PhieuXuatString.phieu,
              type: TrinaColumnType.text(),
              width: 80,
              titleRenderer: (re)=>_buildTitle(re),
            ),
            DataGridColumn(
              title: 'Kiểu',
              field: PhieuXuatString.maNX,
              type: TrinaColumnType.text(),
              width: 70,
              titleRenderer: (re)=>_buildTitle(re),
            ),
            DataGridColumn(
              title: 'Mã khách',
              field: PhieuXuatString.maKhach,
              type: TrinaColumnType.text(),
              width: 100,
              titleRenderer: (re)=>_buildTitle(re),
            ),
            DataGridColumn(
              title: 'Mã hàng',
              field: HangHoaString.maHH,
              type: TrinaColumnType.text(),
              width: 120,
              titleRenderer: (re)=>_buildTitle(re),
            ),
            DataGridColumn(
              title: 'Tên hàng',
              field: PhieuXuatCTString.tenHH,
              type: TrinaColumnType.text(),
              titleRenderer: (re)=>_buildTitle(re),
            ),
            DataGridColumn(
              title: 'ĐVT',
              field: PhieuXuatCTString.dvt,
              type: TrinaColumnType.text(),
              width: 70,
              titleRenderer: (re)=>_buildTitle(re),
            ),
            DataGridColumn(
              title: 'SoLg',
              field: PhieuXuatCTString.soLg,
              type: TrinaColumnType.number(allowFirstDot: true, format: '#,###.##'),
              width: 80,
              textAlign: TrinaColumnTextAlign.end,

              titleRenderer: (re)=>_buildTitle(re,isNummber: true),
              footerRenderer:
                  (re) => TrinaAggregateColumnFooter(
                    rendererContext: re,
                    type: TrinaAggregateColumnType.sum,
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    alignment: Alignment.centerRight,
                    format: '#,###.##',
                  ),
            ),
            DataGridColumn(
              title: 'Đơn giá',
              field: PhieuXuatCTString.donGia,
              type: TrinaColumnType.number(),
              width: 100,
              textAlign: TrinaColumnTextAlign.end,
              titleRenderer: (re)=>_buildTitle(re,isNummber: true),
              footerRenderer:
                  (re) => TrinaAggregateColumnFooter(
                rendererContext: re,
                type: TrinaAggregateColumnType.sum,
                padding: EdgeInsets.symmetric(horizontal: 3),
                alignment: Alignment.centerRight,
              ),
            ),
            DataGridColumn(
              title: 'Thành tiền',
              field: PhieuXuatCTString.thanhTien,
              type: TrinaColumnType.number(),
              width: 100,
              textAlign: TrinaColumnTextAlign.end,
              titleRenderer: (re)=>_buildTitle(re,isNummber: true),
              footerRenderer:
                  (re) => TrinaAggregateColumnFooter(
                rendererContext: re,
                type: TrinaAggregateColumnType.sum,
                padding: EdgeInsets.symmetric(horizontal: 3),
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
