import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/service/auth_services.dart';
import 'register_screen.dart'; 
import 'lobby_screen.dart';
import '../../config/app_assets.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>{
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState(){
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                image: AssetImage(AppAssets.fondoLogin),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradiente overlay
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
                    const SizedBox(height: 40),
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
                          'welcome_back'.tr,
                          style: const TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
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
                          TextField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputStyle('email'.tr, Icons.email_outlined),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputStyle('password'.tr, Icons.lock_outline),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => _handleLogin(context, emailController.text, passwordController.text),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFA776),
                                foregroundColor: const Color(0xFF13142B),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 8,
                                shadowColor: const Color(0xFFFFA776).withValues(alpha: 0.5),
                              ),
                              child: Text(
                                'login_btn'.tr,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Texto de registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'no_account'.tr,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const Register()),
                            );
                          },
                          child: Text(
                            'register_btn'.tr,
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

  InputDecoration _inputStyle(String hint, IconData icon) {
    return InputDecoration(
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
    );
  }

  void _handleLogin(BuildContext context, String email, String password)async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('fill_fields'.tr), backgroundColor: Colors.red),
      );
      return;
    }

    //instanciamos el servicio de autenticación
    final authService = AuthServices();

    try {
      await authService.signIn(email, password);
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Lobby()),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${'error_prefix'.tr} ${e.toString()}'), backgroundColor: Colors.red),
      );

    }

  }
}