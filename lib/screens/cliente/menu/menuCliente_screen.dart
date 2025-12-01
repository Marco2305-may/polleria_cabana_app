import 'package:flutter/material.dart';
import '../../../models/comida.dart';
import '../../../services/cliente/comidaCliente_service.dart';
import '../../../services/cliente/carritoCliente_service.dart';
import '../../../widgets/contador_carritoBadge.dart';
import '../../../widgets/food_card.dart';

class MenuClienteScreen extends StatefulWidget {
  final String idUsuario;

  MenuClienteScreen({super.key, required this.idUsuario});

  @override
  State<MenuClienteScreen> createState() => _MenuClienteScreenState();
}

class _MenuClienteScreenState extends State<MenuClienteScreen> {
  final _service = ComidaClienteService();
  final _carritoService = CarritoClienteService();

  String _searchText = "";
  String _filtroTipo = "Todos";

  final List<String> tipos = [
    "Todos",
    "plato principal",
    "bebida",
    "complemento",
    "combos",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF3),
      appBar: AppBar(
        title: const Text(
          "🍗 Pollería La Cabaña",
          style: TextStyle(
            color: Color(0xFF5D3A1A),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFE8C7),
        elevation: 4,
        shadowColor: Colors.black26,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CartIconWithBadge(carritoService: _carritoService),
          ),
        ],
      ),

      body: Column(
        children: [
          // 🔎 BUSCADOR
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Colors.brown),
                hintText: "Buscar comida, bebida, combo...",
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value.toLowerCase();
                });
              },
            ),
          ),

          // 🟡 FILTROS DE TIPOS
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tipos.length,
              itemBuilder: (context, index) {
                final tipo = tipos[index];
                final isSelected = tipo == _filtroTipo;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _filtroTipo = tipo;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE29532)
                          : const Color(0xFFFFE6C8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                        isSelected ? Colors.orange : Colors.brown.shade300,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      tipo,
                      style: TextStyle(
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF5D3A1A),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // 🔥 Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFDCA8),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.local_fire_department,
                    color: Colors.deepOrange, size: 30),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "🔥 Revisa nuestras comidas más pedidas del día",
                    style: TextStyle(
                      color: Color(0xFF5D3A1A),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 📋 LISTA DE RESULTADOS
          Expanded(
            child: StreamBuilder<List<Comida>>(
              stream: _service.obtenerComidas(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Comida> comidas = snapshot.data!;

                // APLICAR SEARCH
                comidas = comidas
                    .where((c) => c.nombre.toLowerCase().contains(_searchText))
                    .toList();

                // APLICAR FILTRO TIPO
                if (_filtroTipo != "Todos") {
                  comidas =
                      comidas.where((c) => c.tipo == _filtroTipo).toList();
                }

                if (comidas.isEmpty) {
                  return const Center(
                    child: Text(
                      "😢 No hay resultados.",
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: comidas.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FoodCard(
                        comida: comidas[index],
                        idUsuario: widget.idUsuario,
                        carritoService: _carritoService,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


