import 'package:flutter/material.dart';
import 'package:afranco/theme/colors.dart';
class NoticiaEstilos {
  static const TextStyle tituloAppBar = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const margenCard = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  static const TextStyle tituloNoticia = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    overflow: TextOverflow.ellipsis,
    color: AppColors.textPrimary,
  );

  static const TextStyle descripcionNoticia = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle fuenteNoticia = TextStyle(
    fontSize: 13,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  static const TextStyle fechaNoticia = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );
  static const TextStyle fechaComentario = TextStyle(
    fontSize: 12,
    color: Colors.grey,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
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

  static ButtonStyle estiloBotonPrimario(BuildContext context) {
    ButtonStyle estiloBoton = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
      foregroundColor: WidgetStatePropertyAll(
        Theme.of(context).secondaryHeaderColor,
      ),
    );
    return estiloBoton;
  }

  static const TextStyle tituloModal = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
  static const TextStyle categoriaEstilo = TextStyle(
    color: Color(0xFF006D77),
    fontWeight: FontWeight.bold,
    backgroundColor: Color.fromARGB(255, 150, 203, 233),
    fontSize: 12,
  );

  static const EdgeInsets paddingCard = EdgeInsets.all(10);

  static ButtonStyle estiloBotonInicioSesion(BuildContext context) {
    ButtonStyle estiloBoton = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
      foregroundColor: WidgetStatePropertyAll(
        Theme.of(context).secondaryHeaderColor,
      ),
      minimumSize:const WidgetStatePropertyAll( Size(700, 60)),
    );
    return estiloBoton;
  }
}
