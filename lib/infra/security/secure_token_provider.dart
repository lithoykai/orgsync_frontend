import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../domain/services/token_provider.dart';

@Injectable(as: TokenProvider)
class SecureTokenProvider implements TokenProvider {
  static const _key = 'orgsync_jwt';

  final FlutterSecureStorage _storage;

  SecureTokenProvider()
      : _storage = const FlutterSecureStorage(
          webOptions: WebOptions(),
        );

  @override
  Future<void> setToken(String token) async {
    await _storage.write(key: _key, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: _key);
  }

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: _key);
  }
}
