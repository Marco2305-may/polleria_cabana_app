import 'package:flutter/material.dart';
import '../../../services/admin/dashboreAdmin_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final service = DashboardService();
  int totalPedidosHoy = 0, pendientes = 0, totalUsuariosHoy = 0;
  late AnimationController _controller;

  // Datos reales (cargados desde tu servicio)
  List<int> pedidosPorRango = List.filled(6, 0);
  List<int> usuariosPorRango = List.filled(6, 0);

  // Datos de ejemplo para visualización
  final List<int> pedidosEjemplo = [8, 12, 5, 10, 7, 15];
  final List<int> usuariosEjemplo = [3, 5, 2, 4, 6, 3];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    cargarDatos();
  }

  void cargarDatos() async {
    totalPedidosHoy = await service.getTotalPedidos();
    pendientes = await service.getPedidosPendientes();
    totalUsuariosHoy = await service.getTotalUsuarios();

    // Datos reales simulados con Random para demo
    Random rand = Random();
    for (int i = 0; i < pedidosPorRango.length; i++) pedidosPorRango[i] = rand.nextInt(10) + 5;
    for (int i = 0; i < usuariosPorRango.length; i++) usuariosPorRango[i] = rand.nextInt(6) + 1;

    _controller.forward();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void cerrarSesion() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Máximos para normalizar alturas
    double maxPedidos = pedidosEjemplo.reduce(max).toDouble();
    double maxUsuarios = usuariosEjemplo.reduce(max).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: cerrarSesion)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cards métricas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MetricCard('Total Pedidos', totalPedidosHoy, Colors.brown),
                _MetricCard('Pendientes', pendientes, Colors.orange),
                _MetricCard('Usuarios Hoy', totalUsuariosHoy, Colors.green),
              ],
            ),
            const SizedBox(height: 30),

            // Pedidos por Rango de Hora
            Text('Pedidos por Rango de Hora',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            const Text(
              '*Datos de ejemplo, los reales se muestran arriba',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 220,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(pedidosEjemplo.length, (i) {
                      // Altura mínima de 4 para que se vea siempre
                      double altura = max(
                        (pedidosEjemplo[i] / maxPedidos) * 150 * _controller.value,
                        4,
                      );
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${pedidosEjemplo[i]}',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Container(
                            width: 40,
                            height: altura,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.brown.shade300, Colors.brown.shade700],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('${i * 4}-${(i + 1) * 4}h',
                              style: const TextStyle(fontSize: 12)),
                        ],
                      );
                    }),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // Usuarios por Rango de Minutos
            Text('Usuarios Activos (últimos 60 min)',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            const Text(
              '*Datos de ejemplo, los reales se muestran arriba',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 220,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(usuariosEjemplo.length, (i) {
                      double altura = max(
                        (usuariosEjemplo[i] / maxUsuarios) * 150 * _controller.value,
                        4,
                      );
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${usuariosEjemplo[i]}',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Container(
                            width: 25,
                            height: altura,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade300, Colors.blue.shade700],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('${i * 10}-${(i + 1) * 10}m',
                              style: const TextStyle(fontSize: 12)),
                        ],
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Card métrica
class _MetricCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _MetricCard(this.label, this.value, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 110,
        child: Column(
          children: [
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Text('$value',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20, color: color)),
          ],
        ),
      ),
    );
  }
}








