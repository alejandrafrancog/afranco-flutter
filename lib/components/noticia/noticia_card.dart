import 'package:flutter/material.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/noticias_estilos.dart';
import 'package:afranco/views/noticia_detail_screen.dart';
import 'package:afranco/components/noticia/widgets/noticia_card_header.dart';
import 'package:afranco/components/noticia/widgets/noticia_card_content.dart';
import 'package:afranco/components/noticia/widgets/noticia_card_footer.dart';
import 'package:afranco/components/noticia/widgets/noticia_card_hero.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final String imageUrl;
  final Function(Noticia) onEditPressed;
  final VoidCallback onDelete;

  const NoticiaCard({
    super.key,
    required this.noticia,
    required this.imageUrl,
    required this.onEditPressed,
    required this.onDelete,
  });

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoticiaDetailScreen(noticia: noticia),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: NoticiaEstilos.margenCard,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(128),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => _navigateToDetail(context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen con Hero animation
              NoticiaCardHero(
                noticia: noticia,
                imageUrl: imageUrl,
              ),

              // Header (título, categoría, fecha)
              NoticiaCardHeader(noticia: noticia),

              // Contenido (descripción + imagen)
              NoticiaCardContent(
                noticia: noticia,
                imageUrl: imageUrl,
              ),

              // Footer (fuente, tiempo de lectura, acciones)
              NoticiaCardFooter(
                noticia: noticia,
                onEditPressed: onEditPressed,
                onDelete: onDelete,
                onNavigateToDetail: () => _navigateToDetail(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
