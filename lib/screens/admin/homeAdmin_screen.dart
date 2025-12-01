import 'package:flutter/material.dart';

import 'DashBords/dashboardAdmin_screen.dart';
import 'GestComida/comidaAdmin_screen.dart';
import 'Pedidos/pedidoAdmin_screen.dart';
import 'ReservasView/listadeReservas_screen.dart';


class HomeAdminScreen extends StatefulWidget {
  final String adminId;
  const HomeAdminScreen({super.key, required this.adminId});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pedidos", icon: Icon(Icons.shopping_cart)),
            Tab(text: "Comidas", icon: Icon(Icons.fastfood)),
            Tab(text: "Reservas", icon: Icon(Icons.event_available)),
            Tab(text: "Dashboard", icon: Icon(Icons.dashboard)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PedidoScreen(),
          ComidaScreen(),
          ReservasAdminScreen(),
          DashboardScreen(),
        ],
      ),
    );
  }
}
