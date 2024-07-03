import 'package:flutter/material.dart';
import 'package:crud/modelos/notas.dart';
import 'package:crud/db/operaciones.dart';
import 'package:crud/pantallas/crearnota.dart';
import 'package:crud/pantallas/actualizarnota.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Notas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotasPage(),
    );
  }
}

class NotasPage extends StatefulWidget {
  @override
  _NotasPageState createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  List<Notas> _notas = [];

  @override
  void initState() {
    super.initState();
    _cargarNotas();
  }

  Future<void> _cargarNotas() async {
    final notas = await Crud.obtenerNotas();
    setState(() {
      _notas = notas;
    });
  }

  void _eliminarNota(int id) {
    Crud.eliminarNota(id).then((_) => _cargarNotas());
  }

  Future<void> _confirmarEliminarNota(BuildContext context, Notas nota) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar la nota titulada "${nota.titulo}"?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false); // No eliminar
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmar eliminación
              },
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      _eliminarNota(nota.id!);
    }
  }

  String _limitarDescripcion(String descripcion) {
    // Limitar la descripción a las primeras 100 palabras
    List<String> words = descripcion.trim().split(' ');
    if (words.length > 100) {
      words = words.sublist(0, 100);
      return words.join(' ') + '...';
    }
    return descripcion;
  }

  Future<void> _mostrarDetalleNota(BuildContext context, Notas nota) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nota.titulo,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  nota.descripcion,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text('Cerrar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notas')),
      body: ListView.builder(
        itemCount: _notas.length,
        itemBuilder: (context, index) {
          final nota = _notas[index];
          return Dismissible(
            key: Key(nota.id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _confirmarEliminarNota(context, nota);
            },
            background: Container(
              color: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: AlignmentDirectional.centerEnd,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: GestureDetector(
              onTap: () => _mostrarDetalleNota(context, nota),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Color y opacidad de la sombra
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(2, 2), // Cambia la posición de la sombra
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(nota.titulo),
                    subtitle: Text(_limitarDescripcion(nota.descripcion)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActualizarNotaPage(nota: nota),
                              ),
                            );
                            if (result == true) {
                              _cargarNotas(); // Recargar las notas si se actualizó una nota
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _confirmarEliminarNota(context, nota),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CrearNotaPage()),
          );
          if (result == true) {
            _cargarNotas(); // Recargar las notas si se creó una nueva
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
