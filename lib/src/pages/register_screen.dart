import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juego_movil/auth/service/auth_services.dart';
import 'login_screen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Los controladores deben estar en el State y disponerse (dispose) correctamente
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondologin.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradiente overlay oscuro
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF13142B).withValues(alpha: 0.5),
                  const Color(0xFF18132B).withValues(alpha: 0.85),
                ],
              ),
            ),
          ),
          // Contenido principal
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFA776).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFFFA776).withValues(alpha: 0.5),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFA776).withValues(alpha: 0.4),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.pets_rounded,
                            size: 60,
                            color: Color(0xFFFFA776),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'title_login'.tr,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Color(0xFFFFA776),
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'create_account'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Card del formulario
                    Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF1A1C36).withValues(alpha: 0.8),
                            const Color(0xFF281E3B).withValues(alpha: 0.75),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF5C93FC).withValues(alpha: 0.55),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF5C93FC).withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: nameController,
                            hint: 'full_name'.tr,
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: emailController,
                            hint: 'email'.tr,
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: passwordController,
                            hint: 'password'.tr,
                            icon: Icons.lock_outline,
                            obscureText: true,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: confirmPasswordController,
                            hint: 'confirm_password'.tr,
                            icon: Icons.lock_outline,
                            obscureText: true,
                          ),
                          const SizedBox(height: 24),
                          // Botón Register
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                _handleRegister(
                                  context,
                                  nameController.text,
                                  emailController.text,
                                  passwordController.text,
                                  confirmPasswordController.text,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFA776),
                                foregroundColor: const Color(0xFF13142B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 8,
                                shadowColor: const Color(0xFFFFA776).withValues(alpha: 0.5),
                              ),
                              child: Text(
                                'register_btn_caps'.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'already_have_account'.tr,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const Login()),
                            );
                          },
                          child: Text(
                            'login_text'.tr,
                            style: const TextStyle(
                              color: Color(0xFFFFA776),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para no repetir código de los campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.8)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF5C93FC).withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF5C93FC).withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5C93FC), width: 2),
        ),
      ),
    );
  }

  void _handleRegister(
    BuildContext context,
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async { // Añadido async
    
    // Validaciones básicas
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar(context, 'fill_fields'.tr, Colors.red);
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar(context, 'passwords_not_match'.tr, Colors.red);
      return;
    }

    if (password.length < 6) {
      _showSnackBar(context, 'password_length'.tr, Colors.red);
      return;
    }

    final authService = AuthServices();

    try {
    // Intentamos registrar al usuario en Supabase
    await authService.signUpWithEmailPassword(email, password, name);

    // Si todo sale bien:
    if (!context.mounted) return;
    _showSnackBar(context, 'register_success'.tr, Colors.green);
    
    // Regresar al login o dejar que AuthGate te mande al Home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
    );

  } catch (e) {
    // Si hay error (ej: el email ya está registrado)
    if (!context.mounted) return;
    _showSnackBar(context, '${'register_error'.tr} ${e.toString()}', Colors.red);
    return;
  }

    // Regresar al login después de 2 segundos
    await Future.delayed(const Duration(seconds: 1));
    
    // SOLUCIÓN AL ERROR DE ASYNC GAP: 
    // Verificamos si el widget sigue "vivo" en la pantalla antes de navegar
    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}