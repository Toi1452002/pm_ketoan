import 'dart:io';

import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/widgets/icon_button.dart';
import 'package:app_ketoan/widgets/widgets.dart';
import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PdfBCBanHang extends StatefulWidget {
  final TrinaGridStateManager stateManager;
  final String dateNow;
  final Map<String, String> mapThucHien;

  const PdfBCBanHang({super.key, required this.stateManager, required this.dateNow, required this.mapThucHien});

  @override
  State<PdfBCBanHang> createState() => _PdfBCBanHangState();
}

class _PdfBCBanHangState extends State<PdfBCBanHang> {
  final pdfWidget = PdfWidget();

  // final pdfFormat = PdfPageFormat.a4.landscape;
  @override
  Widget build(BuildContext context) {
    final x = pdfBCBanHang(stateManager: widget.stateManager, dateNow: widget.dateNow, mapThucHien: widget.mapThucHien);
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          leading: [
            iconPrinter(
              onPressed: () async {
                pdfWidget.onPrint(onLayout: x, format: pdfWidget.pdfFormatLandscape);
                // Printer print = const Printer(url: 'Microsoft Print to PDF');
                // await Printing.directPrintPdf(onLayout: (e) => x, format: pdfWidget.pdfFormatLandscape, printer: print);
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

Future<Uint8List> pdfBCBanHang({
  required TrinaGridStateManager stateManager,
  required String dateNow,
  required Map<String, String> mapThucHien,
}) async {
  final pdfWidget = PdfWidget();
  final fontData = await pdfWidget.fontData();
  final fontItalic = await pdfWidget.fontDataItalic();
  final fontBold = await pdfWidget.fontDataBold();
  final pdf = pw.Document();
  List<VBCPhieuXuatModel> lstBaoCao =
      stateManager.rows.map((row) {
        return VBCPhieuXuatModel(
          stt: 0,
          kyHieu: row.cells[PhieuXuatString.kyHieu]!.value.toString(),
          soHD: row.cells[PhieuXuatString.soHD]!.value.toString(),
          ngayCT: row.cells[PhieuXuatString.ngayCT]!.value.toString(),
          tenKH: row.cells['TenKH']!.value.toString(),
          mst: row.cells['MST']!.value.toString(),
          congTien: double.parse(row.cells[PhieuXuatString.congTien]!.value.toString()),
          tienThue: double.parse(row.cells[PhieuXuatString.tienThue]!.value.toString()),
          dienGiai: row.cells[PhieuXuatString.dienGiai]!.value,
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
      pageTheme: pdfWidget.pageTheme(font: fontData, format: pdfWidget.pdfFormatLandscape),
      build: (context) {
        return [
          pw.Center(child: pdfWidget.title('BẢNG KÊ HÓA ĐƠN HÀNG HÓA DỊCH VỤ BÁN RA', fontBold)),
          pw.SizedBox(height: 5),
          pw.Center(child: pw.Text('Từ ngày $tu Đến ngày $den')),
          pw.SizedBox(height: 10),
          pdfWidget.table(
            fontHeader: fontBold,
            data: List.generate(lstBaoCao.length, (i) {
              final x = lstBaoCao[i];
              return ["${i + 1}", x.kyHieu, x.soHD, x.ngayCT, x.tenKH, x.mst, Helper.numFormat(x.congTien), x.dienGiai];
            }),
            border: pw.TableBorder.all(width: .5, color: PdfColors.black),
            headerAlignments: {
              6: pw.Alignment.center
            },
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
          ),
          pw.Row(
            children: [
              pdfWidget.container('Tổng cộng', width: 553.5, font: fontBold, widthBorder: .5),
              pdfWidget.container(tongTien, width: 85.8, widthBorder: .5,align: pw.Alignment.centerRight),
              pw.Expanded(child: pdfWidget.container('', widthBorder: .5)),
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

void excelBCBanHang(TrinaGridStateManager stateManager) async {
  final lstBCBanHang =
      stateManager.rows.map((row) {
        return VBCPhieuXuatModel(
          stt: 0,
          kyHieu: row.cells[PhieuXuatString.kyHieu]!.value.toString(),
          soHD: row.cells[PhieuXuatString.soHD]!.value.toString(),
          ngayCT: row.cells[PhieuXuatString.ngayCT]!.value.toString(),
          tenKH: row.cells['TenKH']!.value.toString(),
          mst: row.cells['MST']!.value.toString(),
          congTien: double.parse(row.cells[PhieuXuatString.congTien]!.value.toString()),
          tienThue: double.parse(row.cells[PhieuXuatString.tienThue]!.value.toString()),
          dienGiai: row.cells[PhieuXuatString.dienGiai]!.value,
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
    sheetObject.cell(CellIndex.indexByString("C${i + 1}")).value = TextCellValue(e.soHD);
    sheetObject.cell(CellIndex.indexByString("D${i + 1}")).value = TextCellValue(e.ngayCT);
    sheetObject.cell(CellIndex.indexByString("E${i + 1}")).value = TextCellValue(e.tenKH);
    sheetObject.cell(CellIndex.indexByString("F${i + 1}")).value = TextCellValue(e.mst);
    sheetObject.cell(CellIndex.indexByString("G${i + 1}")).value = DoubleCellValue(e.congTien);
    sheetObject.cell(CellIndex.indexByString("H${i + 1}")).value = TextCellValue(e.dienGiai);
  }

  final filePath = await getSaveLocation(
    suggestedName: "bangkephieuxuat.xlsx",
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
