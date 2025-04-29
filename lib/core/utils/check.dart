class Check{
  bool isInteger(dynamic number) {
    if(number.runtimeType == String){
      final x = double.parse(number);
      return x.isFinite && x == x.floor();
    }
    return number.isFinite && number == number.floor();
  }


}