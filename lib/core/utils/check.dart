class Check{
  bool isInteger(dynamic number) {
    return number.isFinite && number == number.floor();
  }


}