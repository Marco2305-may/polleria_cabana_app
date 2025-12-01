import 'package:flutter/material.dart';
import '../../services/admin/loginAdmin_service.dart';
import '../../services/role_service.dart';
import 'homeAdmin_screen.dart';

class LoginAdminScreen extends StatefulWidget {
  const LoginAdminScreen({super.key});

  @override
  State<LoginAdminScreen> createState() => _LoginAdminScreenState();
}

class _LoginAdminScreenState extends State<LoginAdminScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final loginService = LoginService();
  bool loading = false;

  Future<void> login() async {
    setState(() => loading = true);
    final user = await loginService.login(emailCtrl.text.trim(), passCtrl.text.trim());
    setState(() => loading = false);

    if (user != null) {
      final rol = await RoleService().obtenerRol(user.uid);

      if (rol != "admin") {
        await loginService.logout();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Acceso permitido solo a ADMINISTRADORES"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeAdminScreen(adminId: user.uid)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email o contraseña incorrectos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final brown = Colors.brown[800];

    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // LOGO
              Icon(Icons.restaurant_menu_rounded,
                  size: 70, color: brown),

              const SizedBox(height: 10),
              Text(
                "Panel Administrador",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: brown,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Pollería La Cabaña",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.brown.shade600,
                ),
              ),

              const SizedBox(height: 25),

              // EMAIL
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  labelText: "Correo",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 15),

              // PASSWORD
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 25),

              // BOTÓN LOGIN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brown,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Ingresar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

