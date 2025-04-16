import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../domain/noticia.dart';
import '../noticias_estilos.dart';
import '../constants.dart';
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
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 2,
            offset: Offset(0, 3)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.all(12),
                  color: Colors.black54,
                  child: Text(
                    noticia.fuente,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(noticia.titulo, style: NoticiaEstilos.tituloNoticia),
                  SizedBox(height: 12),
                  Text(
                    noticia.descripcion,
                    style: NoticiaEstilos.descripcionNoticia,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        DateFormat(NoticiaConstants.formatoFecha).format(noticia.publicadaEl),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14),
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

