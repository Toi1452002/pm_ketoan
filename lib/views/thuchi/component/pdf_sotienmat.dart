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

class PdfSoTienMatView extends StatelessWidget {
  final String tuNgay;
  final String denNgay;
  final String tenCTY;
  final String diaChi;
  final String sdDK;
  final String sdCK;
  final TrinaGridStateManager stateManager;

  PdfSoTienMatView({
    super.key,
    required this.tuNgay,
    required this.denNgay,
    required this.stateManager,
    required this.diaChi,
    required this.tenCTY,
    required this.sdDK,
    required this.sdCK
  });

  final _dateNow = Helper.dateNowDMY();
  final _pdfWidget = PdfWidget();

  @override
  Widget build(BuildContext context) {
    final x = pdfSoTienMat(
      tN: tuNgay,
      dN: denNgay,
      dateNow: _dateNow,
      stateManager: stateManager,
      tenCTy: tenCTY,
      diaChi: diaChi,
      sdDK: sdDK,sdCK: sdCK
    );
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          leading: [
            IconPrinter(
              onPressed: () async {
                _pdfWidget.onPrint(onLayout: x, format: _pdfWidget.pdfFormatLandscape);
              },
            ),
          ],
        ),
      ],
      child: PdfPreview(
        maxPageWidth: 900,
        useActions: false,
        build: (context) {
          return x;
        },
      ),
    );
  }
}

