import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/role_service.dart';
import 'homeAdmin_screen.dart';
import 'loginAdmin_screen.dart';

class CheckAdminAuth extends StatelessWidget {
  const CheckAdminAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return LoginAdminScreen();

        final user = snapshot.data!;

        return FutureBuilder(
          future: RoleService().obtenerRol(user.uid),
          builder: (_, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final rol = snap.data;

            // no es admin → fuera!
            if (rol != "admin") {
              FirebaseAuth.instance.signOut();
              return LoginAdminScreen();
            }

            return HomeAdminScreen(adminId: user.uid);
          },
        );
      },
    );
  }
}
