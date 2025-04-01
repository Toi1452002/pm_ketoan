import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';

class NhanVienNotifier extends StateNotifier<List<NhanVienModel>> {
  NhanVienNotifier() : super([]){
    getListNhanVien();
  }

  final _sqlRepository = const SqlRepository(tableName: TableName.nhanVien);


  Future<int> addNhanVien(NhanVienModel nv) async{
    try{
      return await _sqlRepository.addRow(nv.toMap());
    }catch(e){
      errorSql(e);
      return 0;
    }
  }

  Future<int> updateNhanVien(NhanVienModel nv) async{
    try{
      return await _sqlRepository.updateRow(nv.toMap(),where: "ID = ${nv.id}");
    }catch(e){
      errorSql(e);
      return 0;
    }
  }

  Future<int> deleteNhanVien(String maNV) async{
    try{
      return await _sqlRepository.delete(where: "MaNV = '$maNV'");
    }catch(e){
      errorSql(e);
      return 0;
    }
  }

  Future<void> getListNhanVien() async{
    try{
      // String where = "1=? ";
      // List<Object?> whereArgs = [1];
      // if(filter!=null){
      //   if(filter.maNV!=null){
      //     where += "AND ${TableNhanVien.maNV} = ? ";
      //     whereArgs.add(filter.maNV);
      //   }
      //   if(filter.hoTen!=null){
      //     where += "AND ${TableNhanVien.hoTen} = ? ";
      //     whereArgs.add(filter.hoTen);
      //   }
      //   if(filter.phai!=null){
      //     where += "AND ${TableNhanVien.phai} = ? ";
      //     whereArgs.add(filter.phai == 'Nam' ? 0 : 1);
      //   }
      //   if(filter.ngaySinh!=null){
      //     where += "AND ${TableNhanVien.ngaySinh} = ? ";
      //     whereArgs.add(Helper.stringDateFormatYMD(filter.ngaySinh));
      //   }
      //   if(filter.diaChi!=null){
      //     where += "AND ${TableNhanVien.diaChi} = ? ";
      //     whereArgs.add(filter.diaChi);
      //   }
      //   if(filter.trinhDo!=null){
      //     where += "AND ${TableNhanVien.trinhDo} = ? ";
      //     whereArgs.add(filter.trinhDo);
      //   }
      //   if(filter.chuyenMon!=null){
      //     where += "AND ${TableNhanVien.chuyenMon} = ? ";
      //     whereArgs.add(filter.chuyenMon);
      //   }
      // }
      // final data = await  _sqlRepository.getData(orderBy: NhanVienString.maNV,where: where,whereArgs: whereArgs);
      final data = await  _sqlRepository.getData(orderBy: NhanVienString.maNV);
      state = data.map((e)=>NhanVienModel.fromMap(e)).toList();
    }catch(e){
      errorSql(e);
    }
  }

  Future<void> addPCVaGT(List<PCvaGTModel> pcgt) async{
    try{
      await _sqlRepository.addRows(pcgt.map((e)=>e.toMap()).toList(),tableNameOther: TableName.pcVaGT);
    }catch(e){
      errorSql(e);
    }
  }
}


class PCvaGTNotifier extends StateNotifier<List<PCvaGTModel>> {
  PCvaGTNotifier() : super([]){
    getPCGT();
  }
  final _sqlRepository = const SqlRepository(tableName: '');

  Future<void> getPCGT({String maNV = ''}) async{
    try{
      final data = await _sqlRepository.getCustomData('''
        SELECT a.Ma as MaPC, a.MoTa, b.MaNV, b.SoTieuChuan, b.SoThucTe FROM TDM_MoTaPCGTTL a left join TDM_PCvaGT b on a.Ma = b.MaPC and b.MaNV = '$maNV'
      ''');
      state = data.map((e)=>PCvaGTModel.fromMap(e)).toList();
    }catch(e){
      errorSql(e);
    }
  }

  void updateData(String maPC, dynamic value){
    state.firstWhere((e)=>e.maPC == maPC).soTieuChuan = value;
  }

  Future<void> addData(String maNV) async{
    try{
      await _sqlRepository.delete(tableNameOther: TableName.pcVaGT,where: "MaNV = '$maNV'");
      await _sqlRepository.addRows(state.map((e){
        e = e.copyWith(maNV: maNV);
        return e.toMap();
      }).toList(),tableNameOther: TableName.pcVaGT);
    }catch(e){
      errorSql(e);
    }
  }


}
