import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  var bytes = utf8.encode(password); // 비밀번호를 바이트 배열로 변환
  var digest = sha256.convert(bytes); // SHA-256으로 해시 값 생성
  return digest.toString(); // 해시 값을 문자열로 반환
}

bool verifyPassword(String inputPassword, String storedHash) {
  var hashedPassword = hashPassword(inputPassword); // 입력된 비밀번호를 해시 값으로 변환
  return hashedPassword == storedHash; // 저장된 해시 값과 일치하는지 비교
}
