import 'package:flutter/material.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:share_plus/share_plus.dart';

class NoticiaDetailAppBar extends StatelessWidget {
  final Noticia noticia;
  final VoidCallback onImageTap;
  final bool isImageExpanded;

  const NoticiaDetailAppBar({
    super.key,
    required this.noticia,
    required this.onImageTap,
    required this.isImageExpanded,
  });

  void _shareNoticia() async {
    final String shareText = '''
${noticia.titulo}

${noticia.descripcion}

📱 Compartido desde la app de noticias
''';

    await SharePlus.instance.share(
      ShareParams(text: shareText, subject: noticia.titulo),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.purple.shade600],
        ),
      ),
      child: const Icon(Icons.article, size: 80, color: Colors.white70),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(77),
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(77),
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareNoticia,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: GestureDetector(
          onTap: onImageTap,
          child: Hero(
            tag: 'noticia-image-${noticia.id}',
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withAlpha(127)],
                ),
              ),
              child:
                  noticia.urlImagen.isNotEmpty
                      ? Image.network(
                        noticia.urlImagen,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                _buildImagePlaceholder(),
                      )
                      : _buildImagePlaceholder(),
            ),
          ),
        ),
      ),
    );
  }
}
