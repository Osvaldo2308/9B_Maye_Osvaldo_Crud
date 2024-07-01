import 'package:flutter/material.dart';
import 'package:crud/modelos/notas.dart';
import 'package:crud/db/operaciones.dart';

class CrearNotaPage extends StatefulWidget {
  @override
  _CrearNotaPageState createState() => _CrearNotaPageState();
}

class _CrearNotaPageState extends State<CrearNotaPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardarNota() async {
    if (_formKey.currentState!.validate()) {
      final nuevaNota = Notas(
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
      );
      await Crud.insertarOperacion(nuevaNota);
      Navigator.of(context).pop(true); // Indicar que se creó una nueva nota
    }
  }

  int _contarPalabras(String texto) {
    return texto.trim().split(RegExp(r'\s+')).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Nota')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: 'Título'),
                maxLength: 100,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El título no puede estar vacío';
                  } else if (value.length < 4) {
                    return 'El título debe tener al menos 4 letras';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                maxLength: 5000,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción no puede estar vacía';
                  } else if (_contarPalabras(value) > 5000) {
                    return 'La descripción no puede exceder las 5000 palabras';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 8.0),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _guardarNota,
                  child: Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
