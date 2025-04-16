import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../widgets/widgets.dart';

class PdfBanHang extends StatefulWidget {
  final String dateNow;
  final DateTime ngayBan;
  final String tenKH;
  final String diaChi;
  final String lyDo;
  final String soPhieu;
  final String congTien;
  final List<PhieuXuatCTModel> lstPhieuXuatCT;

  const PdfBanHang({
    super.key,
    required this.dateNow,
    required this.lstPhieuXuatCT,
    required this.tenKH,
    required this.diaChi,
    required this.lyDo,
    required this.ngayBan,
    required this.soPhieu,
    required this.congTien
  });

  @override
  State<PdfBanHang> createState() => _PdfBanHangState();
}

class _PdfBanHangState extends State<PdfBanHang> {
  final pdfWidget = PdfWidget();

  @override
  Widget build(BuildContext context) {
    final x = pdfBanHang(
      dateNow: widget.dateNow,
      diaChi: widget.diaChi,
      pxct: widget.lstPhieuXuatCT,
      date: widget.ngayBan,
      lyDo: widget.lyDo,
      tenKH: widget.tenKH,
      soPhieu: widget.soPhieu,
      congTien: widget.congTien
    );
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
        build: (format) {
          return x;
        },
      ),
    );
  }
}

  Future<Uint8List> pdfBanHang({
  required String dateNow,
  required DateTime date,
  required String tenKH,
  required String diaChi,
  required String lyDo,
  required String soPhieu,
  required String congTien,
  required List<PhieuXuatCTModel> pxct,
}) async {
  final pdf = pw.Document();
  final pdfWidget = PdfWidget();
  final fonData = await pdfWidget.fontData();
  final fontBold = await pdfWidget.fontDataBold();
  final fontItalic = await pdfWidget.fontDataItalic();
  final data = List.generate(pxct.length, (i) {
    final x = pxct[i];
    return [
      "${i + 1}",
      x.tenHH,
      x.dvt,
      Check().isInteger(x.soLg) ? x.soLg?.toInt() : x.soLg,
      Helper.numFormat(x.donGia),
      Helper.numFormat(x.thanhTien),
    ];
  });

  final headers = ['STT', 'Tên hàng hóa', 'Đơn vị tính ', 'Số lượng', 'Đơn giá', 'Thành tiền'];

  double? tongSL = 0;
  if(pxct.isNotEmpty){
    tongSL = pxct.map((e) => e.soLg).reduce((a, b) => a! + b!);
  }
  pdf.addPage(
    pw.MultiPage(
      footer:
          (context) =>  pdfWidget.footer(dateNow, context, fontItalic),
      pageTheme: pdfWidget.pageTheme(format: pdfWidget.pdfFormatPortrait, font: fonData),
      build: (context) {
        return [
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Mẫu số 02 - VT', style: pw.TextStyle(font: fontBold)),
                pw.Text('(Ban hành theo QĐ số 48/2006/QĐ – BTC'),
                pw.Text('Ngày 14/09/2006 của bộ trưởng BTC)'),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Column(
              children: [
                pdfWidget.title('PHIẾU XUẤT KHO', fontBold),
                pw.Text(
                  'Ngày ${Helper.formatMonth(date.day.toString())} tháng ${Helper.formatMonth(date.month.toString())} năm ${date.year}',
                ),
                pw.Text('Số phiếu: $soPhieu'),
              ],
            ),
          ),
          pdfWidget.label('Khách hàng: $tenKH', fonData),
          pw.SizedBox(height: 5),
          pdfWidget.label('Địa chỉ: $diaChi', fonData),
          pw.SizedBox(height: 5),
          pdfWidget.label('Lý do xuất: $lyDo', fonData),
          pw.SizedBox(height: 5),
          pdfWidget.table(
            data: data,
            headers: headers,
            border: pw.TableBorder.symmetric(),
            cellAlignments: {
              0: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
              5: pw.Alignment.centerRight,
            },
            cellDecoration: (a, b, c) {
              return pw.BoxDecoration(
                border: pw.Border(
                  right: pw.BorderSide(width: 1),
                  left: pw.BorderSide(width: 1),
                  bottom: pw.BorderSide(style: pw.BorderStyle.dashed, width: 1),
                ),
              );
            },
            columnWidths:  {
              0: pw.FixedColumnWidth(35),
              1: pw.FixedColumnWidth(180),
              2: pw.FixedColumnWidth(80),
              3: pw.FixedColumnWidth(80),
              4: pw.FixedColumnWidth(90),
              5: pw.FixedColumnWidth(90),
            },
            fontHeader: fontBold,
            headerAlignments: {3: pw.Alignment.center, 4: pw.Alignment.center, 5: pw.Alignment.center},
            headerCellDecoration: pw.BoxDecoration(border: pw.Border.all(width: 1))
          ),
          pw.Row(
            children: [
              pdfWidget.container('Tổng cộng', width: 290, font: fontBold),
              pdfWidget.container(
                '${Check().isInteger(tongSL) ? tongSL!.toInt() : tongSL}',
                width: 78.5,
                align: pw.Alignment.centerRight,
                font: fontBold,
              ),
              pw.Expanded(
                child: pdfWidget.container(
                  congTien,
                  font: fontBold,
                  align: pw.Alignment.centerRight,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pdfWidget.textItalic('Ngày …… tháng …… năm …………', fontItalic),
          ),
          pw.SizedBox(height: 10),
         pw.Padding(
           padding: pw.EdgeInsets.symmetric(horizontal: 10),
           child:  pw.Row(
             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
             children: [
               pw.Column(
                 children: [
                   pdfWidget.textItalic('Người lập phiếu', fontItalic, fontSize: 11),
                   pdfWidget.textItalic('(Ký họ, tên)', fontItalic),
                 ],
               ),
               pw.Column(
                 children: [
                   pdfWidget.textItalic('Người nhận hàng', fontItalic, fontSize: 11),
                   pdfWidget.textItalic('(Ký họ, tên)', fontItalic),
                 ],
               ),
               pw.Column(
                 children: [
                   pdfWidget.textItalic('Thủ kho', fontItalic, fontSize: 11),
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
         )
        ];
      },
    ),
  );
  return pdf.save();
}
