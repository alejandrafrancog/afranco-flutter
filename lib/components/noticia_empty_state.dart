import 'package:flutter/material.dart';
import '../noticias_estilos.dart';
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No se encontraron noticias',
        style: NoticiaEstilos.listaVacia,
      ),
    );
  }
}