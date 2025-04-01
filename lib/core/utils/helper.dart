import 'package:intl/intl.dart';

class Helper{
  static String? numFormat(dynamic number){
    if(number==null) return null;
    else{
      try{

        String strNum = number.toString();
        if(strNum.contains(',')) strNum = strNum.replaceAll(',', '');
        final num = double.parse(strNum);
        return NumberFormat('#,###').format(num);
      }catch(e){
        return number;
      }
    }

  }

  static double numFormatToDouble(String value){
    if(value.isNotEmpty){
      value = value.replaceAll(',', '');
      return double.parse(value);
    }
    return 0;
  }

  static String sqlDateTimeNow({bool hasTime = false}){
    if(hasTime){
      return  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    }else{
      return  DateFormat('yyyy-MM-dd').format(DateTime.now());

    }
  }

  static String dateFormatDMY(DateTime date)=>DateFormat('dd/MM/yyyy').format(date);
  static String stringFormatDMY(String? date){
    if(date==''  || date == null){
      return '';
    }else{
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
    }
  }
  static dateFormatYMD(DateTime? date){
    if(date==null) {
      return null;
    } else {
      return DateFormat('yyyy-MM-dd').format(date);
    }
  }

  static DateTime? stringToDate(String? date){
    if(date == null || date == ''){
      return null;
    }else{
      return DateTime.parse(date);
    }
  }

  static String stringDateFormatYMD(String? date){
    if(date!=null){
      final str = date.split('/');
      return "${str.last}-${str[1]}-${str.first}";

    }else{
      return '';
    }
  }
}