class Notas {
  int? id;
  String titulo;
  String descripcion;

  Notas({this.id, required this.titulo, required this.descripcion});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
    };
  }
}
