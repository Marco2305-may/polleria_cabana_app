import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../services/cliente/usuarioCliente_service.dart';
import '../../../models/usuario.dart';
import '../../../widgets/cambiarPassword_widget.dart';
import '../auth/loginCliente_screen.dart';
import 'editarPerfil_screen.dart';

class PerfilClienteScreen extends StatefulWidget {
  final String idUsuario;

  const PerfilClienteScreen({super.key, required this.idUsuario});

  @override
  State<PerfilClienteScreen> createState() => _PerfilClienteScreenState();
}

class _PerfilClienteScreenState extends State<PerfilClienteScreen> {
  final service = UsuarioClienteService();
  Usuario? usuario;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    usuario = await service.obtenerUsuario(widget.idUsuario);
    setState(() => loading = false);
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginClienteScreen()),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // FOTO DE PERFIL → Google o UI-Avatar
    String? photo = user?.photoURL;
    if (photo == null || photo.isEmpty) {
      photo =
      "https://ui-avatars.com/api/?name=${usuario?.nombre}&background=D94848&color=fff&size=200";
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFA41717),
              Color(0xFFD94848),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: loading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : usuario == null
            ? const Center(
          child: Text(
            "Error cargando perfil",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        )
            : Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6E9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // FOTO
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.amber.shade700, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: NetworkImage(photo),
                    backgroundColor: Colors.red.shade100,
                  ),
                ),

                const SizedBox(height: 20),

                // NOMBRE
                Text(
                  usuario!.nombre,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5C2C2C),
                  ),
                ),

                const SizedBox(height: 5),

                // CORREO
                Text(
                  usuario!.correo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 25),

                // TELÉFONO
                _infoItem(
                  icon: Icons.phone,
                  title: "TELÉFONO",
                  value: usuario!.telefono,
                ),

                const SizedBox(height: 25),

                // BOTÓN: Editar Perfil
                _botonPollero(
                  icon: Icons.edit,
                  text: "Editar Perfil",
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditarPerfilScreen(usuario: usuario!),
                      ),
                    );
                    _cargarUsuario();
                  },
                ),

                const SizedBox(height: 12),

                // BOTÓN: Cambiar Contraseña
                _botonPollero(
                  icon: Icons.lock,
                  text: "Cambiar Contraseña",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CambiarPasswordScreen(usuario: usuario!),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // BOTÓN: Cerrar Sesión
                _botonPollero(
                  icon: Icons.logout,
                  text: "Cerrar Sesión",
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // INFO ITEM
  Widget _infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.red.shade700, size: 28),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$title: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade900,
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // BOTÓN POLLERO PREMIUM 🐔🔥
  Widget _botonPollero({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFE23E3E),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 23),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}