Future<Uint8List> pdfSoTienMat({
  required String tN,
  required String dN,
  required String dateNow,
  required String tenCTy,
  required String diaChi,
  required String sdDK,
  required String sdCK,
  required TrinaGridStateManager stateManager,
}) async {
  final pdf = pw.Document();
  final pdfWidget = PdfWidget();
  final fonData = await pdfWidget.fontData();
  final fontBold = await pdfWidget.fontDataBold();
  final fontItalic = await pdfWidget.fontDataItalic();

  final data =
      stateManager.rows.map((e) {
        return SoTienModel(
          ngay: e.cells[SoTienString.ngay]!.value,
          phieu: e.cells[SoTienString.phieu]!.value,
          noiDung: e.cells[SoTienString.noiDung]!.value,
          kieu: '',
          pttt: '',
          soCT: e.cells[SoTienString.soCT]!.value,
          tkdu: e.cells[SoTienString.tkDU]!.value,
          thu: double.parse(e.cells[SoTienString.thu]!.value.toString()),
          chi: double.parse(e.cells[SoTienString.chi]!.value.toString()),
          stt: 0,
        );
      }).toList();

  String tongThu = '0';
  String tongChi = '0';
  if (data.isNotEmpty) {
    tongThu = Helper.numFormat(data.map((e) => e.thu).reduce((a, b) => a + b))!;
    tongChi = Helper.numFormat(data.map((e) => e.chi).reduce((a, b) => a + b))!;
  }

  pdf.addPage(
    pw.MultiPage(
      footer: (context)=>pdfWidget.footer(dateNow, context, fontItalic,isPortrait: false),
      pageTheme: pdfWidget.pageTheme(font: fonData, format: PdfPageFormat.a4.landscape),
      build: (context) {
        return [
          pw.Row(
            children: [
              pw.Container(
                width: 300,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [pw.Text('Đơn vị: $tenCTy'), pw.Text('Địa chỉ: $diaChi', softWrap: true)],
                ),
              ),
              pw.Spacer(),
              // pw.SizedBox(width: 100),
              pw.Expanded(
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('Mẫu số: S05b-DNN', style: pw.TextStyle(font: fontBold)),
                    pw.Text('(Ban hành theo quyết định số 48/2006/QĐ-BTC/CĐKT'),
                    pw.Text('ngày 14/09/2006 của Bộ trưởng BTC)'),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Column(
              children: [
                pdfWidget.title('SỔ CHI TIẾT QUỸ TIỀN MẶT', fontBold),
                pw.SizedBox(height: 5),
                pdfWidget.label('Từ ngày $tN đến ngày $dN', fonData),
              ],
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children:[
              pdfWidget.textItalic('Loại tiền: VNĐ', fontItalic),
              pw.SizedBox(width: 5),
            ]
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              pdfWidget.container('TT', width: 30, widthBorder: .5, height: 30, font: fontBold),
              pdfWidget.container(
                'Ngày tháng ghi sổ',
                width: 70,
                height: 30,
                widthBorder: .5,
                align: pw.Alignment.center,
                font: fontBold,
              ),
              pdfWidget.container('Số phiếu', width: 60, widthBorder: .5, height: 30, font: fontBold),
              pw.Column(
                children: [
                  pdfWidget.container('Chứng từ', width: 140, widthBorder: .5, height: 15, font: fontBold),
                  pw.Row(
                    children: [
                      pdfWidget.container('Số hiệu', width: 70, widthBorder: .5, height: 15, font: fontBold),
                      pdfWidget.container('Ngày tháng', width: 70, widthBorder: .5, height: 15, font: fontBold),
                    ],
                  ),
                ],
              ),
              pdfWidget.container('Diễn giải', width: 210, widthBorder: .5, height: 30, font: fontBold),
              pdfWidget.container('TK đối ứng', width: 40, widthBorder: .5, height: 30, font: fontBold),
              pw.Column(
                children: [
                  pdfWidget.container('Số tiền', width: 240, widthBorder: .5, height: 15, font: fontBold),
                  pw.Row(
                    children: [
                      pdfWidget.container('Thu', width: 80, widthBorder: .5, height: 15, font: fontBold),
                      pdfWidget.container('Chi', width: 80, widthBorder: .5, height: 15, font: fontBold),
                      pdfWidget.container('Tồn', width: 80, widthBorder: .5, height: 15, font: fontBold),
                    ],
                  ),
                ],
              ),
            ],
          ),
          pw.Row(
            children: [
              pdfWidget.container('Số dư đầu kỳ',align: pw.Alignment.centerRight,widthBorder: .5,font: fontBold,width: 630),
              pdfWidget.container(sdDK,align: pw.Alignment.centerRight,widthBorder: .5,font: fontBold,width: 160),

            ]
          ),
          pdfWidget.table(
            border: pw.TableBorder.all(width: .5),
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.center,
              6: pw.Alignment.center,
              7: pw.Alignment.centerRight,
              8: pw.Alignment.centerRight,
            },
            columnWidths: {
              0: pw.FixedColumnWidth(30),
              1: pw.FixedColumnWidth(70),
              2: pw.FixedColumnWidth(60),
              3: pw.FixedColumnWidth(70),
              4: pw.FixedColumnWidth(70),
              5: pw.FixedColumnWidth(210),
              6: pw.FixedColumnWidth(40),
              7: pw.FixedColumnWidth(80),
              8: pw.FixedColumnWidth(80),
              9: pw.FixedColumnWidth(80),
            },
            data: List.generate(data.length, (i) {
              final x = data[i];
              return [
                '${i + 1}',
                x.ngay,
                x.phieu,
                x.soCT,
                x.ngay,
                x.noiDung,
                x.tkdu,
                Helper.numFormat(x.thu),
                Helper.numFormat(x.chi),
                x.kieu,
              ];
            }),
          ),
          pw.Row(
              children: [
                pdfWidget.container('Cộng phát sinh trong kỳ',align: pw.Alignment.centerRight,widthBorder: .5,font: fontBold,width: 550),
                pdfWidget.container(tongThu,align: pw.Alignment.centerRight,widthBorder: .5,font: fontBold,width: 80),
                pdfWidget.container(tongChi,align: pw.Alignment.centerRight,widthBorder: .5,font: fontBold,width: 80),
                pdfWidget.container('',align: pw.Alignment.centerRight,widthBorder: .5,font: fontBold,width: 80),

              ]
          ),
          pw.Row(
              children: [
                pdfWidget.container('Số dư cuối kỳ',align: pw.Alignment.centerRight,widthBorder: .5,font: fontBold,width: 630),
                pdfWidget.container(sdCK,align: pw.Alignment.centerRight,widthBorder: .5,font: fontBold,width: 160),

              ]
          ),
          pw.SizedBox(height: 10),
          pw.Padding(
            padding: pw.EdgeInsets.symmetric(horizontal: 10),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Column(
                  children: [
                    pdfWidget.textItalic('Người lập', fontItalic, fontSize: 11),
                    pdfWidget.textItalic('(Ký họ, tên)', fontItalic),
                  ],
                ),
                pw.Column(
                  children: [
                    pdfWidget.textItalic('Kế toán trưởng', fontItalic, fontSize: 11),
                    pdfWidget.textItalic('(Ký họ, tên)', fontItalic),
                  ],
                ),
                pw.Column(
                  children: [
                    pdfWidget.textItalic('Giám đốc', fontItalic, fontSize: 11),
                    pdfWidget.textItalic('(Ký họ, tên, đóng dấu)', fontItalic),
                  ],
                ),




              ],
            ),
          ),
        ];
      },
    ),
  );

  return pdf.save();
}
void excelSoTienMat(TrinaGridStateManager stateManager) async {
  final data =
  stateManager.rows.map((e) {
    return SoTienModel(
      ngay: e.cells[SoTienString.ngay]!.value,
      phieu: e.cells[SoTienString.phieu]!.value,
      noiDung: e.cells[SoTienString.noiDung]!.value,
      kieu: '',
      pttt: '',
      soCT: e.cells[SoTienString.soCT]!.value,
      tkdu: e.cells[SoTienString.tkDU]!.value,
      thu: double.parse(e.cells[SoTienString.thu]!.value.toString()),
      chi: double.parse(e.cells[SoTienString.chi]!.value.toString()),
      stt: 0,
    );
  }).toList();

  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];
  sheetObject.cell(CellIndex.indexByString("A1")).value = TextCellValue("STT");
  sheetObject.cell(CellIndex.indexByString("B1")).value = TextCellValue("Ngay");
  sheetObject.cell(CellIndex.indexByString("C1")).value = TextCellValue("Phieu");
  sheetObject.cell(CellIndex.indexByString("D1")).value = TextCellValue("DienGiai");
  // sheetObject.cell(CellIndex.indexByString("E1")).value = TextCellValue("TenKH");
  // sheetObject.cell(CellIndex.indexByString("F1")).value = TextCellValue("PTTT");
  sheetObject.cell(CellIndex.indexByString("E1")).value = TextCellValue("SoCT");
  sheetObject.cell(CellIndex.indexByString("F1")).value = TextCellValue("TKDU");
  sheetObject.cell(CellIndex.indexByString("G1")).value = TextCellValue("Thu");
  sheetObject.cell(CellIndex.indexByString("H1")).value = TextCellValue("Chi");

  int i = 0;
  for (var e in data) {
    i += 1;
    sheetObject.cell(CellIndex.indexByString("A${i + 1}")).value = IntCellValue(i);
    sheetObject.cell(CellIndex.indexByString("B${i + 1}")).value = TextCellValue(e.ngay);
    sheetObject.cell(CellIndex.indexByString("C${i + 1}")).value = TextCellValue(e.phieu);
    sheetObject.cell(CellIndex.indexByString("D${i + 1}")).value = TextCellValue(e.noiDung);
    sheetObject.cell(CellIndex.indexByString("E${i + 1}")).value = TextCellValue(e.soCT);
    sheetObject.cell(CellIndex.indexByString("F${i + 1}")).value = TextCellValue(e.tkdu);
    sheetObject.cell(CellIndex.indexByString("G${i + 1}")).value = DoubleCellValue(e.thu);
    sheetObject.cell(CellIndex.indexByString("H${i + 1}")).value = DoubleCellValue(e.chi);
  }

  final filePath = await getSaveLocation(
    suggestedName: "sotienmat.xlsx",
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
