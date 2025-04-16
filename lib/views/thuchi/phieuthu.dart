import 'package:app_ketoan/views/thuchi/component/pdf_phieuthu.dart';
import 'package:app_ketoan/widgets/combobox/combobox.dart';
import 'package:app_ketoan/widgets/date_textbox.dart';
import 'package:app_ketoan/widgets/group_button_number_page.dart';
import 'package:app_ketoan/widgets/icon_button.dart';
import 'package:app_ketoan/widgets/label_textfield.dart';
import 'package:app_ketoan/widgets/pdf_widget.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

import '../../application/application.dart';
import '../../core/core.dart';
import '../../data/data.dart';

class PhieuThuView extends ConsumerStatefulWidget {
  final int? stt;

  const PhieuThuView({super.key, this.stt});

  @override
  ConsumerState createState() => _PhieuThuViewState();
}

class _PhieuThuViewState extends ConsumerState<PhieuThuView> {
  Map<String, String> pttt = {'TM': 'Tiền mặt', 'NH': 'Chuyển khoản'};
  dynamic soTien;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.stt == null) {
      ref.read(phieuThuProvider.notifier).getLastPhieuThu(ref: ref);
    } else {
      ref.read(phieuThuProvider.notifier).onMovePhieuThu(widget.stt!, ref: ref);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    final lstKhach = ref.watch(lstKhachProvider);
    final lstMaNghiepVu = ref.watch(mnvLstThuProvider);
    final lstBangTaiKhoan = ref.watch(btkListAllProvider);

    final wPhieuThu = ref.watch(phieuThuProvider);
    final rPhieuThu = ref.read(phieuThuProvider.notifier);
    final user = ref.read(userInfoProvider);

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
                if (qlKPC && !wPhieuThu!.khoa) {
                  rPhieuThu.updatePhieuThu(PhieuThuString.khoa, 1, wPhieuThu.phieu);
                }
                rPhieuThu.addPhieuThu(user!, ref);
              },
            ),
            IconDelete(
              enabled: !(wPhieuThu == null || wPhieuThu.khoa),
              onPressed: () async {
                final btn = await CustomAlert().warning(AppString.delete, title: 'PHIẾU THU');
                if (btn == AlertButton.okButton) {
                  rPhieuThu.deletePhieuThu(wPhieuThu!.id!, ref: ref);
                }
              },
            ),
            IconPrinter(
              onPressed: () async {
                if (!wPhieuThu!.khoa) {
                  rPhieuThu.updatePhieuThu(PhieuThuString.khoa, 1, wPhieuThu.phieu);
                }
                final sqlRepository = SqlRepository(tableName: TableName.ttdn);
                final diaChiCTY = await sqlRepository.getCellValue(field: TTDNString.noiDung, where: "${TTDNString.ma} = 'DC'") ?? '';
                final tenCTY = await sqlRepository.getCellValue(field: TTDNString.noiDung, where: "${TTDNString.ma} = 'TCT'") ?? '';
                if (qlXBC) {
                  showViewPrinter(
                    context,
                    PdfPhieuThuView(diaChi: diaChiCTY, tenCTY: tenCTY, phieuThu: wPhieuThu),
                  );
                } else {
                  PdfWidget().onPrint(
                    onLayout: pdfPhieuThu(
                      dateNow: Helper.dateNowDMY(),
                      tenCTy: tenCTY,
                      diaChi: diaChiCTY,
                      phieuThu: wPhieuThu,
                    ),
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
                controller: TextEditingController(text: wPhieuThu?.createdBy),
              ),
            ),
            PrimaryButton(
              enabled: !(wPhieuThu == null),
              onPressed: () {
                rPhieuThu.updatePhieuThu(PhieuThuString.khoa, !wPhieuThu!.khoa ? 1 : 0, wPhieuThu.phieu);
              },
              size: ButtonSize(.8),
              child: Text(wPhieuThu != null && wPhieuThu.khoa ? 'Sửa' : 'Khóa'),
            ),
          ],
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(10),
        child:
            wPhieuThu == null
                ? null
                : Column(
                  children: [
                    OutlinedContainer(
                      borderColor: Colors.gray.shade300,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        spacing: 10,
                        children: [
                          Row(
                            spacing: 30,
                            children: [
                              Expanded(
                                child: DateTextbox(
                                  onChanged: (val) {
                                    rPhieuThu.updatePhieuThu(
                                      PhieuThuString.ngay,
                                      Helper.dateFormatYMD(val),
                                      wPhieuThu.phieu,
                                    );
                                  },
                                  enabled: !wPhieuThu.khoa,
                                  label: 'Ngày thu',
                                  spacing: 47,
                                  initialDate: Helper.stringToDate(wPhieuThu.ngay),
                                  showClear: false,
                                ),
                              ),
                              Expanded(
                                child: LabelTextfield(
                                  onChanged: (val) {},
                                  controller: TextEditingController(text: wPhieuThu.phieu),
                                  label: 'Số phiếu',
                                  readOnly: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 30,
                            children: [
                              Expanded(
                                child: LabelCombobox(
                                  items:
                                      lstMaNghiepVu.hasValue
                                          ? lstMaNghiepVu.value!
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
                                    rPhieuThu.updatePhieuThu(PhieuThuString.maTC, o, wPhieuThu.phieu);
                                  },
                                  // isChangeEmpty: false,
                                  enabled: !wPhieuThu.khoa,
                                  selected:
                                      lstMaNghiepVu.value!
                                          .firstWhere(
                                            (e) => e.maNghiepVu == wPhieuThu.maTC,
                                            orElse: () => const MaNghiepVuModel(maNghiepVu: '', moTa: null),
                                          )
                                          .moTa,
                                  label: 'Kiểu thu',
                                  spacing: 52,
                                ),
                              ),
                              Expanded(
                                child: LabelCombobox(
                                  menuWidth: 300,
                                  enabled: !wPhieuThu.khoa,
                                  columnWidth: const [90, 200],
                                  selected: wPhieuThu.maKhach!.isEmpty ? null : wPhieuThu.maKhach,
                                  items:
                                      lstKhach.hasValue
                                          ? lstKhach.value!
                                              .map((e) => ComboboxItem(value: e.maKhach, title: [e.maKhach, e.tenKH]))
                                              .toList()
                                          : [],
                                  onChanged: (val, o) {
                                    final khach = lstKhach.value!.firstWhere(
                                      (e) => e.maKhach == val,
                                      orElse: () => const KhachHangModel(maKhach: '', tenKH: ''),
                                    );
                                    rPhieuThu.updateMaKhach(val, wPhieuThu.phieu, khach);
                                  },
                                  label: 'Mã khách',
                                ),
                              ),
                            ],
                          ),
                          LabelTextfield(
                            enabled: !wPhieuThu.khoa,
                            label: 'Tên khách',
                            onChanged: (val) {
                              rPhieuThu.updatePhieuThu(PhieuThuString.tenKhach, val, wPhieuThu.phieu);
                            },
                            spacing: 42,
                            controller: TextEditingController(text: wPhieuThu.tenKhach),
                          ),
                          LabelTextfield(
                            enabled: !wPhieuThu.khoa,
                            controller: TextEditingController(text: wPhieuThu.diaChi),
                            label: 'Địa chỉ',
                            onChanged: (val) {
                              rPhieuThu.updatePhieuThu(PhieuThuString.diaChi, val, wPhieuThu.phieu);
                            },
                            spacing: 62,
                          ),
                          LabelTextfield(
                            label: 'Người nộp tiền',
                            controller: TextEditingController(text: wPhieuThu.nguoiNop),
                            enabled: !wPhieuThu.khoa,
                            onChanged: (val) {
                              rPhieuThu.updatePhieuThu(PhieuThuString.nguoiNop, val, wPhieuThu.phieu);
                            },
                          ),
                          LabelTextfield(
                            label: 'Người thu tiền',
                            enabled: !wPhieuThu.khoa,
                            onChanged: (val) {
                              rPhieuThu.updatePhieuThu(PhieuThuString.nguoiThu, val, wPhieuThu.phieu);
                            },
                            controller: TextEditingController(text: wPhieuThu.nguoiThu),
                            spacing: 14,
                          ),
                          Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Focus(
                                  onFocusChange: (b) {
                                    if (!b) {
                                      rPhieuThu.formatSoTien(soTien);
                                    }
                                  },
                                  child: LabelTextfield(
                                    enabled: !wPhieuThu.khoa,
                                    label: 'Số tiền',
                                    controller: TextEditingController(text: Helper.numFormat(wPhieuThu.soTien)),
                                    isNumber: true,
                                    onChanged: (val) {
                                      soTien = Helper.numFormatToDouble(val);
                                      rPhieuThu.updatePhieuThu(PhieuThuString.soTien, soTien, wPhieuThu.phieu);
                                    },
                                    spacing: 62,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: LabelCombobox(
                                  columnWidth: [65, 270],
                                  selected: wPhieuThu.tkNo,
                                  enabled: !wPhieuThu.khoa,
                                  menuWidth: 350,
                                  items:
                                      lstBangTaiKhoan.hasValue
                                          ? lstBangTaiKhoan.value!
                                              .map((e) => ComboboxItem(value: e.maTK, title: [e.maTK, e.tenTK]))
                                              .toList()
                                          : [],
                                  onChanged: (val, o) {
                                    rPhieuThu.updatePhieuThu(PhieuThuString.tkNo, val, wPhieuThu.phieu);
                                  },
                                  label: 'Nợ',
                                ),
                              ),
                              Expanded(
                                child: LabelCombobox(
                                  enabled: !wPhieuThu.khoa,
                                  selected: wPhieuThu.tkCo,
                                  columnWidth: [65, 270],
                                  menuWidth: 350,
                                  items:
                                      lstBangTaiKhoan.hasValue
                                          ? lstBangTaiKhoan.value!
                                              .map((e) => ComboboxItem(value: e.maTK, title: [e.maTK, e.tenTK]))
                                              .toList()
                                          : [],
                                  onChanged: (val, o) {
                                    rPhieuThu.updatePhieuThu(PhieuThuString.tkCo, val, wPhieuThu.phieu);
                                  },
                                  label: 'Có',
                                ),
                              ),
                            ],
                          ),
                          LabelTextfield(
                            label: 'Lý do nộp',
                            enabled: !wPhieuThu.khoa,
                            onChanged: (val) {
                              rPhieuThu.updatePhieuThu(PhieuThuString.noiDung, val, wPhieuThu.phieu);
                            },
                            controller: TextEditingController(text: wPhieuThu.noiDung),
                            spacing: 44,
                          ),
                          Row(
                            spacing: 30,
                            children: [
                              Expanded(
                                flex: 4,
                                child: LabelTextfield(
                                  label: 'Số chứng từ',
                                  enabled: !wPhieuThu.khoa,
                                  onChanged: (val) {
                                    rPhieuThu.updatePhieuThu(PhieuThuString.soCT, val, wPhieuThu.phieu);
                                  },
                                  controller: TextEditingController(text: wPhieuThu.soCT),
                                  spacing: 30,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: LabelCombobox(
                                  enabled: !wPhieuThu.khoa,
                                  selected: pttt[wPhieuThu.pttt],
                                  readOnly: true,
                                  items: [
                                    ComboboxItem(value: 'Tiền mặt', title: ['Tiền mặt'], valueOther: 'TM'),
                                    ComboboxItem(value: 'Chuyển khoản', title: ['Chuyển khoản'], valueOther: 'NH'),
                                  ],
                                  onChanged: (val, o) {
                                    rPhieuThu.updatePhieuThu(PhieuThuString.pttt, o, wPhieuThu.phieu);
                                  },
                                  label: 'PTTT',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gap(5),
                    Row(
                      spacing: 5,
                      children: [
                        GroupButtonNumberPage(
                          text: "${wPhieuThu.stt}/${wPhieuThu.countRow}",
                          first: () {
                            if (wPhieuThu.stt != 1) {
                              rPhieuThu.onMovePhieuThu(1, ref: ref);
                            }
                          },
                          last: () {
                            if (wPhieuThu.stt.toString() != wPhieuThu.countRow) {
                              rPhieuThu.getLastPhieuThu(ref: ref);
                            }
                          },
                          back: () {
                            if (wPhieuThu.stt != 1) {
                              rPhieuThu.onMovePhieuThu(wPhieuThu.stt! - 1, ref: ref);
                            }
                          },
                          next: () {
                            if (wPhieuThu.stt.toString() != wPhieuThu.countRow) {
                              rPhieuThu.onMovePhieuThu(wPhieuThu.stt! + 1, ref: ref);
                            }
                          },
                        ),

                        Spacer(),
                        TextButton(size: ButtonSize(.8), onPressed: () {}, child: Text('Hiện chi tiết')),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}
