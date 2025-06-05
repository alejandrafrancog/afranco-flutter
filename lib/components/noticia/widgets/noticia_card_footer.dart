import 'package:flutter/material.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/noticias_estilos.dart';
import 'package:afranco/components/noticia/widgets/noticia_card_actions.dart';

class NoticiaCardFooter extends StatelessWidget {
  final Noticia noticia;
  final Function(Noticia) onEditPressed;
  final VoidCallback onDelete;
  final VoidCallback onNavigateToDetail;

  const NoticiaCardFooter({
    super.key,
    required this.noticia,
    required this.onEditPressed,
    required this.onDelete,
    required this.onNavigateToDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 22,
        right: 5,
        top: 10,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.source,
                  size: 16,
                  color: Colors.grey,
                  weight: 100,
                ),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    noticia.fuente,
                    style: NoticiaEstilos.fuenteNoticia,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),

                const SizedBox(width: 8),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[600],
                  weight: 100,
                ),
                const SizedBox(width: 3),

                Text(
                  "${noticia.tiempoLectura} min",
                  style: NoticiaEstilos.fuenteNoticia,
                ),
              ],
            ),
          ),

          NoticiaCardActions(
            noticia: noticia,
            onEditPressed: onEditPressed,
            onDelete: onDelete,
            onNavigateToDetail: onNavigateToDetail,
          ),
        ],
      ),
    );
  }
}
