import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/views/muaban/banhang/component/banhangct.dart';
import 'package:app_ketoan/views/muaban/banhang/component/pdf_banhang.dart';
import 'package:app_ketoan/widgets/widgets.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:pdf/pdf.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

import '../../../data/data.dart';

export 'baocao_banhang.dart';

class BanHangView extends ConsumerStatefulWidget {
  final int? stt;

  const BanHangView({super.key, this.stt});

  @override
  ConsumerState createState() => _BanHangViewState();
}

class _BanHangViewState extends ConsumerState<BanHangView> {
  @override
  void initState() {
    if (widget.stt == null) {
      ref.read(phieuXuatProvider.notifier).getLastPhieuXuat(ref: ref);
    } else {
      ref.read(phieuXuatProvider.notifier).onMovePhieuXuat(widget.stt!, ref: ref);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lstKieuXuat = ref.watch(mnvLstXuatProvider);
    final lstKhach = ref.watch(lstKhachProvider);
    final lstBangTaiKhoan = ref.watch(btkListAllProvider);

    final wPhieuXuat = ref.watch(phieuXuatProvider);
    final rPhieuXuat = ref.read(phieuXuatProvider.notifier);
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
                if (qlKPC && !wPhieuXuat!.khoa) {
                  rPhieuXuat.updatePhieuXuat(PhieuXuatString.khoa, 1, wPhieuXuat.phieu, userName: userName);
                }
                rPhieuXuat.addPhieuXuat(userName, ref);
              },
            ),
            IconDelete(
              enabled: !(wPhieuXuat == null || wPhieuXuat.khoa),
              onPressed: () async {
                final btn = await CustomAlert().warning(AppString.delete, title: 'PHIẾU XUẤT');
                if (btn == AlertButton.okButton) {
                  rPhieuXuat.deletePhieuXuat(wPhieuXuat!.id!, ref: ref);
                }
              },
            ),
            IconPrinter(
              onPressed: () async {
                if (!wPhieuXuat!.khoa) {
                  rPhieuXuat.updatePhieuXuat(PhieuXuatString.khoa, 1, wPhieuXuat.phieu, userName: userName);
                }
                String tenKH = '';
                String diaChi = '';
                if (wPhieuXuat.maKhach != null) {
                  final kh = lstKhach.value?.firstWhere((e) => e.maKhach == wPhieuXuat.maKhach);
                  tenKH = kh!.tenKH;
                  diaChi = kh.diaChi;
                }

                final sql = SqlRepository(tableName: TableName.phieuXuatCT);
                final data = await sql.getData(where: "${PhieuXuatCTString.maID} = ?", whereArgs: [wPhieuXuat.id]);
                final lst = data.map((e) => PhieuXuatCTModel.fromMap(e)).toList();
                if (qlXBC) {
                  showViewPrinter(context, PdfBanHang(
                    dateNow: Helper.dateNowDMY(),
                    congTien: Helper.numFormat(wPhieuXuat.congTien).toString(),
                    diaChi: diaChi,
                    lstPhieuXuatCT: lst,
                    tenKH: tenKH,
                    lyDo: wPhieuXuat.dienGiai,
                    ngayBan: DateTime.parse(wPhieuXuat.ngay),
                    soPhieu: wPhieuXuat.phieu,
                  ));
                } else {
                  PdfWidget().onPrint(
                    onLayout: pdfBanHang(
                      dateNow: Helper.dateNowDMY(),
                      date: DateTime.parse(wPhieuXuat.ngay),
                      tenKH: tenKH,
                      diaChi: diaChi,
                      lyDo: wPhieuXuat.dienGiai,
                      soPhieu: wPhieuXuat.phieu,
                      congTien: Helper.numFormat(wPhieuXuat.congTien).toString(),
                      pxct: lst,
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
                label: 'Người tạo',
                enabled: false,
                controller: TextEditingController(text: wPhieuXuat?.createdBy ?? ''),
              ),
            ),
            PrimaryButton(
              enabled: wPhieuXuat != null,
              size: ButtonSize(.8),
              child: Text(wPhieuXuat != null && wPhieuXuat.khoa ? 'Sửa' : 'Khóa'),
              onPressed: () {
                rPhieuXuat.updatePhieuXuat(
                  PhieuXuatString.khoa,
                  !wPhieuXuat!.khoa ? 1 : 0,
                  wPhieuXuat.phieu,
                  userName: userName,
                );
              },
            ),
          ],
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(10),
        child:
            wPhieuXuat == null
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
                                  enabled: !wPhieuXuat.khoa,
                                  onChanged: (val) {
                                    rPhieuXuat.updatePhieuXuat(
                                      PhieuXuatString.ngay,
                                      Helper.dateFormatYMD(val),
                                      wPhieuXuat.phieu,
                                      userName: userName,
                                    );
                                    rPhieuXuat.updatePhieuXuat(
                                      PhieuXuatString.ngayCT,
                                      Helper.dateFormatYMD(val),
                                      wPhieuXuat.phieu,
                                      userName: userName,
                                    );
                                  },
                                  initialDate: Helper.stringToDate(wPhieuXuat.ngay),
                                  label: 'Ngày xuất',
                                  showClear: false,
                                ),
                              ),
                              Gap(20),
                              SizedBox(
                                width: 200,
                                child: LabelTextfield(
                                  label: 'Số phiếu',
                                  enabled: !wPhieuXuat.khoa,
                                  controller: TextEditingController(text: wPhieuXuat.phieu),
                                  textAlign: TextAlign.center,
                                  readOnly: true,
                                ),
                              ),
                              Gap(20),
                              SizedBox(
                                width: 200,
                                child: LabelCombobox(
                                  readOnly: true,
                                  enabled: !wPhieuXuat.khoa,
                                  selected: lstKieuXuat.value!.firstWhere((e) => e.maNghiepVu == wPhieuXuat.maNX).moTa,
                                  items:
                                      lstKieuXuat.hasValue
                                          ? lstKieuXuat.value!
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
                                    rPhieuXuat.updatePhieuXuat(
                                      PhieuXuatString.maNX,
                                      o,
                                      wPhieuXuat.phieu,
                                      userName: userName,
                                    );
                                  },
                                  label: 'Kiểu xuất',
                                ),
                              ),
                              Gap(20),
                              SizedBox(
                                width: 250,
                                child: LabelTextfield(
                                  enabled: !wPhieuXuat.khoa,
                                  label: 'Ký hiệu hóa đơn',
                                  controller: TextEditingController(text: wPhieuXuat.kyHieu),
                                  onChanged: (val) {
                                    rPhieuXuat.updatePhieuXuat(
                                      PhieuXuatString.kyHieu,
                                      val,
                                      wPhieuXuat.phieu,
                                      userName: userName,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Combobox(
                                  readOnly: true,
                                  enabled: !wPhieuXuat.khoa,
                                  selected: wPhieuXuat.pttt,
                                  items: [
                                    ComboboxItem(value: 'TM', title: ['TM']),
                                    ComboboxItem(value: 'CK', title: ['CK']),
                                    ComboboxItem(value: 'TM/CK', title: ['TM/CK']),
                                  ],
                                  onChanged: (val, o) {
                                    rPhieuXuat.updatePhieuXuat(
                                      PhieuXuatString.pttt,
                                      val,
                                      wPhieuXuat.phieu,
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
                                  enabled: !wPhieuXuat.khoa,
                                  selected: wPhieuXuat.maKhach,
                                  items:
                                      lstKhach.hasValue
                                          ? lstKhach.value!
                                              .map((e) => ComboboxItem(value: e.maKhach, title: [e.maKhach, e.tenKH]))
                                              .toList()
                                          : [],
                                  spacing: 8,
                                  // isChangeEmpty: false,
                                  label: 'Mã khách',
                                  onChanged: (val, o) {
                                    rPhieuXuat.updateMaKhach(val, wPhieuXuat.phieu, userName: userName);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 440,
                                child: LabelTextfield(
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text:
                                        wPhieuXuat.maKhach == null ||  wPhieuXuat.maKhach!.isEmpty
                                            ? ''
                                            : lstKhach.value!.firstWhere((e) => e.maKhach == wPhieuXuat.maKhach).tenKH,
                                  ),
                                ),
                              ),
                              Gap(20),
                              SizedBox(
                                width: 250,
                                child: LabelTextfield(
                                  enabled: !wPhieuXuat.khoa,
                                  label: 'Số hóa đơn',
                                  controller: TextEditingController(text: wPhieuXuat.soHD),
                                  onChanged: (val) {
                                    rPhieuXuat.updatePhieuXuat(
                                      PhieuXuatString.soHD,
                                      val,
                                      wPhieuXuat.phieu,
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
                                  enabled: !wPhieuXuat.khoa,
                                  controller: TextEditingController(text: wPhieuXuat.dienGiai),
                                  onChanged: (val) {
                                    rPhieuXuat.updatePhieuXuat(
                                      PhieuXuatString.dienGiai,
                                      val,
                                      wPhieuXuat.phieu,
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
                                  enabled: !wPhieuXuat.khoa,
                                  label: 'Ngày hóa đơn',
                                  spacing: 23,
                                  initialDate: Helper.stringToDate(wPhieuXuat.ngayCT),
                                  onChanged: (DateTime? value) {
                                    rPhieuXuat.updatePhieuXuat(
                                      PhieuXuatString.ngayCT,
                                      Helper.dateFormatYMD(value),
                                      wPhieuXuat.phieu,
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
                            child: BanHangCT(
                              phieuXuatNotifier: rPhieuXuat,
                              userName: userName,
                              phieuXuatModel: wPhieuXuat,
                            ),
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
                                    // isChangeEmpty: false,
                                    enabled: !wPhieuXuat.khoa,
                                    selected: wPhieuXuat.tkNo,
                                    items:
                                        lstBangTaiKhoan.hasValue
                                            ? lstBangTaiKhoan.value!
                                                .map((e) => ComboboxItem(value: e.maTK, title: [e.maTK, e.tenTK]))
                                                .toList()
                                            : [],
                                    onChanged: (val, o) {
                                      rPhieuXuat.updatePhieuXuat(
                                        PhieuXuatString.tkNo,
                                        val,
                                        wPhieuXuat.phieu,
                                        userName: userName,
                                      );
                                    },
                                    label: 'TK Nợ/Có',
                                  ),
                                ),
                                SizedBox(
                                  width: 85,
                                  child: Combobox(
                                    selected: wPhieuXuat.tkCo,
                                    // isChangeEmpty: false,
                                    enabled: !wPhieuXuat.khoa,
                                    menuWidth: 410,
                                    columnWidth: [80, 320],
                                    items:
                                        lstBangTaiKhoan.hasValue
                                            ? lstBangTaiKhoan.value!
                                                .map((e) => ComboboxItem(value: e.maTK, title: [e.maTK, e.tenTK]))
                                                .toList()
                                            : [],
                                    onChanged: (val, o) {
                                      rPhieuXuat.updatePhieuXuat(
                                        PhieuXuatString.tkCo,
                                        val,
                                        wPhieuXuat.phieu,
                                        userName: userName,
                                      );
                                    },
                                  ),
                                ),
                                Gap(20),
                                Checkbox(
                                  enabled: !wPhieuXuat.khoa,
                                  state: wPhieuXuat.kChiuThue ? CheckboxState.checked : CheckboxState.unchecked,
                                  onChanged: (val) {
                                    rPhieuXuat.updatePhieuXuat(
                                      PhieuXuatString.kChiuThue,
                                      val.index == 0 ? 1 : 0,
                                      wPhieuXuat.phieu,
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
                                    controller: TextEditingController(text: Helper.numFormat(wPhieuXuat.congTien)),
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
                                      wPhieuXuat.kChiuThue
                                          ? null
                                          : LabelCombobox(
                                            selected: wPhieuXuat.tkVatNo,
                                            menuWidth: 410,
                                            enabled: !wPhieuXuat.khoa,
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
                                              rPhieuXuat.updatePhieuXuat(
                                                PhieuXuatString.tkVatNo,
                                                val,
                                                wPhieuXuat.phieu,
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
                                      wPhieuXuat.kChiuThue
                                          ? null
                                          : Combobox(
                                            selected: wPhieuXuat.tkVatCo,
                                            enabled: !wPhieuXuat.khoa,
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
                                              rPhieuXuat.updatePhieuXuat(
                                                PhieuXuatString.tkVatCo,
                                                val,
                                                wPhieuXuat.phieu,
                                                userName: userName,
                                              );
                                            },
                                          ),
                                ),
                                Gap(30),
                                SizedBox(
                                  width: 150,
                                  child:
                                      wPhieuXuat.kChiuThue
                                          ? null
                                          : Focus(
                                            onFocusChange: (b) {
                                              if (!b) {
                                                final value = (wPhieuXuat.congTien * wPhieuXuat.thueSuat) / 100;
                                                rPhieuXuat.updatePhieuXuat(
                                                  PhieuXuatString.tienThue,
                                                  value,
                                                  wPhieuXuat.phieu,
                                                  userName: userName,
                                                );
                                              }
                                            },
                                            child: LabelTextfield(
                                              label: 'Thuế suất(%)',
                                              controller: TextEditingController(text: wPhieuXuat.thueSuat.toString()),
                                              onChanged: (val) {
                                                rPhieuXuat.updatePhieuXuat(
                                                  PhieuXuatString.thueSuat,
                                                  val,
                                                  wPhieuXuat.phieu,
                                                  userName: userName,
                                                );
                                              },
                                              enabled: !wPhieuXuat.khoa,
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
                                        rPhieuXuat.updatePhieuXuat(
                                          PhieuXuatString.tienThue,
                                          wPhieuXuat.tienThue,
                                          wPhieuXuat.phieu,
                                          userName: userName,
                                        );
                                      }
                                    },
                                    child: LabelTextfield(
                                      enabled: !wPhieuXuat.khoa && !wPhieuXuat.kChiuThue,
                                      label: 'Tiền thuế GTGT',
                                      controller: TextEditingController(text: Helper.numFormat(wPhieuXuat.tienThue)),
                                      onChanged: (val) {
                                        rPhieuXuat.updateTienThueGTGT(
                                          Helper.numFormatToDouble(val),
                                          wPhieuXuat.phieu,
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
                                      text: Helper.numFormat(wPhieuXuat.congTien + wPhieuXuat.tienThue),
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
                      text: '${wPhieuXuat.stt}/${wPhieuXuat.countRow}',
                      last: () {
                        if (wPhieuXuat.stt.toString() != wPhieuXuat.countRow) {
                          rPhieuXuat.getLastPhieuXuat(ref: ref);
                        }
                      },
                      next: () {
                        if (wPhieuXuat.stt.toString() != wPhieuXuat.countRow) {
                          rPhieuXuat.onMovePhieuXuat(wPhieuXuat.stt! + 1, ref: ref);
                        }
                      },
                      back: () {
                        if (wPhieuXuat.stt != 1) {
                          rPhieuXuat.onMovePhieuXuat(wPhieuXuat.stt! - 1, ref: ref);
                        }
                      },
                      first: () {
                        if (wPhieuXuat.stt != 1) {
                          rPhieuXuat.onMovePhieuXuat(1, ref: ref);
                        }
                      },
                    ),
                  ],
                ),
      ),
    );
  }
}
