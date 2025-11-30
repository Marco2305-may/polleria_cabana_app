import 'package:flutter/material.dart';
import 'package:polleria_cabana_dev/screens/cliente/menu/menuCliente_screen.dart';
import 'package:polleria_cabana_dev/screens/cliente/perfil/perfilCliente_screen.dart';
import 'package:polleria_cabana_dev/screens/cliente/reservacion/reservas_screen.dart';

import '../pedido/seguimientoPedido_screen.dart';

class HomeScreen extends StatefulWidget {
  final String idUsuario;

  const HomeScreen({super.key, required this.idUsuario});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens; // 👈 solo declaras aquí, sin usar widget

  @override
  void initState() {
    super.initState();

    // 👇 Ahora sí puedes usar widget.idUsuario
    _screens = [
      MenuClienteScreen(idUsuario: widget.idUsuario),
      ReservasScreen(idUsuario: widget.idUsuario),
      SeguimientoPedidosScreen(idUsuario: widget.idUsuario),
      PerfilClienteScreen(idUsuario: widget.idUsuario),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.brown[800],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: "Menú",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_seat),
            label: "Reservar",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: "Pedidos"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "$title Screen",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
      ),
    );
  }
}


