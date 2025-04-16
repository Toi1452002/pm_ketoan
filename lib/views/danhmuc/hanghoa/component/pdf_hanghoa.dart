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

class PdfHangHoaView extends StatelessWidget {
  final TrinaGridStateManager stateManager;
  PdfHangHoaView({super.key, required this.stateManager});

  final _pdfWidget = PdfWidget();
  final _dateNow = Helper.dateNowDMY();
  @override
  Widget build(BuildContext context) {
    final x = pdfHangHoa(dateNow: _dateNow,stateManager: stateManager);
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
        build: (format) {
          return x;
        },
      ),
    );
  }
}

Future<Uint8List> pdfHangHoa({required String dateNow, required TrinaGridStateManager stateManager}) async {
  final pdf = pw.Document();
  final pdfWidget = PdfWidget();
  final fonData = await pdfWidget.fontData();
  final fontBold = await pdfWidget.fontDataBold();
  final fontItalic = await pdfWidget.fontDataItalic();

  final data =
      stateManager.rows
          .map(
            (row) => HangHoaModel(
              maHH: row.cells[HangHoaString.maHH]!.value,
              tenHH: row.cells[HangHoaString.tenHH]!.value,
              giaMua: 0,
              giaBan: double.parse(row.cells[HangHoaString.giaBan]!.value.toString()),
              ghiChu: row.cells[HangHoaString.ghiChu]!.value,
              donViTinh: row.cells[DVTString.dvt]!.value,
              tinhTon: false,
              theoDoi: false,
              tkKho: '',
            ),
          )
          .toList();

  pdf.addPage(
    pw.MultiPage(
      pageTheme: pdfWidget.pageTheme(font: fonData),
      footer: (context) => pdfWidget.footer(dateNow, context, fontItalic),
      build: (context) {
        return [
          pw.Center(child: pdfWidget.title('DANH SÁCH HÀNG HÓA', fontBold)),
          pw.SizedBox(height: 10),
          pdfWidget.table(
            fontHeader: fontBold,
            border: pw.TableBorder.all(width: .5),
            cellAlignments: {
              0: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.centerRight,
            },
            columnWidths: {
              0:pw.FixedColumnWidth(30),
              1:pw.FixedColumnWidth(100),
              2:pw.FixedColumnWidth(170),
              3:pw.FixedColumnWidth(40),
              4:pw.FixedColumnWidth(80),
              5:pw.FixedColumnWidth(130),
              // 4:pw.FixedColumnWidth(80),
            },

            headers: ['STT','Mã hàng','Tên hàng','ĐVT','Giá bán','Ghi chú'],
            data: List.generate(data.length, (i) {
              final x = data[i];
              return [
                '${i+1}',x.maHH,x.tenHH,x.donViTinh,Helper.numFormat(x.giaBan),x.ghiChu
              ];
            }),
          ),
        ];
      },
    ),
  );

  return pdf.save();
}


void excelHangHoa(TrinaGridStateManager stateManager) async {
  final data =
  stateManager.rows
      .map(
        (row) => HangHoaModel(
      maHH: row.cells[HangHoaString.maHH]!.value,
      tenHH: row.cells[HangHoaString.tenHH]!.value,
      giaMua: 0,
      giaBan: double.parse(row.cells[HangHoaString.giaBan]!.value.toString()),
      ghiChu: row.cells[HangHoaString.ghiChu]!.value,
      donViTinh: row.cells[DVTString.dvt]!.value,
      tinhTon: false,
      theoDoi: false,
      tkKho: '',
    ),
  )
      .toList();

  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];
  sheetObject.cell(CellIndex.indexByString("A1")).value = TextCellValue("STT");
  sheetObject.cell(CellIndex.indexByString("B1")).value = TextCellValue("MaHH");
  sheetObject.cell(CellIndex.indexByString("C1")).value = TextCellValue("TenHH");
  sheetObject.cell(CellIndex.indexByString("D1")).value = TextCellValue("DVT");
  sheetObject.cell(CellIndex.indexByString("E1")).value = TextCellValue("GiaBan");
  sheetObject.cell(CellIndex.indexByString("F1")).value = TextCellValue("GhiChu");

  int i = 0;
  for (var e in data) {
    i += 1;
    sheetObject.cell(CellIndex.indexByString("A${i + 1}")).value = IntCellValue(i);
    sheetObject.cell(CellIndex.indexByString("B${i + 1}")).value = TextCellValue(e.maHH);
    sheetObject.cell(CellIndex.indexByString("C${i + 1}")).value = TextCellValue(e.tenHH);
    sheetObject.cell(CellIndex.indexByString("D${i + 1}")).value = TextCellValue(e.donViTinh!);
    sheetObject.cell(CellIndex.indexByString("E${i + 1}")).value = DoubleCellValue(e.giaBan);
    sheetObject.cell(CellIndex.indexByString("F${i + 1}")).value = TextCellValue(e.ghiChu);
  }

  final filePath = await getSaveLocation(
    suggestedName: "hanghoa.xlsx",
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
