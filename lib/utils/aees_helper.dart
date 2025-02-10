import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class AESHelper {
  static final _secretKey = 'TRACKROUTE_PRO-encryption-key'; // Use a secure key and store it safely
  // static final _key = encrypt.Key.fromUtf8(_secretKey.padRight(32)); // Ensure the key is 32 bytes
  static final _key = encrypt.Key.fromUtf8(_secretKey.padRight(32).substring(0, 32));  // Ensure the key is 32 bytes
  static final _iv = encrypt.IV.fromLength(16); // Use a 16-byte IV

  // Encrypt function
  static String encryptText(String plainText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64; // Return the encrypted text in Base64 format
  }

  // Decrypt function
  static Future<String> decryptText(String encryptedText) async {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted =
    encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedText), iv: _iv);
    print(decrypted); // Print the decrypted text
    return decrypted; // Return the decrypted text
  }
}
