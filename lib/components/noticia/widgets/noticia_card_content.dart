import 'package:flutter/material.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/noticias_estilos.dart';

class NoticiaCardContent extends StatelessWidget {
  final Noticia noticia;
  final String imageUrl;

  const NoticiaCardContent({
    super.key,
    required this.noticia,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Texto
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                noticia.descripcion,
                style: NoticiaEstilos.descripcionNoticia,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Imagen
          Expanded(
            flex: 1,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  matchTextDirection: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
