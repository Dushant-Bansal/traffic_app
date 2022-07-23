class AppUser {
  AppUser({
    required this.name,
    required this.mailId,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
        "name": name,
        "email": mailId,
      };

  final String name;
  final String mailId;
  final String password;

  String get getName => name;
  String get getMail => mailId;
}
