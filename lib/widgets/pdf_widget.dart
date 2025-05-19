import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PdfWidget {
  final pdfFormatPortrait = PdfPageFormat.a4.portrait;
  final pdfFormatLandscape = PdfPageFormat.a4.landscape;
  final colorBlue = PdfColors.blue900;
  final colorBlueGray = PdfColors.blueGrey900;

  Future<pw.Font> fontData() async => pw.Font.ttf(await rootBundle.load("assets/fonts/Roboto-Regular.ttf"));

  Future<pw.Font> fontDataBold() async => pw.Font.ttf(await rootBundle.load("assets/fonts/Roboto-Medium.ttf"));

  Future<pw.Font> fontDataBlack() async => pw.Font.ttf(await rootBundle.load("assets/fonts/Roboto-Black.ttf"));

  Future<pw.Font> fontDataItalic() async => pw.Font.ttf(await rootBundle.load("assets/fonts/Roboto-Italic.ttf"));

  void onPrint({
    String url = "Microsoft Print to PDF",
    required FutureOr<Uint8List> onLayout,
    PdfPageFormat format = PdfPageFormat.a4,
  }) async {
    Printer print = Printer(url: url);
    await Printing.directPrintPdf(onLayout: (e) => onLayout, format: format, printer: print);
  }

  pw.PageTheme pageTheme({PdfPageFormat format = PdfPageFormat.a4, double pdV = 25, double pdH = 25, pw.Font? font}) {
    return pw.PageTheme(
      pageFormat: format,
      theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: font, fontSize: 10)),
      margin: pw.EdgeInsets.symmetric(vertical: pdV, horizontal: pdH),
    );
  }

  pw.Text title(String title, pw.Font? font) {
    return pw.Text(
      title,
      style: pw.TextStyle(font: font, color: colorBlue, fontSize: 22, fontWeight: pw.FontWeight.bold),
    );
  }

  pw.Text label(String text, pw.Font? font) {
    return pw.Text(text, style: pw.TextStyle(font: font, fontSize: 12),softWrap: true);
  }

  pw.Text textItalic(String text, pw.Font? font, {double? fontSize}) {
    return pw.Text(text, style: pw.TextStyle(font: font, fontSize: fontSize));
  }

  pw.Container container(
    String text, {
    double? width,
    double height = 17,
    pw.Font? font,
        double widthBorder = 1,
    pw.Alignment align = pw.Alignment.center,
  }) {
    return pw.Container(
      width: width,
      height: height,
      alignment: align,
      padding: pw.EdgeInsets.symmetric(horizontal: 3),
      decoration: pw.BoxDecoration(border: pw.Border.all(width: widthBorder)),
      child: pw.Text(text, style: pw.TextStyle(font: font,),textAlign: pw.TextAlign.center),
    );
  }

  pw.Table table({
    required List<List<dynamic>> data,
    pw.Font? fontHeader,
    pw.TableBorder? border,
    Map<int, pw.AlignmentGeometry>? headerAlignments,
    List<dynamic>? headers,
    pw.BoxDecoration? headerCellDecoration,
    Map<int, pw.AlignmentGeometry>? cellAlignments,
    pw.BoxDecoration Function(int, dynamic, int)? cellDecoration,
    Map<int, pw.TableColumnWidth>? columnWidths,
  }) {
    return pw.TableHelper.fromTextArray(
      data: data,
      border: border,
      tableWidth: pw.TableWidth.min,

      headerAlignment: pw.Alignment.center,
      headerAlignments: headerAlignments,
      headers: headers,
      headerHeight: 17,
      headerCellDecoration: headerCellDecoration,
      headerStyle: pw.TextStyle(font: fontHeader),


      cellHeight: 5,
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      cellAlignments: cellAlignments,
      cellDecoration: cellDecoration,
      columnWidths: columnWidths,
    );
  }
  pw.Row footer(String dateNow, pw.Context context, pw.Font? fontItalic, {bool isPortrait = true}){
    return  pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Align(
          child: pw.Text(dateNow, style: pw.TextStyle(font: fontItalic,color: PdfColors.grey800)),
          alignment: pw.Alignment.centerLeft,
        ),
        pw.SizedBox(width:isPortrait ? 110 : 230),
        pw.Align(
          child: pw.Text('In từ phầm mềm www.rgb.com.vn', style: pw.TextStyle(font: fontItalic,color: PdfColors.grey800)),
          alignment: pw.Alignment.center,
        ),
        pw.Spacer(),
        pw.Align(child: pw.Text(context.pageLabel,style: pw.TextStyle(color: PdfColors.grey800)), alignment: pw.Alignment.centerRight),
      ],
    );
  }
}
