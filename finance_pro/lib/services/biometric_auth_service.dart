import 'package:local_auth/local_auth.dart';
import 'package:flutter/foundation.dart';

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    if (kIsWeb) return false; // Not supported on web
    try {
      final canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    if (kIsWeb) return false;
    try {
      return await _auth.authenticate(
        localizedReason: 'Inicia sesión en Think Better para acceder a tus datos financieros',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Allow PIN fallback
        ),
      );
    } catch (e) {
      print('Biometric auth error: $e');
      return false;
    }
  }
}

final biometricService = BiometricAuthService();
