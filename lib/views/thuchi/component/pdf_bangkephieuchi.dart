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

class PdfBangKePhieuChiView extends StatelessWidget {
  final String tuNgay;
  final String denNgay;
  final TrinaGridStateManager stateManager;

  PdfBangKePhieuChiView({super.key, required this.tuNgay, required this.denNgay, required this.stateManager});

  final _dateNow = Helper.dateNowDMY();
  final _pdfWidget = PdfWidget();

  @override
  Widget build(BuildContext context) {
    final x = pdfBangKePhieuChi(tN: tuNgay, dN: denNgay, dateNow: _dateNow, stateManager: stateManager);
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

Future<Uint8List> pdfBangKePhieuChi({
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
        (row) => PhieuChiModel(
      phieu: row.cells[PhieuChiString.phieu]!.value.toString(),
      ngay: row.cells[PhieuChiString.ngay]!.value.toString(),
      maKhach: row.cells[PhieuChiString.maKhach]!.value.toString(),
      tenKhach: row.cells[PhieuChiString.tenKhach]!.value.toString(),
      pttt: row.cells[PhieuChiString.pttt]!.value.toString(),
      soTien: double.parse(row.cells[PhieuChiString.soTien]!.value.toString()),
      noiDung: row.cells[PhieuChiString.noiDung]!.value,
      khoa: false,
      soCT: '',
      tkNo: '',
      tkCo: '',
    ),
  )
      .toList();

  String tong = '0';
  if (lstData.isNotEmpty) {
    tong = Helper.numFormat(lstData.map((e) => e.soTien).reduce((a, b) => a! + b!))!;
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
                pdfWidget.title('BẢNG KÊ PHIẾU CHI', fontBold),
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
              2: pw.Alignment.center,
              5: pw.Alignment.center,
              6: pw.Alignment.centerRight,
            },
            fontHeader: fontBold,

            columnWidths: {
              0: pw.FixedColumnWidth(30),
              1: pw.FixedColumnWidth(70),
              2: pw.FixedColumnWidth(50),
              3: pw.FixedColumnWidth(50),
              4: pw.FixedColumnWidth(120),
              5: pw.FixedColumnWidth(30),
              6: pw.FixedColumnWidth(70),
              7: pw.FixedColumnWidth(125),
            },
            border: pw.TableBorder.all(width: .5),
            headers: ['STT', 'Ngày', 'Phiếu', 'Mã NC', 'Tên nhà cung', 'PTTT', 'Số tiền', 'Nội dung'],
            data: List.generate(lstData.length, (i) {
              final x = lstData[i];
              return [
                '${i + 1}',
                x.ngay,
                x.phieu,
                x.maKhach,
                x.tenKhach,
                x.pttt,
                Helper.numFormat(x.soTien),
                x.noiDung,
              ];
            }),
          ),
          pw.Row(
            children: [
              pdfWidget.container('Tổng cộng', font: fontBold, width: 350,widthBorder: .5),
              pdfWidget.container(tong, font: fontBold, width: 70,align: pw.Alignment.centerRight,widthBorder: .5),
              pdfWidget.container('', font: fontBold, width: 125,widthBorder: .5),
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
void excelBangKePhieuChi(TrinaGridStateManager stateManager) async {
  final lstData =
  stateManager.rows
      .map(
        (row) => PhieuChiModel(
      phieu: row.cells[PhieuChiString.phieu]!.value.toString(),
      ngay: row.cells[PhieuChiString.ngay]!.value.toString(),
      maKhach: row.cells[PhieuChiString.maKhach]!.value.toString(),
      tenKhach: row.cells[PhieuChiString.tenKhach]!.value.toString(),
      pttt: row.cells[PhieuChiString.pttt]!.value.toString(),
      soTien: double.parse(row.cells[PhieuChiString.soTien]!.value.toString()),
      noiDung: row.cells[PhieuChiString.noiDung]!.value,
      khoa: false,
      soCT: '',
      tkNo: '',
      tkCo: '',
    ),
  )
      .toList();

  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];
  sheetObject.cell(CellIndex.indexByString("A1")).value = TextCellValue("STT");
  sheetObject.cell(CellIndex.indexByString("B1")).value = TextCellValue("Ngay");
  sheetObject.cell(CellIndex.indexByString("C1")).value = TextCellValue("Phieu");
  sheetObject.cell(CellIndex.indexByString("D1")).value = TextCellValue("MaKH");
  sheetObject.cell(CellIndex.indexByString("E1")).value = TextCellValue("TenKH");
  sheetObject.cell(CellIndex.indexByString("F1")).value = TextCellValue("PTTT");
  sheetObject.cell(CellIndex.indexByString("G1")).value = TextCellValue("SoTien");
  sheetObject.cell(CellIndex.indexByString("H1")).value = TextCellValue("NoiDung");

  int i = 0;
  for (var e in lstData) {
    i += 1;
    sheetObject.cell(CellIndex.indexByString("A${i + 1}")).value = IntCellValue(i);
    sheetObject.cell(CellIndex.indexByString("B${i + 1}")).value = TextCellValue(e.ngay!);
    sheetObject.cell(CellIndex.indexByString("C${i + 1}")).value = TextCellValue(e.phieu);
    sheetObject.cell(CellIndex.indexByString("D${i + 1}")).value = TextCellValue(e.maKhach!);
    sheetObject.cell(CellIndex.indexByString("E${i + 1}")).value = TextCellValue(e.tenKhach!);
    sheetObject.cell(CellIndex.indexByString("F${i + 1}")).value = TextCellValue(e.pttt!);
    sheetObject.cell(CellIndex.indexByString("G${i + 1}")).value = DoubleCellValue(e.soTien!);
    sheetObject.cell(CellIndex.indexByString("H${i + 1}")).value = TextCellValue(e.noiDung!);
  }

  final filePath = await getSaveLocation(
    suggestedName: "bangkephieuchi.xlsx",
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
