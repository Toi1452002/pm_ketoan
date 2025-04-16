import 'dart:io';

import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:trina_grid/trina_grid.dart';
import '../../../../widgets/widgets.dart';

class PdfBangKeHangNhapView extends StatelessWidget {
  final String tuNgay;
  final String denNgay;
  final TrinaGridStateManager stateManager;
  PdfBangKeHangNhapView({super.key, required this.tuNgay, required this.denNgay, required this.stateManager});

  final _dateNow = Helper.dateNowDMY();
  final _pdfWidget = PdfWidget();

  @override
  Widget build(BuildContext context) {
    final x = pdfBangKeHangNhap(tN: tuNgay, dN: denNgay, dateNow: _dateNow, stateManager: stateManager);

    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          leading: [
            IconPrinter(
              onPressed: () async {
                _pdfWidget.onPrint(onLayout: x, format: _pdfWidget.pdfFormatPortrait);
              },
            ),
          ],
        ),
      ],
      child: PdfPreview(
        maxPageWidth: 470,
        useActions: false,
        build: (context) {
          return x;
        },
      ),
    );
  }
}

Future<Uint8List> pdfBangKeHangNhap({
  required String tN,
  required String dN,
  required String dateNow,
  required TrinaGridStateManager stateManager,
}) async {
  final pdf = pw.Document();
  final pdfWidget = PdfWidget();
  final fonData = await pdfWidget.fontData();
  final fontBold = await pdfWidget.fontDataBold();
  final fontItalic = await pdfWidget.fontDataItalic();
  final lstData =
      stateManager.rows
          .map(
            (row) => BangKeHangNXModel(
              phieu: row.cells[PhieuNhapString.phieu]!.value.toString(),
              ngay: row.cells[PhieuNhapString.ngay]!.value.toString(),
              maKhach: row.cells[PhieuNhapString.maKhach]!.value.toString(),
              maNX: row.cells[PhieuNhapString.maNX]!.value.toString(),
              stt: 0,
              donGia: double.parse(row.cells[PhieuNhapCTString.donGia]!.value.toString()),
              dvt: row.cells[PhieuNhapCTString.dvt]!.value.toString(),
              maHang: row.cells[HangHoaString.maHH]!.value.toString(),
              soLg: double.parse(row.cells[PhieuNhapCTString.soLg]!.value.toString()),
              tenHang: row.cells[HangHoaString.tenHH]!.value.toString(),
              thanhTien: double.parse(row.cells[PhieuNhapCTString.thanhTien]!.value.toString()),
            ),
          )
          .toList();
  String tong = '0';
  if (lstData.isNotEmpty) {
    tong = Helper.numFormat(lstData.map((e) => e.thanhTien).reduce((a, b) => a + b))!;
  }

  pdf.addPage(
    pw.MultiPage(
      footer: (context) => pdfWidget.footer(dateNow, context, fontItalic),
      pageTheme: pdfWidget.pageTheme(font: fonData),
      build: (context) {
        return [
          pw.Center(
            child: pw.Column(
              children: [
                pdfWidget.title('BẢNG KÊ HÀNG NHẬP', fontBold),
                pw.SizedBox(height: 5),
                pdfWidget.label('Từ ngày $tN đến ngày $dN', fonData),
              ],
            ),
          ),
          pw.SizedBox(height: 5),
          pdfWidget.table(
            headerAlignments: {},
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.center,
              4: pw.Alignment.center,
              5: pw.Alignment.centerRight,
              6: pw.Alignment.centerRight,
              7: pw.Alignment.centerRight,
            },
            fontHeader: fontBold,

            columnWidths: {
              0: pw.FixedColumnWidth(30),
              1: pw.FixedColumnWidth(70),
              2: pw.FixedColumnWidth(80),
              3: pw.FixedColumnWidth(150),
              4: pw.FixedColumnWidth(70),
              5: pw.FixedColumnWidth(70),
              6: pw.FixedColumnWidth(80),
              7: pw.FixedColumnWidth(80),
            },
            border: pw.TableBorder.all(width: .5),
            headers: ['STT', 'Ngày', 'Mã hàng', 'Tên hàng', 'ĐVT', 'Số lg', 'Đơn giá', 'Thành tiền'],
            data: List.generate(lstData.length, (i) {
              final x = lstData[i];
              return [
                '${i + 1}',
                x.ngay,
                x.maHang,
                x.tenHang,
                x.dvt,
                Check().isInteger(x.soLg) ? x.soLg.toInt() :x.soLg,
                Helper.numFormat(x.donGia),
                Helper.numFormat(x.thanhTien),
              ];
            }),
          ),
          pw.Row(
            children: [
              pdfWidget.container('Tổng cộng', font: fontBold, width: 476,widthBorder: .5),
              pw.Expanded(child: pdfWidget.container(tong, font: fontBold,align: pw.Alignment.centerRight,widthBorder: .5)),
            ],
          ),
          pw.SizedBox(height: 30),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pdfWidget.textItalic('Người lập', fontItalic, fontSize: 13),
              pdfWidget.textItalic('Người duyệt', fontItalic, fontSize: 13),
            ],
          ),
        ];
      },
    ),
  );

  return pdf.save();
}
void excelBangKeHangNhap(TrinaGridStateManager stateManager) async {
  final lstData =
  stateManager.rows
      .map(
        (row) => BangKeHangNXModel(
      phieu: row.cells[PhieuNhapString.phieu]!.value.toString(),
      ngay: row.cells[PhieuNhapString.ngay]!.value.toString(),
      maKhach: row.cells[PhieuNhapString.maKhach]!.value.toString(),
      maNX: row.cells[PhieuNhapString.maNX]!.value.toString(),
      stt: 0,
      donGia: double.parse(row.cells[PhieuNhapCTString.donGia]!.value.toString()),
      dvt: row.cells[PhieuNhapCTString.dvt]!.value.toString(),
      maHang: row.cells[HangHoaString.maHH]!.value.toString(),
      soLg: double.parse(row.cells[PhieuNhapCTString.soLg]!.value.toString()),
      tenHang: row.cells[HangHoaString.tenHH]!.value.toString(),
      thanhTien: double.parse(row.cells[PhieuNhapCTString.thanhTien]!.value.toString()),
    ),
  )
      .toList();

  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];
  sheetObject.cell(CellIndex.indexByString("A1")).value = TextCellValue("STT");
  sheetObject.cell(CellIndex.indexByString("B1")).value = TextCellValue("Ngay");
  sheetObject.cell(CellIndex.indexByString("C1")).value = TextCellValue("MaHang");
  sheetObject.cell(CellIndex.indexByString("D1")).value = TextCellValue("TenHang");
  sheetObject.cell(CellIndex.indexByString("E1")).value = TextCellValue("ĐVT");
  sheetObject.cell(CellIndex.indexByString("F1")).value = TextCellValue("SoLuong");
  sheetObject.cell(CellIndex.indexByString("G1")).value = TextCellValue("DonGia");
  sheetObject.cell(CellIndex.indexByString("H1")).value = TextCellValue("ThanhTien");

  int i = 0;
  for (var e in lstData) {
    i += 1;
    sheetObject.cell(CellIndex.indexByString("A${i + 1}")).value = IntCellValue(i);
    sheetObject.cell(CellIndex.indexByString("B${i + 1}")).value = TextCellValue(e.ngay);
    sheetObject.cell(CellIndex.indexByString("C${i + 1}")).value = TextCellValue(e.maHang);
    sheetObject.cell(CellIndex.indexByString("D${i + 1}")).value = TextCellValue(e.tenHang);
    sheetObject.cell(CellIndex.indexByString("E${i + 1}")).value = TextCellValue(e.dvt);
    sheetObject.cell(CellIndex.indexByString("F${i + 1}")).value = DoubleCellValue(e.soLg);
    sheetObject.cell(CellIndex.indexByString("G${i + 1}")).value = DoubleCellValue(e.donGia);
    sheetObject.cell(CellIndex.indexByString("H${i + 1}")).value = DoubleCellValue(e.thanhTien);
  }

  final filePath = await getSaveLocation(
    suggestedName: "bangkehangnhap.xlsx",
    acceptedTypeGroups: [
      const XTypeGroup(label: 'Excel Files', extensions: ['xlsx']),
    ],
  );

  try {
    if (filePath != null) {
      final file = File(filePath.path);
      file.writeAsBytesSync(excel.encode()!);
    }
  } catch (e) {
    CustomAlert().error(e.toString());
  }
}