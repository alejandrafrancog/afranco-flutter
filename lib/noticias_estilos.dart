import 'package:flutter/material.dart';

class NoticiaEstilos {
  static const TextStyle tituloAppBar = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const margenCard = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );

  static const TextStyle tituloNoticia = TextStyle(
    fontSize: 18,
  
    fontWeight: FontWeight.bold,
  );

  static const TextStyle descripcionNoticia = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle fuenteNoticia = TextStyle(
    fontSize: 12,
    fontStyle: FontStyle.italic,
    color: Colors.blue,
  );

  static const TextStyle fechaNoticia = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );


  static const espaciadoAlto = 10.0;
  
  static const TextStyle mensajeCargando = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  static const TextStyle listaVacia = TextStyle(
    fontSize: 18,
    color: Colors.grey,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle mensajeError = TextStyle(
    fontSize: 16,
    color: Colors.red,
    fontWeight: FontWeight.w500,
  );

  static const EdgeInsets paddingCard = EdgeInsets.all(16);
}