import 'package:flutter/material.dart';
import 'package:crud/modelos/notas.dart';
import 'package:crud/db/operaciones.dart';

class ActualizarNotaPage extends StatefulWidget {
  final Notas nota;

  ActualizarNotaPage({required this.nota});

  @override
  _ActualizarNotaPageState createState() => _ActualizarNotaPageState();
}

class _ActualizarNotaPageState extends State<ActualizarNotaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.nota.titulo);
    _descripcionController = TextEditingController(text: widget.nota.descripcion);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardarNota() async {
    if (_formKey.currentState!.validate()) {
      widget.nota.titulo = _tituloController.text;
      widget.nota.descripcion = _descripcionController.text;
      await Crud.actualizarNota(widget.nota);
      Navigator.of(context).pop(true); // Indicar que se actualizó la nota
    }
  }

  int _contarPalabras(String texto) {
    return texto.trim().split(RegExp(r'\s+')).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Actualizar Nota')),
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
