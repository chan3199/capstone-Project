class Login {
  final String accountName;
  final String user_id;

  Login(this.accountName, this.user_id);

  Login.fromJson(Map<String, dynamic> json)
      : accountName = json['accountName'],
        user_id = json['user_id'];

  Map<String, dynamic> toJson() => {
        'accountName': accountName,
        'user_id': user_id,
      };
}
