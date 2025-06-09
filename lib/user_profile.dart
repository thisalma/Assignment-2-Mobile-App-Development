class UserProfile {
  static final UserProfile _instance = UserProfile._internal();

  factory UserProfile() {
    return _instance;
  }

  UserProfile._internal();

  String name = '';
  String email = '';
  String contact = '';
  String address = '';
}
