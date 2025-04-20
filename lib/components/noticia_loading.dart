import 'package:flutter/material.dart';
import 'package:afranco/noticias_estilos.dart';
class FullScreenLoading extends StatelessWidget {
  const FullScreenLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Cargando noticias...', style: NoticiaEstilos.mensajeCargando),
        ],
      ),
    );
  }
}