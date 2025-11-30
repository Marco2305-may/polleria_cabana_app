import 'package:flutter/material.dart';
import '../../../services/cliente/usuarioCliente_service.dart';
import '../../../models/usuario.dart';

class CambiarPasswordScreen extends StatefulWidget {
  final Usuario usuario;
  const CambiarPasswordScreen({super.key, required this.usuario});

  @override
  State<CambiarPasswordScreen> createState() => _CambiarPasswordScreenState();
}

class _CambiarPasswordScreenState extends State<CambiarPasswordScreen> {
  final service = UsuarioClienteService();

  bool validado = false;
  final passwordActual = TextEditingController();
  final nuevaPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cambiar Contraseña")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (!validado) ...[
              const Text(
                "Confirma tu correo ingresando tu contraseña actual",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordActual,
                obscureText: true,
                decoration:
                const InputDecoration(labelText: "Contraseña actual"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Confirmar"),
                onPressed: () async {
                  bool ok = await service.verificarCorreo(
                    widget.usuario.correo,
                    passwordActual.text.trim(),
                  );

                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Contraseña incorrecta")),
                    );
                    return;
                  }

                  setState(() => validado = true);
                },
              )
            ],

            if (validado) ...[
              TextField(
                controller: nuevaPassword,
                obscureText: true,
                decoration:
                const InputDecoration(labelText: "Nueva contraseña"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Cambiar contraseña"),
                onPressed: () async {
                  await service.cambiarPassword(
                    nuevaPassword.text.trim(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Contraseña actualizada")),
                  );

                  if (mounted) Navigator.pop(context);
                },
              ),
            ]
          ],
        ),
      ),
    );
  }
}
