import 'dart:io';

import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/widgets/icon_button.dart';
import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../widgets/widgets.dart';

class PdfBCMuaHang extends StatefulWidget {
  final TrinaGridStateManager stateManager;
  final String dateNow;
  final Map<String, String> mapThucHien;

  const PdfBCMuaHang({super.key, required this.stateManager, required this.dateNow, required this.mapThucHien});

  @override
  State<PdfBCMuaHang> createState() => _PdfBCMuaHangState();
}

class _PdfBCMuaHangState extends State<PdfBCMuaHang> {
  final pdfFormat = PdfPageFormat.a4.landscape;

  @override
  Widget build(BuildContext context) {
    final x = pdfBCMuaHang(stateManager: widget.stateManager, dateNow: widget.dateNow, mapThucHien: widget.mapThucHien);
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          leading: [
            iconPrinter(
              onPressed: () async {
                Printer print = const Printer(url: 'Microsoft Print to PDF');
                await Printing.directPrintPdf(onLayout: (e) => x, format: pdfFormat, printer: print);
              },
            ),
          ],
        ),
      ],
      child: PdfPreview(
        maxPageWidth: 900,
        useActions: false,
        build: (format) {
          return x;
        },
      ),
    );
  }
}

Future<Uint8List> pdfBCMuaHang({
  required TrinaGridStateManager stateManager,
  required String dateNow,
  required Map<String, String> mapThucHien,
}) async {
  final pdfWidget = PdfWidget();
  final fontData = await pdfWidget.fontData();
  final fontItalic = await pdfWidget.fontDataItalic();
  final fontBold = await pdfWidget.fontDataBold();
  final pdf = pw.Document();
  List<VBCPhieuNhapModel> lstBaoCao =
      stateManager.rows.map((row) {
        return VBCPhieuNhapModel(
          stt: 0,
          kyHieu: row.cells[PhieuNhapString.kyHieu]!.value.toString(),
          soCT: row.cells[PhieuNhapString.soCT]!.value.toString(),
          ngayCT: row.cells[PhieuNhapString.ngayCT]!.value.toString(),
          tenKH: row.cells['TenKH']!.value.toString(),
          mst: row.cells['MST']!.value.toString(),
          congTien: double.parse(row.cells[PhieuNhapString.congTien]!.value.toString()),
          tienThue: double.parse(row.cells[PhieuNhapString.tienThue]!.value.toString()),
          dienGiai: row.cells[PhieuNhapString.dienGiai]!.value,
        );
      }).toList();
  String tongTien = '0';
  if (lstBaoCao.isNotEmpty) {
    tongTien = Helper.numFormat(lstBaoCao.map((e) => e.congTien).reduce((a, b) => a + b)).toString();
  }

  String tu = '';
  String den = '';
  final mapTH = mapThucHien;
  final thang = mapTH['Thang'];
  final quy = mapTH['Quy'];
  final nam = mapTH['Nam'];
  if (mapTH['Select'] == 'Nam') {
    tu = '01/01/$nam';
    den = '31/12/$nam';
  }
  if (mapTH['Select'] == 'Tháng') {
    tu = '01/${Helper.formatMonth(thang)}/$nam';
    den = '${Helper.getLastDateInMonth(thang!, nam!)}/${Helper.formatMonth(thang)}/$nam';
  }
  if (mapTH['Select'] == 'Quý') {
    tu = '01/${mQuy[quy]?.first}/$nam';
    final lastDate = Helper.getLastDateInMonth(mQuy[quy]!.last, nam!);
    den = '$lastDate/${mQuy[quy]?.last}/$nam';
  }

  pdf.addPage(
    pw.MultiPage(
      footer:
          (context) => pw.Row(
            children: [
              pw.Align(
                child: pw.Text(dateNow, style: pw.TextStyle(font: fontItalic)),
                alignment: pw.Alignment.centerLeft,
              ),
              pw.Spacer(),
              pw.Align(child: pw.Text(context.pageLabel), alignment: pw.Alignment.centerRight),
            ],
          ),
      pageTheme: pdfWidget.pageTheme(format: pdfWidget.pdfFormatLandscape, font: fontData),
      build: (context) {
        return [
          pw.Center(child: pdfWidget.title('BẢNG KÊ HÓA ĐƠN HÀNG HÓA DỊCH VỤ MUA VÀO', fontBold)),
          pw.SizedBox(height: 5),
          pw.Center(child: pw.Text('Từ ngày $tu Đến ngày $den')),
          pw.SizedBox(height: 10),
          pdfWidget.table(
            border: pw.TableBorder.all(width: .5, color: PdfColors.black),
            headerAlignments: {6: pw.Alignment.center},
            cellAlignments: {0: pw.Alignment.center, 3: pw.Alignment.center, 6: pw.Alignment.centerRight},
            columnWidths: {
              0: const pw.FixedColumnWidth(30),
              1: const pw.FixedColumnWidth(70),
              2: const pw.FixedColumnWidth(70),
              3: const pw.FixedColumnWidth(70),
              4: const pw.FixedColumnWidth(250),
              5: const pw.FixedColumnWidth(90),
              6: const pw.FixedColumnWidth(90),
              7: const pw.FixedColumnWidth(160),
            },
            fontHeader: fontBold,
            headers: [
              'STT',
              'Ký hiệu',
              'Số CT',
              'Ngày tháng',
              'Họ tên người mua hàng',
              'MST người MH',
              'Thành tiền',
              'Ghi chú',
            ],
            data: List.generate(lstBaoCao.length, (i) {
              final x = lstBaoCao[i];
              return ["${i + 1}", x.kyHieu, x.soCT, x.ngayCT, x.tenKH, x.mst, Helper.numFormat(x.congTien), x.dienGiai];
            }),
          ),
          pw.Row(
            children: [
              pdfWidget.container('Tổng cộng',font: fontBold,widthBorder: .5,width: 553.5),
              pdfWidget.container(tongTien,width: 85.8,widthBorder: .5,font: fontBold,align: pw.Alignment.centerRight),
              pw.Expanded(
                child: pdfWidget.container('',widthBorder: .5),
              ),
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

void excelBCMuaHang(TrinaGridStateManager stateManager) async {
  final lstBCBanHang =
      stateManager.rows.map((row) {
        return VBCPhieuNhapModel(
          stt: 0,
          kyHieu: row.cells[PhieuNhapString.kyHieu]!.value.toString(),
          soCT: row.cells[PhieuNhapString.soCT]!.value.toString(),
          ngayCT: row.cells[PhieuNhapString.ngayCT]!.value.toString(),
          tenKH: row.cells['TenKH']!.value.toString(),
          mst: row.cells['MST']!.value.toString(),
          congTien: double.parse(row.cells[PhieuNhapString.congTien]!.value.toString()),
          tienThue: double.parse(row.cells[PhieuNhapString.tienThue]!.value.toString()),
          dienGiai: row.cells[PhieuNhapString.dienGiai]!.value,
        );
      }).toList();

  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];
  sheetObject.cell(CellIndex.indexByString("A1")).value = TextCellValue("STT");
  sheetObject.cell(CellIndex.indexByString("B1")).value = TextCellValue("KyHieu");
  sheetObject.cell(CellIndex.indexByString("C1")).value = TextCellValue("SoHD");
  sheetObject.cell(CellIndex.indexByString("D1")).value = TextCellValue("NgayThang");
  sheetObject.cell(CellIndex.indexByString("E1")).value = TextCellValue("TenKH");
  sheetObject.cell(CellIndex.indexByString("F1")).value = TextCellValue("MST");
  sheetObject.cell(CellIndex.indexByString("G1")).value = TextCellValue("ThanhTien");
  sheetObject.cell(CellIndex.indexByString("H1")).value = TextCellValue("GhiChu");

  int i = 0;
  for (var e in lstBCBanHang) {
    i += 1;
    sheetObject.cell(CellIndex.indexByString("A${i + 1}")).value = IntCellValue(i);
    sheetObject.cell(CellIndex.indexByString("B${i + 1}")).value = TextCellValue(e.kyHieu);
    sheetObject.cell(CellIndex.indexByString("C${i + 1}")).value = TextCellValue(e.soCT);
    sheetObject.cell(CellIndex.indexByString("D${i + 1}")).value = TextCellValue(e.ngayCT);
    sheetObject.cell(CellIndex.indexByString("E${i + 1}")).value = TextCellValue(e.tenKH);
    sheetObject.cell(CellIndex.indexByString("F${i + 1}")).value = TextCellValue(e.mst);
    sheetObject.cell(CellIndex.indexByString("G${i + 1}")).value = DoubleCellValue(e.congTien);
    sheetObject.cell(CellIndex.indexByString("H${i + 1}")).value = TextCellValue(e.dienGiai);
  }

  final filePath = await getSaveLocation(
    suggestedName: "bangkephieunhap.xlsx",
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
