import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/role_service.dart';
import '../home/homeCliente_screen.dart';
import 'loginCliente_screen.dart';

class CheckClienteAuth extends StatelessWidget {
  const CheckClienteAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return LoginClienteScreen();

        final user = snapshot.data!;

        return FutureBuilder(
          future: RoleService().obtenerRol(user.uid),
          builder: (_, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final rol = snap.data;

            if (rol != "cliente") {
              FirebaseAuth.instance.signOut();
              return LoginClienteScreen();
            }

            return HomeScreen(idUsuario: user.uid);
          },
        );
      },
    );
  }
}