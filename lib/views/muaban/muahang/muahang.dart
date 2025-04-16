import 'package:app_ketoan/views/muaban/muahang/component/muahangct.dart';
import 'package:app_ketoan/views/muaban/muahang/component/pdf_muahang.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:pdf/pdf.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

import '../../../application/application.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../widgets/widgets.dart';

export 'baocao_muahang.dart';

class MuaHangView extends ConsumerStatefulWidget {
  final int? stt;

  const MuaHangView({super.key, this.stt});

  @override
  ConsumerState createState() => _MuaHangViewState();
}

class _MuaHangViewState extends ConsumerState<MuaHangView> {
  @override
  void initState() {
    if (widget.stt == null) {
      ref.read(phieuNhapProvider.notifier).getLastPhieuNhap(ref: ref);
    } else {
      ref.read(phieuNhapProvider.notifier).onMovePhieuNhap(widget.stt!, ref: ref);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lstKieuNhap = ref.watch(mnvLstNhapProvider);
    final lstNhaCung = ref.watch(lstNhaCungProvider);
    final lstBangTaiKhoan = ref.watch(btkListAllProvider);

    final wPhieuNhap = ref.watch(phieuNhapProvider);
    final rPhieuNhap = ref.read(phieuNhapProvider.notifier);
    final userName = ref.read(userInfoProvider)!.userName;
    final qlXBC =
        ref.read(tuyChonProvider).firstWhere((e) => e.nhom == MaTuyChon.qlXBC).giaTri == 1; //Nếu bằng 1 thi xem bc truoc khi in
    final qlKPC =
        ref.read(tuyChonProvider).firstWhere((e) => e.nhom == MaTuyChon.qlKPC).giaTri == 1;
    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5),
          leading: [
            IconAdd(
              onPressed: () {
                if (qlKPC && !wPhieuNhap!.khoa) {
                  rPhieuNhap.updatePhieuNhap(PhieuXuatString.khoa, 1, wPhieuNhap.phieu, userName: userName);
                }
                rPhieuNhap.addPhieuNhap(userName, ref);
              },
            ),
            IconDelete(
              enabled: !(wPhieuNhap == null || wPhieuNhap.khoa),
              onPressed: () async {
                final btn = await CustomAlert().warning(AppString.delete, title: 'PHIẾU NHẬP');
                if (btn == AlertButton.okButton) {
                  rPhieuNhap.deletePhieuNhap(wPhieuNhap!.id!, ref: ref);
                }
              },
            ),
            IconPrinter(
              onPressed: () async {
                if (!wPhieuNhap!.khoa) {
                  rPhieuNhap.updatePhieuNhap(PhieuXuatString.khoa, 1, wPhieuNhap.phieu, userName: userName);
                }
                String dvCC = '';
                String diaChi = '';

                if (wPhieuNhap.maKhach != null) {
                  final kh = lstNhaCung.value?.firstWhere((e) => e.maKhach == wPhieuNhap.maKhach);
                  dvCC = kh!.tenKH;
                  diaChi = kh.diaChi;
                }
                final sql = SqlRepository(tableName: TableName.phieuNhapCT);
                final data = await sql.getData(where: "${PhieuNhapCTString.maID} = ?", whereArgs: [wPhieuNhap.id]);
                final lst = data.map((e) => PhieuNhapCTModel.fromMap(e)).toList();

                if (qlXBC) {
                  showViewPrinter(context,  PdfMuaHang(
                    dateNow: Helper.dateNowDMY(),
                    congTien: Helper.numFormat(wPhieuNhap.congTien).toString(),
                    diaChi: diaChi,
                    lstPhieuNhapCT: lst,
                    donViCC: dvCC,
                    lyDo: wPhieuNhap.dienGiai,
                    ngayMua: DateTime.parse(wPhieuNhap.ngay),
                    soPhieu: wPhieuNhap.phieu,
                  ));
                } else {
                  PdfWidget().onPrint(
                    onLayout: pdfMuaHang(
                      dateNow: Helper.dateNowDMY(),
                      ngayMua: DateTime.parse(wPhieuNhap.ngay),
                      donViCC: dvCC,
                      diaChi: diaChi,
                      lyDo: wPhieuNhap.dienGiai,
                      soPhieu: wPhieuNhap.phieu,
                      congTien: Helper.numFormat(wPhieuNhap.congTien).toString(),
                      lstPhieuNhapCT: lst,
                    ),
                    format: PdfPageFormat.a4.portrait,
                  );
                }
              },
            ),
          ],
          trailing: [
            SizedBox(
              width: 200,
              child: LabelTextfield(
                enabled: false,
                label: 'Người tạo',
                controller: TextEditingController(text: wPhieuNhap?.createdBy ?? ''),
              ),
            ),
            PrimaryButton(
              enabled: wPhieuNhap != null,
              onPressed: () {
                rPhieuNhap.updatePhieuNhap(
                  PhieuNhapString.khoa,
                  !wPhieuNhap!.khoa ? 1 : 0,
                  wPhieuNhap.phieu,
                  userName: userName,
                );
              },
              size: ButtonSize(.8),
              child: Text(wPhieuNhap != null && wPhieuNhap.khoa ? 'Sửa' : 'Khóa'),
            ),
          ],
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(10),
        child:
            wPhieuNhap == null
                ? null
                : Column(
                  spacing: 5,
                  children: [
                    OutlinedContainer(
                      borderColor: Colors.gray.shade300,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        spacing: 10,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              SizedBox(
                                width: 170,
                                child: DateTextbox(
                                  enabled: !wPhieuNhap.khoa,
                                  onChanged: (val) {
                                    rPhieuNhap.updatePhieuNhap(
                                      PhieuNhapString.ngay,
                                      Helper.dateFormatYMD(val),
                                      wPhieuNhap.phieu,
                                      userName: userName,
                                    );
                                  },
                                  label: 'Ngày xuất',
                                  initialDate: Helper.stringToDate(wPhieuNhap.ngay),
                                  showClear: false,
                                ),
                              ),
                              Gap(20),
                              SizedBox(
                                width: 200,
                                child: LabelTextfield(
                                  label: 'Số phiếu',
                                  enabled: !wPhieuNhap.khoa,
                                  controller: TextEditingController(text: wPhieuNhap.phieu),
                                  textAlign: TextAlign.center,
                                  readOnly: true,
                                ),
                              ),
                              Gap(20),
                              SizedBox(
                                width: 200,
                                child: LabelCombobox(
                                  readOnly: true,
                                  enabled: !wPhieuNhap.khoa,
                                  selected: lstKieuNhap.value!.firstWhere((e) => e.maNghiepVu == wPhieuNhap.maNX).moTa,
                                  items:
                                      lstKieuNhap.hasValue
                                          ? lstKieuNhap.value!
                                              .map(
                                                (e) => ComboboxItem(
                                                  value: e.moTa!,
                                                  title: [e.moTa!],
                                                  valueOther: e.maNghiepVu,
                                                ),
                                              )
                                              .toList()
                                          : [],
                                  onChanged: (val, o) {
                                    rPhieuNhap.updatePhieuNhap(
                                      PhieuNhapString.maNX,
                                      o,
                                      wPhieuNhap.phieu,
                                      userName: userName,
                                    );
                                  },
                                  label: 'Kiểu nhập',
                                ),
                              ),
                              Gap(20),
                              SizedBox(
                                width: 250,
                                child: LabelTextfield(
                                  enabled: !wPhieuNhap.khoa,
                                  controller: TextEditingController(text: wPhieuNhap.kyHieu),
                                  onChanged: (val) {
                                    rPhieuNhap.updatePhieuNhap(
                                      PhieuNhapString.kyHieu,
                                      val,
                                      wPhieuNhap.phieu,
                                      userName: userName,
                                    );
                                  },
                                  label: 'Ký hiệu hóa đơn',
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Combobox(
                                  readOnly: true,
                                  enabled: !wPhieuNhap.khoa,
                                  selected: wPhieuNhap.pttt,
                                  items: [
                                    ComboboxItem(value: 'TM', title: ['TM']),
                                    ComboboxItem(value: 'CK', title: ['CK']),
                                    ComboboxItem(value: 'TM/CK', title: ['TM/CK']),
                                  ],
                                  onChanged: (val, o) {
                                    rPhieuNhap.updatePhieuNhap(
                                      PhieuNhapString.pttt,
                                      val,
                                      wPhieuNhap.phieu,
                                      userName: userName,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          Row(
                            spacing: 10,
                            children: [
                              SizedBox(
                                width: 200,
                                child: LabelCombobox(
                                  menuWidth: 500,
                                  columnWidth: [130, 290],
                                  enabled: !wPhieuNhap.khoa,
                                  selected: wPhieuNhap.maKhach,
                                  items:
                                      lstNhaCung.hasValue
                                          ? lstNhaCung.value!
                                              .map((e) => ComboboxItem(value: e.maKhach, title: [e.maKhach, e.tenKH]))
                                              .toList()
                                          : [],
                                  spacing: 8,
                                  label: 'Mã khách',
                                  onChanged: (val, o) {
                                    rPhieuNhap.updateMaKhach(
                                      val,
                                      wPhieuNhap.phieu,
                                      userName: userName,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 440,
                                child: LabelTextfield(
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text:
                                        wPhieuNhap.maKhach == null
                                            ? ''
                                            : lstNhaCung.value!
                                                .firstWhere(
                                                  (e) => e.maKhach == wPhieuNhap.maKhach,
                                                  orElse: () => KhachHangModel(maKhach: '', tenKH: ''),
                                                )
                                                .tenKH,
                                  ),
                                ),
                              ),
                              Gap(20),
                              SizedBox(
                                width: 250,
                                child: LabelTextfield(
                                  enabled: !wPhieuNhap.khoa,
                                  label: 'Số hóa đơn',
                                  controller: TextEditingController(text: wPhieuNhap.soCT),
                                  onChanged: (val) {
                                    rPhieuNhap.updatePhieuNhap(
                                      PhieuNhapString.soCT,
                                      val,
                                      wPhieuNhap.phieu,
                                      userName: userName,
                                    );
                                  },
                                  spacing: 40,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,

                            children: [
                              SizedBox(
                                width: 650,
                                child: LabelTextfield(
                                  label: 'Diễn giải',
                                  enabled: !wPhieuNhap.khoa,
                                  controller: TextEditingController(text: wPhieuNhap.dienGiai),
                                  onChanged: (val) {
                                    rPhieuNhap.updatePhieuNhap(
                                      PhieuNhapString.dienGiai,
                                      val,
                                      wPhieuNhap.phieu,
                                      userName: userName,
                                    );
                                  },
                                  spacing: 14,
                                ),
                              ),
                              Gap(20),
                              SizedBox(
                                width: 250,
                                child: DateTextbox(
                                  showClear: false,
                                  enabled: !wPhieuNhap.khoa,
                                  label: 'Ngày hóa đơn',
                                  spacing: 23,
                                  initialDate: Helper.stringToDate(wPhieuNhap.ngayCT),
                                  onChanged: (DateTime? value) {
                                    rPhieuNhap.updatePhieuNhap(
                                      PhieuNhapString.ngayCT,
                                      Helper.dateFormatYMD(value),
                                      wPhieuNhap.phieu,
                                      userName: userName,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          /// Table chi tiết
                          SizedBox(
                            height: 300,
                            child: MuaHangCT(phieuNhap: wPhieuNhap, phieuNhapNotifier: rPhieuNhap, userName: userName),
                          ),
                          SizedBox(
                            width: 868,
                            child: Row(
                              children: [
                                Gap(200),
                                SizedBox(
                                  width: 150,
                                  child: LabelCombobox(
                                    menuWidth: 410,
                                    columnWidth: [80, 320],
                                    enabled: !wPhieuNhap.khoa,
                                    selected: wPhieuNhap.tkNo,
                                    items:
                                        lstBangTaiKhoan.hasValue
                                            ? lstBangTaiKhoan.value!
                                                .map((e) => ComboboxItem(value: e.maTK, title: [e.maTK, e.tenTK]))
                                                .toList()
                                            : [],
                                    onChanged: (val, o) {
                                      rPhieuNhap.updatePhieuNhap(
                                        PhieuNhapString.tkNo,
                                        val,
                                        wPhieuNhap.phieu,
                                        userName: userName,
                                      );
                                    },
                                    label: 'TK Nợ/Có',
                                  ),
                                ),
                                SizedBox(
                                  width: 85,
                                  child: Combobox(
                                    selected: wPhieuNhap.tkCo,
                                    enabled: !wPhieuNhap.khoa,
                                    menuWidth: 410,
                                    columnWidth: [80, 320],
                                    items:
                                        lstBangTaiKhoan.hasValue
                                            ? lstBangTaiKhoan.value!
                                                .map((e) => ComboboxItem(value: e.maTK, title: [e.maTK, e.tenTK]))
                                                .toList()
                                            : [],
                                    onChanged: (val, o) {
                                      rPhieuNhap.updatePhieuNhap(
                                        PhieuNhapString.tkCo,
                                        val,
                                        wPhieuNhap.phieu,
                                        userName: userName,
                                      );
                                    },
                                  ),
                                ),
                                Gap(20),
                                Checkbox(
                                  enabled: !wPhieuNhap.khoa,
                                  state: wPhieuNhap.kChiuThue ? CheckboxState.checked : CheckboxState.unchecked,
                                  onChanged: (val) {
                                    rPhieuNhap.updatePhieuNhap(
                                      PhieuNhapString.kChiuThue,
                                      val.index == 0 ? 1 : 0,
                                      wPhieuNhap.phieu,
                                      userName: userName,
                                    );
                                  },
                                  trailing: Text('Không chịu thuế').medium(),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 226,
                                  child: LabelTextfield(
                                    label: 'Cộng tiền hàng',
                                    controller: TextEditingController(text: Helper.numFormat(wPhieuNhap.congTien)),
                                    readOnly: true,
                                    isNumber: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 868,
                            child: Row(
                              children: [
                                Gap(200),
                                SizedBox(
                                  width: 150,
                                  child:
                                      wPhieuNhap.kChiuThue
                                          ? null
                                          : LabelCombobox(
                                            selected: wPhieuNhap.tkVatNo,
                                            menuWidth: 410,
                                            enabled: !wPhieuNhap.khoa,
                                            columnWidth: [80, 320],
                                            items:
                                                lstBangTaiKhoan.hasValue
                                                    ? lstBangTaiKhoan.value!
                                                        .map(
                                                          (e) => ComboboxItem(value: e.maTK, title: [e.maTK, e.tenTK]),
                                                        )
                                                        .toList()
                                                    : [],
                                            onChanged: (val, o) {
                                              rPhieuNhap.updatePhieuNhap(
                                                PhieuNhapString.tkVatNo,
                                                val,
                                                wPhieuNhap.phieu,
                                                userName: userName,
                                              );
                                            },
                                            label: 'TK VAT',
                                            spacing: 22,
                                          ),
                                ),
                                SizedBox(
                                  width: 85,
                                  child:
                                      wPhieuNhap.kChiuThue
                                          ? null
                                          : Combobox(
                                            selected: wPhieuNhap.tkVatCo,
                                            enabled: !wPhieuNhap.khoa,
                                            menuWidth: 410,
                                            columnWidth: [80, 320],
                                            items:
                                                lstBangTaiKhoan.hasValue
                                                    ? lstBangTaiKhoan.value!
                                                        .map(
                                                          (e) => ComboboxItem(value: e.maTK, title: [e.maTK, e.tenTK]),
                                                        )
                                                        .toList()
                                                    : [],
                                            onChanged: (val, o) {
                                              rPhieuNhap.updatePhieuNhap(
                                                PhieuNhapString.tkVatCo,
                                                val,
                                                wPhieuNhap.phieu,
                                                userName: userName,
                                              );
                                            },
                                          ),
                                ),
                                Gap(30),
                                SizedBox(
                                  width: 150,
                                  child:
                                      wPhieuNhap.kChiuThue
                                          ? null
                                          : Focus(
                                            onFocusChange: (b) {
                                              if (!b) {
                                                final value = (wPhieuNhap.congTien * wPhieuNhap.thueSuat) / 100;
                                                rPhieuNhap.updatePhieuNhap(
                                                  PhieuNhapString.tienThue,
                                                  value,
                                                  wPhieuNhap.phieu,
                                                  userName: userName,
                                                );
                                              }
                                            },
                                            child: LabelTextfield(
                                              label: 'Thuế suất(%)',
                                              controller: TextEditingController(text: wPhieuNhap.thueSuat.toString()),
                                              onChanged: (val) {
                                                rPhieuNhap.updatePhieuNhap(
                                                  PhieuNhapString.thueSuat,
                                                  val,
                                                  wPhieuNhap.phieu,
                                                  userName: userName,
                                                );
                                              },
                                              enabled: !wPhieuNhap.khoa,
                                              isDouble: true,
                                            ),
                                          ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 225,
                                  child: Focus(
                                    onFocusChange: (b) {
                                      if (!b) {
                                        rPhieuNhap.updatePhieuNhap(
                                          PhieuNhapString.tienThue,
                                          wPhieuNhap.tienThue,
                                          wPhieuNhap.phieu,
                                          userName: userName,
                                        );
                                      }
                                    },
                                    child: LabelTextfield(
                                      enabled: !wPhieuNhap.khoa && !wPhieuNhap.kChiuThue,
                                      label: 'Tiền thuế GTGT',
                                      controller: TextEditingController(text: Helper.numFormat(wPhieuNhap.tienThue)),
                                      onChanged: (val) {
                                        rPhieuNhap.updateTienThueGTGT(
                                          Helper.numFormatToDouble(val),
                                          wPhieuNhap.phieu,
                                          userName: userName,
                                        );
                                      },
                                      isNumber: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 868,
                            child: Row(
                              children: [
                                Spacer(),
                                SizedBox(
                                  width: 260,
                                  child: LabelTextfield(
                                    isNumber: true,
                                    label: 'Tổng tiền thanh toán',
                                    controller: TextEditingController(
                                      text: Helper.numFormat(wPhieuNhap.congTien + wPhieuNhap.tienThue),
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GroupButtonNumberPage(
                      text: '${wPhieuNhap.stt}/${wPhieuNhap.countRow}',
                      last: () {
                        if (wPhieuNhap.stt.toString() != wPhieuNhap.countRow) {
                          rPhieuNhap.getLastPhieuNhap(ref: ref);
                        }
                      },
                      next: () {
                        if (wPhieuNhap.stt.toString() != wPhieuNhap.countRow) {
                          rPhieuNhap.onMovePhieuNhap(wPhieuNhap.stt! + 1, ref: ref);
                        }
                      },
                      back: () {
                        if (wPhieuNhap.stt != 1) {
                          rPhieuNhap.onMovePhieuNhap(wPhieuNhap.stt! - 1, ref: ref);
                        }
                      },
                      first: () {
                        if (wPhieuNhap.stt != 1) {
                          rPhieuNhap.onMovePhieuNhap(1, ref: ref);
                        }
                      },
                    ),
                  ],
                ),
      ),
    );
  }
}
