import 'package:flutter/material.dart';
import 'package:afranco/domain/noticia.dart';

class NoticiaCardHero extends StatelessWidget {
  final Noticia noticia;
  final String imageUrl;

  const NoticiaCardHero({
    super.key,
    required this.noticia,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'noticia-image-${noticia.id}',
      child: SizedBox(
        height: 0, // Altura 0 para que no ocupe espacio visual
        width: double.infinity,
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported),
                ),
              )
            : Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.image),
              ),
      ),
    );
  }
}
