import 'package:afranco/components/delete_noticia_modal.dart';
import 'package:afranco/components/noticia_edit_modal.dart';
import 'package:flutter/material.dart';
import 'package:afranco/domain/noticia.dart';
import 'package:afranco/noticias_estilos.dart';


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
          padding: const EdgeInsets.only(left:20,right:20,top:20),
          child: Text(
          noticia.titulo,
          style: NoticiaEstilos.tituloNoticia,
          overflow: TextOverflow.visible, // Elimina el truncamiento
          softWrap: true, // Permite saltos de línea
        ),  
      ),
      
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        
        children: [
          
          Padding(padding: const EdgeInsets.only(left: 20),
            child:Text( '${noticia.publicadaEl.day}/${noticia.publicadaEl.month}/${noticia.publicadaEl.year}', style:NoticiaEstilos.fuenteNoticia),

          ),

        ],

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
  padding: const EdgeInsets.only(left: 22, right: 5, top: 10),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child:Row(
        children: [
          Flexible(
            child:Text(
               noticia.fuente,
                style: NoticiaEstilos.fuenteNoticia,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
            ),

          ),
          
          const SizedBox(width: 8),
          Text(
            "${noticia.tiempoLectura} min",
            style: NoticiaEstilos.fuenteNoticia,
          ),
          
        ],
      ),
      ),
      
      // Iconos
      Row(
        mainAxisSize:MainAxisSize.min,
        children: [
         
          IconButton(
            icon: const Icon(Icons.star_border, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share, size: 24),
            onPressed: () {},
          ),
          
          PopupMenuButton<String>(
            onSelected: (value){
              switch(value){
                case 'edit':
                showDialog(
                  context: context,
                  builder: (context) => NoticiaEditModal(noticia:noticia, id:noticia.id),
                );
                break;
                case 'delete':
                showDialog(
                context: context,
                builder: (context) => NoticiaDeleteModal(
                  noticia: noticia,
                  id: noticia.id,
                ),
                ).then((resultado) {
                  if (resultado == true) {
                    // Actualizar la lista de noticias aquí
                    
                  }
                });
                  break;
              }

            },
            itemBuilder: (BuildContext context)=>[
              const PopupMenuItem<String> (
                value:'edit',
                child:Text('Editar'),
                
              ),
              const PopupMenuItem<String>(
                value:'delete',
                child:Text('Eliminar')
              ),
            ],
            icon:const Icon(Icons.more_vert),
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
  }
 
}

