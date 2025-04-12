import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../widgets/widgets.dart';

class PdfMuaHang extends StatefulWidget {
  final String dateNow;
  final DateTime ngayMua;
  final String donViCC;
  final String diaChi;
  final String lyDo;
  final String soPhieu;
  final String congTien;
  final List<PhieuNhapCTModel> lstPhieuNhapCT;

  const PdfMuaHang({
    super.key,
    required this.dateNow,
    required this.lstPhieuNhapCT,
    required this.donViCC,
    required this.diaChi,
    required this.lyDo,
    required this.ngayMua,
    required this.soPhieu,
    required this.congTien,
  });

  @override
  State<PdfMuaHang> createState() => _PdfMuaHangState();
}

class _PdfMuaHangState extends State<PdfMuaHang> {
  final pdfFormat = PdfPageFormat.a4.portrait;
  final pdfWidget = PdfWidget();

  @override
  Widget build(BuildContext context) {
    final x = pdfMuaHang(
      dateNow: widget.dateNow,
      diaChi: widget.diaChi,
      lstPhieuNhapCT: widget.lstPhieuNhapCT,
      ngayMua: widget.ngayMua,
      lyDo: widget.lyDo,
      donViCC: widget.donViCC,
      soPhieu: widget.soPhieu,
      congTien: widget.congTien,
    );
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          leading: [
            iconPrinter(
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

Future<Uint8List> pdfMuaHang({
  required String dateNow,
  required DateTime ngayMua,
  required String donViCC,
  required String diaChi,
  required String lyDo,
  required String soPhieu,
  required String congTien,
  required List<PhieuNhapCTModel> lstPhieuNhapCT,
}) async {
  final pdf = pw.Document();
  final pdfWidget = PdfWidget();
  final fonData = await pdfWidget.fontData();
  final fontBold = await pdfWidget.fontDataBold();
  final fontItalic = await pdfWidget.fontDataItalic();
  final data = List.generate(lstPhieuNhapCT.length, (i) {
    final x = lstPhieuNhapCT[i];
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
  if (lstPhieuNhapCT.isNotEmpty) {
    tongSL = lstPhieuNhapCT.map((e) => e.soLg).reduce((a, b) => a! + b!);
  }
  pdf.addPage(
    pw.MultiPage(
      footer:
          (context) => pdfWidget.footer(dateNow, context, fontItalic),
      pageTheme: pdfWidget.pageTheme(format: pdfWidget.pdfFormatPortrait, font: fonData),
      build: (context) {
        return [
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Mẫu số 01 - VT', style: pw.TextStyle(font: fontBold)),
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
                pdfWidget.title('PHIẾU NHẬP KHO', fontBold),
                pw.Text(
                  'Ngày ${Helper.formatMonth(ngayMua.day.toString())} tháng ${Helper.formatMonth(ngayMua.month.toString())} năm ${ngayMua.year}',
                ),
                pw.Text('Số phiếu: $soPhieu'),
              ],
            ),
          ),
          pdfWidget.label('Đơn vị cung cấp: $donViCC', fonData),
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
            columnWidths: {
              0: pw.FixedColumnWidth(35),
              1: pw.FixedColumnWidth(180),
              2: pw.FixedColumnWidth(80),
              3: pw.FixedColumnWidth(80),
              4: pw.FixedColumnWidth(90),
              5: pw.FixedColumnWidth(90),
            },
            fontHeader: fontBold,
            headerAlignments: {3: pw.Alignment.center, 4: pw.Alignment.center, 5: pw.Alignment.center},
            headerCellDecoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
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
              pw.Expanded(child: pdfWidget.container(congTien, font: fontBold, align: pw.Alignment.centerRight)),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pdfWidget.textItalic('Ngày …… tháng …… năm …………', fontItalic),
          ),
          pw.SizedBox(height: 10),
          pw.Padding(
            padding: pw.EdgeInsets.symmetric(horizontal: 30),
            child: pw.Row(
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
                    pdfWidget.textItalic('Người giao hàng', fontItalic, fontSize: 11),
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
              ],
            ),
          )
        ];
      },
    ),
  );
  return pdf.save();
}
