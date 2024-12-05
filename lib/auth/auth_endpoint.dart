// import 'package:serverpod/server.dart';
// import 'package:crypto/crypto.dart';
// import 'dart:convert';

// class AuthEndpoint extends Endpoint {
//   Future<bool> login(Session session, String email, String password) async {
//     final result = await session.db.query(
//       'SELECT password_hash FROM users WHERE email = @email',
//       substitutionValues: {'email': email},
//     );

//     if (result.isEmpty) {
//       return false;
//     }

//     var passwordHash = sha256.convert(utf8.encode(password)).toString();
//     return result[0]['password_hash'].toString() == passwordHash;
//   }
// }
