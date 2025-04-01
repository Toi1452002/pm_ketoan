import '../../core/core.dart';

class PCvaGTModel{
  final int? id;
  final String maNV;
  final String maPC;
  final String moTa;
  double soTieuChuan;
  final double soThucTe;

   PCvaGTModel({
    this.id,
    required this.maNV,
    required this.maPC,
    this.moTa = '',
    required this.soTieuChuan,
    required this.soThucTe,
  });

  Map<String, dynamic> toMap() {
    return {
      PCvaGTString.id: id,
      PCvaGTString.maNV: maNV,
      PCvaGTString.maPC: maPC,
      PCvaGTString.soTieuChuan: double.parse(soTieuChuan.toString()),
      PCvaGTString.soThucTe: double.parse(soThucTe.toString()),
    };
  }

  factory PCvaGTModel.fromMap(Map<String, dynamic> map) {
    return PCvaGTModel(
      id: map[PCvaGTString.id],
      maNV: map[PCvaGTString.maNV]??'',
      maPC: map[PCvaGTString.maPC]??'',
      moTa: map['MoTa']??'',
      soTieuChuan: map[PCvaGTString.soTieuChuan]==null?0: double.parse(map[PCvaGTString.soTieuChuan].toString()),
      soThucTe: map[PCvaGTString.soThucTe]==null ? 0 : double.parse(map[PCvaGTString.soThucTe].toString()),
    );
  }

  PCvaGTModel copyWith({
    int? id,
    String? maNV,
    String? maPC,
    String? moTa,
    double? soTieuChuan,
    double? soThucTe,
  }) {
    return PCvaGTModel(
      id: id ?? this.id,
      maNV: maNV ?? this.maNV,
      maPC: maPC ?? this.maPC,
      moTa: moTa ?? this.moTa,
      soTieuChuan: soTieuChuan ?? this.soTieuChuan,
      soThucTe: soThucTe ?? this.soThucTe,
    );
  }
}
class MoTaPCGTModel{
  final int? id;
  final String ma;
  final String moTa;

  const MoTaPCGTModel({
    this.id,
    required this.ma,
    required this.moTa,
  });


  factory MoTaPCGTModel.fromMap(Map<String, dynamic> map) {
    return MoTaPCGTModel(
      id: map[MoTaPCGTTLString.id] as int,
      ma: map[MoTaPCGTTLString.ma] as String,
      moTa: map[MoTaPCGTTLString.moTa] as String,
    );
  }
}

abstract class MoTaPCGTTLString {
  static const id = "ID";
  static const ma = "Ma";
  static const moTa = "MoTa";
}

abstract class PCvaGTString {
  static const id = "ID";
  static const maNV = "MaNV";
  static const maPC = "MaPC";
  static const soTieuChuan = "SoTieuChuan";
  static const soThucTe = "SoThucTe";
}