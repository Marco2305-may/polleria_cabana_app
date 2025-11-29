import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../services/cliente/authCliente_service.dart';
import '../../../widgets/custom_buttom.dart';


class LoginClienteScreen extends StatefulWidget {
  const LoginClienteScreen({super.key});

  @override
  _LoginClienteScreenState createState() => _LoginClienteScreenState();
}

class _LoginClienteScreenState extends State<LoginClienteScreen> {
  final _service = AuthClienteService();
  final email = TextEditingController();
  final pass = TextEditingController();

  bool loading = false;

  Future<void> _loginTest() async {
    setState(() => loading = true);

    final user = await _service.loginCliente(email.text.trim(), pass.text.trim());

    setState(() => loading = false);

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("LOGIN OK → Bienvenido ${user.displayName ?? 'Cliente'}"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/homeCliente');

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("ERROR → Credenciales incorrectas"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // ⭐ Fondo
          Positioned.fill(
            child: Image.network(
              "https://firebasestorage.googleapis.com/v0/b/db-polleria-cabana.firebasestorage.app/o/Pollo_login.png?alt=media&token=86e917d3-6ba8-4e70-8583-1c66f7d0b7f1",
              fit: BoxFit.cover,
            ),
          ),

          // ⭐ Blur + Oscurecer (para que el login se vea)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),

          // ⭐ Contenido
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.90),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    // Título
                    const Text(
                      "BIENVENIDO",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔑 Campo correo
                    TextField(
                      controller: email,
                      decoration: InputDecoration(
                        labelText: "Correo",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // 🔒 Campo contraseña
                    TextField(
                      controller: pass,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // 🔥 BOTÓN LOGIN
                    CustomButton(
                      text: "Ingresar",
                      loading: loading,
                      onPressed: _loginTest,
                    ),

                    const SizedBox(height: 10),
                    // 📌 BOTÓN REGISTRO
                    CustomButton(
                      text: "Registrarse",
                      onPressed: () {
                        Navigator.pushNamed(context, '/registroCliente');
                      },
                    ),

                    const Divider(height: 30),

                    // 🔥 GOOGLE LOGIN
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _service.loginWithGoogle();
                        },
                        icon: Image.network(
                          "https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png",
                          height: 25,
                        ),
                        label: const Text("Continuar con Google"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}



