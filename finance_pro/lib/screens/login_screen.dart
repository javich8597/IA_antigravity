import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../services/biometric_auth_service.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _isLogin = true;
  bool _biometricsAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final available = await biometricService.isBiometricAvailable();
    if (mounted) setState(() => _biometricsAvailable = available);
  }

  Future<void> _submitBiometric() async {
    final authSuccess = await biometricService.authenticate();
    if (authSuccess) {
      // In a real scenario, you'd store the session/refresh token securely
      // and restore it here. For MVP, we alert the user if they're not logged in Supabase yet.
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        // Already implicitly authenticated by Supabase
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, inicia sesión con correo y contraseña primero.')),
          );
        }
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      if (_isLogin) {
        await supabaseService.signInWithEmail(
          _emailController.text.trim(), 
          _passwordController.text,
        );
      } else {
        await supabaseService.signUpWithEmail(
          _emailController.text.trim(), 
          _passwordController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro exitoso. Revisa tu email (si aplica) o inicia sesión.')),
          );
          setState(() => _isLogin = true); // Switch to login after register
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ha ocurrido un error inesperado'), backgroundColor: Colors.redAccent));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.primaryContainer.withAlpha(25), // ~0.1 opacity
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_balance_wallet_rounded, size: 80, color: Color(0xFF6366F1)),
                  const SizedBox(height: 24),
                  Text(
                    'Think Better',
                    style: GoogleFonts.outfit(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Inteligencia y control financiero.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 48),
                  
                  // Form Fields
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: Colors.black12,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: Colors.black12,
                    ),
                    obscureText: true,
                    validator: (val) => val == null || val.length < 6 ? 'Mínimo 6 caracteres' : null,
                  ),
                  const SizedBox(height: 32),
                  
                  // Submit Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isLoading 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(_isLogin ? 'Iniciar Sesión' : 'Crear Cuenta', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  
                  if (_biometricsAvailable && _isLogin) ...[
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _submitBiometric,
                      icon: const Icon(Icons.fingerprint, size: 28),
                      label: const Text('Ingresar con Biometría', style: TextStyle(fontSize: 16)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        foregroundColor: AppColors.accentColor,
                        side: const BorderSide(color: AppColors.accentColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),
                  
                  // Toggle Button
                  TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: Text(
                      _isLogin ? '¿No tienes cuenta? Regístrate' : '¿Ya tienes cuenta? Inicia sesión',
                      style: const TextStyle(color: Color(0xFF818CF8)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
