import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:polleria_cabana_dev/screens/cliente/loginCliente_screen.dart';
import 'package:polleria_cabana_dev/screens/cliente/ombording_screen.dart';
import 'package:polleria_cabana_dev/screens/cliente/registroCliente_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print("🔥 Firebase inicializado OK");
  } catch (e) {
    print("❌ Error inicializando Firebase: $e");
  }

  runApp(const ClienteApp());
}

class ClienteApp extends StatelessWidget {
  const ClienteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pollería La Cabaña - Cliente',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        useMaterial3: true,
      ),
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/loginCliente': (context) => LoginClienteScreen(),
        '/registroCliente': (context) => RegisterClienteScreen(),
      },
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    print("🔄 AuthWrapper: Construyendo widget...");

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print("📡 Snapshot → ${snapshot.connectionState}");
        print("👤 Tiene datos → ${snapshot.hasData}");
        print("📌 Usuario → ${snapshot.data}");

        // Mientras Firebase inicializa
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Usuario autenticado
        if (snapshot.hasData && snapshot.data != null) {
          print("➡️ Usuario autenticado → LoginClienteScreen");
          return const LoginClienteScreen();
        }

        // Usuario NO autenticado
        print("➡️ No autenticado → OnboardingScreen");
        return const OnboardingScreen();
      },
    );
  }
}








