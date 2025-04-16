import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../widgets/widgets.dart';

class PdfPhieuChiView extends StatelessWidget {
  final String tenCTY;
  final String diaChi;
  final PhieuChiModel phieuChi;

  PdfPhieuChiView({super.key, required this.diaChi, required this.tenCTY, required this.phieuChi});

  final dateNow = Helper.dateNowDMY();
  final pdfWidget = PdfWidget();

  @override
  Widget build(BuildContext context) {
    final x = pdfPhieuChi(dateNow: dateNow, diaChi: diaChi, tenCTy: tenCTY, phieuChi: phieuChi);
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          leading: [
            IconPrinter(
              onPressed: () async {
                pdfWidget.onPrint(onLayout: x, format: pdfWidget.pdfFormatPortrait);
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

Future<Uint8List> pdfPhieuChi({
  required String dateNow,
  required String tenCTy,
  required String diaChi,
  required PhieuChiModel phieuChi,
}) async {
  final pdf = pw.Document();
  final pdfWidget = PdfWidget();
  final fonData = await pdfWidget.fontData();
  final fontBold = await pdfWidget.fontDataBold();
  final fontItalic = await pdfWidget.fontDataItalic();
  final ngayChi = DateTime.parse(phieuChi.ngay!);
  pdf.addPage(
    pw.MultiPage(
      pageTheme: pdfWidget.pageTheme(format: pdfWidget.pdfFormatPortrait, font: fonData),
      maxPages: 1,

      footer:
          (context) => pdfWidget.footer(dateNow, context, fontItalic),
      build: (context) {
        return [
          pw.Row(
            children: [
              pw.Container(
                width: 250,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [pw.Text('Đơn vị: $tenCTy'), pw.Text('Địa chỉ: $diaChi', softWrap: true)],
                ),
              ),
              pw.SizedBox(width: 100),
              pw.Expanded(
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('Mẫu số 02 - TT', style: pw.TextStyle(font: fontBold)),
                    pw.Text('Ban hành theo thông tư 133/2016/TT-BTC'),
                    pw.Text('Ngày 26/8/2016 của Bộ Tài Chính'),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            // alignment: pw.Alignment.centerRight,
            padding: pw.EdgeInsets.symmetric(horizontal: 70),
            child: pw.Row(
              children: [
                pw.Spacer(),
                pw.SizedBox(width: 55),
                pw.Column(
                  children: [
                    pdfWidget.title('PHIẾU CHI', fontBold),
                    pw.Text(
                      'Ngày ${Helper.formatMonth(ngayChi.day.toString())} tháng ${Helper.formatMonth(ngayChi.month.toString())} năm ${ngayChi.year}',
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Số: ${phieuChi.phieu}'),
                    pw.Text('Nợ: ${phieuChi.tkNo}'),
                    pw.Text('Có: ${phieuChi.tkCo}'),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 30),
          pdfWidget.label('Họ tên người nhận: ${phieuChi.nguoiNhan}', fonData),
          pw.SizedBox(height: 5),
          pdfWidget.label('Địa chỉ: ${phieuChi.diaChi}', fonData),
          pw.SizedBox(height: 5),
          pdfWidget.label('Lý do chi: ${phieuChi.noiDung}', fonData),
          pw.SizedBox(height: 5),
          pdfWidget.label('Số tiền: ${Helper.numFormat(phieuChi.soTien)}', fonData),
          pw.SizedBox(height: 5),
          pdfWidget.label('Viết bằng chữ: ${convertMoneyToString(phieuChi.soTien!.toInt())}', fonData),
          pw.SizedBox(height: 5),
          pdfWidget.label('Kèm theo: ${'.'*60} chứng từ gốc', fonData),
          pw.SizedBox(height: 5),
          pw.Container(
              alignment: pw.Alignment.centerRight,
              padding: pw.EdgeInsets.symmetric(horizontal: 30),
              child: pw.Text('Ngày${'.'*10}tháng${'.'*10}năm${'.'*10}',style: pw.TextStyle(font: fontItalic))
          ),
          pw.SizedBox(height: 10),
          pw.Padding(
            padding: pw.EdgeInsets.symmetric(horizontal: 50),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pdfWidget.textItalic('Người nhận tiền', fontItalic, fontSize: 11),
                    pdfWidget.textItalic('(Ký họ, tên)', fontItalic),
                  ],
                ),
                pw.Column(
                  children: [
                    pdfWidget.textItalic('Kế toán', fontItalic, fontSize: 11),
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
          pw.SizedBox(height: 80),
          pdfWidget.label('Đã nhận đủ số tiền: ${'.'*35}Viết bằng chữ: ${'.'*70}', fonData),
          pw.SizedBox(height: 5),
          pdfWidget.label('.'*165, fonData),
        ];
      },
    ),
  );

  return pdf.save();
}
