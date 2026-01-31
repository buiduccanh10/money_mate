import 'package:local_auth/local_auth.dart';

abstract class LocalAuthRepository {
  Future<bool> authenticate(String reason);
  Future<bool> canCheckBiometrics();
  Future<bool> isDeviceSupported();
}

class LocalAuthRepositoryImpl implements LocalAuthRepository {
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(localizedReason: reason);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> canCheckBiometrics() => _auth.canCheckBiometrics;

  @override
  Future<bool> isDeviceSupported() => _auth.isDeviceSupported();
}
