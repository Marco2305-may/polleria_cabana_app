import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../models/comida.dart';
import '../../../services/admin/comidaAdmin_service.dart';

class ComidaScreen extends StatefulWidget {
  const ComidaScreen({super.key});

  @override
  State<ComidaScreen> createState() => _ComidaScreenState();
}

class _ComidaScreenState extends State<ComidaScreen> {
  final service = ComidaService();
  final picker = ImagePicker();

  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // -------------------------------
  // AGREGAR COMIDA
  // -------------------------------
  void _agregarComidaDialog() {
    final nombreController = TextEditingController();
    final descController = TextEditingController();
    final tipoController = TextEditingController();
    final precioController = TextEditingController();
    _selectedImage = null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agregar Comida'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nombreController, decoration: const InputDecoration(labelText: 'Nombre')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Descripción')),
              TextField(controller: tipoController, decoration: const InputDecoration(labelText: 'Tipo')),
              TextField(controller: precioController, decoration: const InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Seleccionar Imagen'),
              ),
              if (_selectedImage != null) Image.file(_selectedImage!, height: 100),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                _selectedImage = null;
                Navigator.pop(context);
              },
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final comida = Comida(
                id: '',
                nombre: nombreController.text,
                descripcion: descController.text,
                tipo: tipoController.text,
                precio: double.tryParse(precioController.text) ?? 0.0,
                imagen: '',
              );
              await service.agregarComida(comida, _selectedImage);
              _selectedImage = null;
              Navigator.pop(context);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  // -------------------------------
  // EDITAR COMIDA
  // -------------------------------
  void _editarComidaDialog(Comida comida) {
    final nombreController = TextEditingController(text: comida.nombre);
    final descController = TextEditingController(text: comida.descripcion);
    final tipoController = TextEditingController(text: comida.tipo);
    final precioController = TextEditingController(text: comida.precio.toString());
    _selectedImage = null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar Comida'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nombreController, decoration: const InputDecoration(labelText: 'Nombre')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Descripción')),
              TextField(controller: tipoController, decoration: const InputDecoration(labelText: 'Tipo')),
              TextField(controller: precioController, decoration: const InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
              const SizedBox(height: 10),

              // Mostrar imagen actual si no hay imagen seleccionada
              if (_selectedImage == null && comida.imagen.isNotEmpty)
                Image.network(comida.imagen, height: 100),

              // Nueva imagen seleccionada
              if (_selectedImage != null) Image.file(_selectedImage!, height: 100),

              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Cambiar Imagen'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                _selectedImage = null;
                Navigator.pop(context);
              },
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final comidaActualizada = Comida(
                id: comida.id,
                nombre: nombreController.text,
                descripcion: descController.text,
                tipo: tipoController.text,
                precio: double.tryParse(precioController.text) ?? comida.precio,
                imagen: comida.imagen, // se actualizará en el servicio si hay nueva imagen
              );

              await service.actualizarComida(comidaActualizada, _selectedImage);

              _selectedImage = null;
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  // -------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Comidas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _agregarComidaDialog,
          ),
        ],
      ),
      body: StreamBuilder<List<Comida>>(
        stream: service.getComidas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay comidas'));
          }

          final comidas = snapshot.data!;
          return ListView.builder(
            itemCount: comidas.length,
            itemBuilder: (context, index) {
              final comida = comidas[index];
              return Card(
                child: ListTile(
                  leading: comida.imagen.isNotEmpty
                      ? Image.network(comida.imagen, width: 50, height: 50, fit: BoxFit.cover)
                      : null,
                  title: Text(comida.nombre),
                  subtitle: Text('${comida.tipo} - S/ ${comida.precio.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editarComidaDialog(comida),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => service.eliminarComida(comida.id, comida.imagen),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

