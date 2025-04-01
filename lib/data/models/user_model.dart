class UserModel{
  final int? id;
  final String userName;
  final String passWord;
  final int level;
  final String hoTen;
  final String dienThoai;
  final String diaChi;
  final String email;
  final String ghiChu;

  const UserModel({
    this.id,
    required this.userName,
    required this.passWord,
    required this.level,
    required this.hoTen,
    required this.dienThoai,
    required this.diaChi,
    required this.email,
    required this.ghiChu,
  });

  Map<String, dynamic> toMap() {
    return {
      UserString.id: id,
      UserString.userName: userName.isEmpty ? null : userName,
      UserString.passWord: passWord.isEmpty ? null : passWord,
      UserString.level: level,
      UserString.hoTen: hoTen.isEmpty ? null : hoTen,
      UserString.dienThoai: dienThoai,
      UserString.diaChi: diaChi,
      UserString.email: email,
      UserString.ghiChu: ghiChu,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map[UserString.id],
      userName: map[UserString.userName] ?? '',
      passWord: map[UserString.passWord] ?? '',
      level: map[UserString.level],
      hoTen: map[UserString.hoTen] ?? '',
      dienThoai: map[UserString.dienThoai] ?? '',
      diaChi: map[UserString.diaChi] ?? '',
      email: map[UserString.email] ?? '',
      ghiChu: map[UserString.ghiChu] ?? '',
    );
  }

  UserModel copyWith({
    int? id,
    String? userName,
    String? passWord,
    int? level,
    String? hoTen,
    String? dienThoai,
    String? diaChi,
    String? email,
    String? ghiChu,
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      passWord: passWord ?? this.passWord,
      level: level ?? this.level,
      hoTen: hoTen ?? this.hoTen,
      dienThoai: dienThoai ?? this.dienThoai,
      diaChi: diaChi ?? this.diaChi,
      email: email ?? this.email,
      ghiChu: ghiChu ?? this.ghiChu,
    );
  }
}


abstract class UserString{
  static const id = 'ID';
  static const userName = 'Username';
  static const passWord = 'Password';
  static const level = 'Level';
  static const hoTen = 'HoTen';
  static const dienThoai = 'DienThoai';
  static const diaChi = 'DiaChi';
  static const email = 'Email';
  static const ghiChu = 'GhiChu';
}