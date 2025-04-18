import 'package:flutter/material.dart';
import '../domain/noticia.dart';
import '../noticias_estilos.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final String imageUrl;

  const NoticiaCard({
    super.key,
    required this.noticia,
    required this.imageUrl,
  });

@override
Widget build(BuildContext context) {
  return Container(
    margin: NoticiaEstilos.margenCard,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
         Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
          noticia.titulo,
          style: NoticiaEstilos.tituloNoticia,
          overflow: TextOverflow.visible, // Elimina el truncamiento
          softWrap: true, // Permite saltos de línea
        ),
),

          // Contenido: Imagen + Descripción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Texto
                Expanded(
                  flex: 2, 
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      noticia.descripcion,
                      style: NoticiaEstilos.descripcionNoticia,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                
                // Imagen
                Expanded(
                  flex: 2, // 40% del espacio
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
                padding: const EdgeInsets.only(left:12,right:15).copyWith(top: 10),
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Fuente y Tiempo
                    Padding(padding: EdgeInsets.all(4)),
                    Row(
                      
                      children: [
                        Text(
                          noticia.fuente,
                          style: NoticiaEstilos.fuenteNoticia,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${noticia.tiempoLectura} min",
                          style: NoticiaEstilos.fuenteNoticia,
                        ),
                      ],
                      
                    ),
                   // Padding(padding:EdgeInsets.only(left:noticia.fuente.length.toDouble()*2.5)),                    
                    // Iconos
                    //const SizedBox(width:56),Spacer(),
                    Spacer(),Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                        ),
                        IconButton(
                          icon: const Icon(Icons.star_border, size: 24),
                          onPressed: () {
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, size: 24),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert, size: 24),
                          onPressed: () {},
                        ),
                        
                      ],
                    ),
                  ],
                ),
              ),

        ],
      ),
    ),
  );
}}

