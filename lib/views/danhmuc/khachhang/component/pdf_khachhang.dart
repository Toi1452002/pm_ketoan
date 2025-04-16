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

class PdfKhachHangView extends StatelessWidget {
  final TrinaGridStateManager stateManager;

  PdfKhachHangView({super.key, required this.stateManager});

  final _pdfWidget = PdfWidget();
  final _dateNow = Helper.dateNowDMY();

  @override
  Widget build(BuildContext context) {
    final x = pdfKhachHang(dateNow: _dateNow, stateManager: stateManager);
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
        build: (format) {
          return x;
        },
      ),
    );
  }
}

Future<Uint8List> pdfKhachHang({required String dateNow, required TrinaGridStateManager stateManager}) async {
  final pdf = pw.Document();
  final pdfWidget = PdfWidget();
  final fonData = await pdfWidget.fontData();
  final fontBold = await pdfWidget.fontDataBold();
  final fontItalic = await pdfWidget.fontDataItalic();

  final data =
      stateManager.rows
          .map(
            (row) => KhachHangModel(
              maKhach: row.cells[KhachHangString.maKhach]?.value,
              tenKH: row.cells[KhachHangString.tenKH]?.value,
              dienThoai: row.cells[KhachHangString.dienThoai]?.value,
              diDong: row.cells[KhachHangString.diDong]?.value,
              diaChi: row.cells[KhachHangString.diaChi]?.value,
            ),
          )
          .toList();

  pdf.addPage(
    pw.MultiPage(
      pageTheme: pdfWidget.pageTheme(font: fonData,format: pdfWidget.pdfFormatLandscape),
      footer: (context) => pdfWidget.footer(dateNow, context, fontItalic,isPortrait: false),
      build: (context) {
        return [
          pw.Center(child: pdfWidget.title('DANH SÁCH KHÁCH HÀNG', fontBold)),
          pw.SizedBox(height: 10),
          pdfWidget.table(
            fontHeader: fontBold,
            border: pw.TableBorder.all(width: .5),
            cellAlignments: {0: pw.Alignment.center, 3: pw.Alignment.center, 4: pw.Alignment.centerRight},
            columnWidths: {
              0: pw.FixedColumnWidth(30),
              1: pw.FixedColumnWidth(70),
              2: pw.FixedColumnWidth(230),
              3: pw.FixedColumnWidth(100),
              4: pw.FixedColumnWidth(100),
              5: pw.FixedColumnWidth(280),
              // 4:pw.FixedColumnWidth(80),
            },

            headers: ['STT', 'Mã khách', 'Tên khách hàng', 'Điện thoại', 'Di động', 'Địa chỉ'],
            data: List.generate(data.length, (i) {
              final x = data[i];
              return ['${i + 1}', x.maKhach, x.tenKH, x.dienThoai, x.diDong, x.diaChi];
            }),
          ),
        ];
      },
    ),
  );

  return pdf.save();
}

void excelKhachHang(TrinaGridStateManager stateManager) async {
  final data =
  stateManager.rows
      .map(
        (row) => KhachHangModel(
      maKhach: row.cells[KhachHangString.maKhach]?.value,
      tenKH: row.cells[KhachHangString.tenKH]?.value,
      dienThoai: row.cells[KhachHangString.dienThoai]?.value,
      diDong: row.cells[KhachHangString.diDong]?.value,
      diaChi: row.cells[KhachHangString.diaChi]?.value,
    ),
  )
      .toList();

  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];
  sheetObject.cell(CellIndex.indexByString("A1")).value = TextCellValue("STT");
  sheetObject.cell(CellIndex.indexByString("B1")).value = TextCellValue("MaKhach");
  sheetObject.cell(CellIndex.indexByString("C1")).value = TextCellValue("TenKhach");
  sheetObject.cell(CellIndex.indexByString("D1")).value = TextCellValue("DienThoai");
  sheetObject.cell(CellIndex.indexByString("E1")).value = TextCellValue("DiDong");
  sheetObject.cell(CellIndex.indexByString("F1")).value = TextCellValue("DiaChi");

  int i = 0;
  for (var e in data) {
    i += 1;
    sheetObject.cell(CellIndex.indexByString("A${i + 1}")).value = IntCellValue(i);
    sheetObject.cell(CellIndex.indexByString("B${i + 1}")).value = TextCellValue(e.maKhach);
    sheetObject.cell(CellIndex.indexByString("C${i + 1}")).value = TextCellValue(e.tenKH);
    sheetObject.cell(CellIndex.indexByString("D${i + 1}")).value = TextCellValue(e.dienThoai);
    sheetObject.cell(CellIndex.indexByString("E${i + 1}")).value = TextCellValue(e.diDong);
    sheetObject.cell(CellIndex.indexByString("F${i + 1}")).value = TextCellValue(e.diaChi);
  }

  final filePath = await getSaveLocation(
    suggestedName: "khachhang.xlsx",
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
