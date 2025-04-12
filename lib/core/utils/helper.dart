import 'package:intl/intl.dart';

class Helper{
  static String? numFormat(dynamic number){
    if(number==null) {
      return null;
    } else{
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

  static double numFormatToDouble(String value, {bool keepChar = false}){
    if(value.isNotEmpty){

      if(keepChar){
        value = value.replaceAll(',', '.');
      }else{
        value = value.replaceAll(',', '');
      }

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

  static String dateNowDMY()=>DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

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
    try{
      if(date == null || date == ''){
        return null;
      }else{
        return DateTime.parse(date);
      }
    }catch(e){
      final tmp = DateTime.parse(stringDateFormatYMD(date));
      return tmp;
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
  static String getQuarterNow() {
    int month = DateTime.now().month;
    int quarter = ((month - 1) ~/ 3) + 1;
    return '$quarter';
  }

  static String getLastDateInMonth(String month, String year){
    return DateTime(int.parse(year), int.parse(month)+1, 0).day.toString();
  }

  static String formatMonth(dynamic month){
    return month.toString().length==1? "0$month": month;
  }
}