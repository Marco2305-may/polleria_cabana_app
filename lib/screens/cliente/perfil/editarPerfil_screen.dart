import 'package:flutter/material.dart';
import '../../../services/cliente/usuarioCliente_service.dart';
import '../../../models/usuario.dart';

class EditarPerfilScreen extends StatefulWidget {
  final Usuario usuario;

  const EditarPerfilScreen({super.key, required this.usuario});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final service = UsuarioClienteService();
  final nombre = TextEditingController();
  final telefono = TextEditingController();

  @override
  void initState() {
    super.initState();
    nombre.text = widget.usuario.nombre;
    telefono.text = widget.usuario.telefono;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nombre,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: telefono,
              decoration: const InputDecoration(labelText: "Teléfono"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("Guardar Cambios"),
              onPressed: () async {
                await service.actualizarUsuario(widget.usuario.id, {
                  "nombre": nombre.text.trim(),
                  "telefono": telefono.text.trim(),
                });

                if (mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
