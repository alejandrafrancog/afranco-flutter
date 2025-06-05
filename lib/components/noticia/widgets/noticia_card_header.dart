import 'package:flutter/material.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/noticias_estilos.dart';
import 'package:afranco/helpers/category_helper.dart';

class NoticiaCardHeader extends StatelessWidget {
  final Noticia noticia;

  const NoticiaCardHeader({
    super.key,
    required this.noticia,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Text(
            noticia.titulo,
            style: NoticiaEstilos.tituloNoticia,
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
        ),

        // Categoría
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEDF6F9),
              border: Border.all(
                color: const Color(0xFFEDF6F9),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(82),
            ),
            child: FutureBuilder<String>(
              future: CategoryHelper.getCategoryName(
                noticia.categoriaId ?? '',
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    snapshot.data ?? 'Sin categoría',
                    style: NoticiaEstilos.fuenteNoticia,
                  ),
                );
              },
            ),
          ),
        ),

        // Fecha
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            '${noticia.publicadaEl.day}/${noticia.publicadaEl.month}/${noticia.publicadaEl.year}',
            style: NoticiaEstilos.fuenteNoticia,
          ),
        ),
      ],
    );
  }
}
