// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'noticia.dart';

class NoticiaMapper extends ClassMapperBase<Noticia> {
  NoticiaMapper._();

  static NoticiaMapper? _instance;
  static NoticiaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NoticiaMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Noticia';

  static String? _$id(Noticia v) => v.id;
  static const Field<Noticia, String> _f$id = Field('id', _$id, opt: true);
  static String _$titulo(Noticia v) => v.titulo;
  static const Field<Noticia, String> _f$titulo = Field('titulo', _$titulo);
  static String _$descripcion(Noticia v) => v.descripcion;
  static const Field<Noticia, String> _f$descripcion =
      Field('descripcion', _$descripcion);
  static String _$fuente(Noticia v) => v.fuente;
  static const Field<Noticia, String> _f$fuente = Field('fuente', _$fuente);
  static DateTime _$publicadaEl(Noticia v) => v.publicadaEl;
  static const Field<Noticia, DateTime> _f$publicadaEl =
      Field('publicadaEl', _$publicadaEl);
  static String _$urlImagen(Noticia v) => v.urlImagen;
  static const Field<Noticia, String> _f$urlImagen =
      Field('urlImagen', _$urlImagen);
  static String? _$categoriaId(Noticia v) => v.categoriaId;
  static const Field<Noticia, String> _f$categoriaId =
      Field('categoriaId', _$categoriaId, opt: true);
  static int? _$contadorReportes(Noticia v) => v.contadorReportes;
  static const Field<Noticia, int> _f$contadorReportes =
      Field('contadorReportes', _$contadorReportes, opt: true);
  static int? _$contadorComentarios(Noticia v) => v.contadorComentarios;
  static const Field<Noticia, int> _f$contadorComentarios =
      Field('contadorComentarios', _$contadorComentarios, opt: true);
  static int _$tiempoLectura(Noticia v) => v.tiempoLectura;
  static const Field<Noticia, int> _f$tiempoLectura =
      Field('tiempoLectura', _$tiempoLectura, mode: FieldMode.member);

  @override
  final MappableFields<Noticia> fields = const {
    #id: _f$id,
    #titulo: _f$titulo,
    #descripcion: _f$descripcion,
    #fuente: _f$fuente,
    #publicadaEl: _f$publicadaEl,
    #urlImagen: _f$urlImagen,
    #categoriaId: _f$categoriaId,
    #contadorReportes: _f$contadorReportes,
    #contadorComentarios: _f$contadorComentarios,
    #tiempoLectura: _f$tiempoLectura,
  };

  static Noticia _instantiate(DecodingData data) {
    return Noticia(
        id: data.dec(_f$id),
        titulo: data.dec(_f$titulo),
        descripcion: data.dec(_f$descripcion),
        fuente: data.dec(_f$fuente),
        publicadaEl: data.dec(_f$publicadaEl),
        urlImagen: data.dec(_f$urlImagen),
        categoriaId: data.dec(_f$categoriaId),
        contadorReportes: data.dec(_f$contadorReportes),
        contadorComentarios: data.dec(_f$contadorComentarios));
  }

  @override
  final Function instantiate = _instantiate;

  static Noticia fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Noticia>(map);
  }

  static Noticia fromJson(String json) {
    return ensureInitialized().decodeJson<Noticia>(json);
  }
}

mixin NoticiaMappable {
  String toJson() {
    return NoticiaMapper.ensureInitialized()
        .encodeJson<Noticia>(this as Noticia);
  }

  Map<String, dynamic> toMap() {
    return NoticiaMapper.ensureInitialized()
        .encodeMap<Noticia>(this as Noticia);
  }

  NoticiaCopyWith<Noticia, Noticia, Noticia> get copyWith =>
      _NoticiaCopyWithImpl<Noticia, Noticia>(
          this as Noticia, $identity, $identity);
  @override
  String toString() {
    return NoticiaMapper.ensureInitialized().stringifyValue(this as Noticia);
  }

  @override
  bool operator ==(Object other) {
    return NoticiaMapper.ensureInitialized()
        .equalsValue(this as Noticia, other);
  }

  @override
  int get hashCode {
    return NoticiaMapper.ensureInitialized().hashValue(this as Noticia);
  }
}

extension NoticiaValueCopy<$R, $Out> on ObjectCopyWith<$R, Noticia, $Out> {
  NoticiaCopyWith<$R, Noticia, $Out> get $asNoticia =>
      $base.as((v, t, t2) => _NoticiaCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NoticiaCopyWith<$R, $In extends Noticia, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? titulo,
      String? descripcion,
      String? fuente,
      DateTime? publicadaEl,
      String? urlImagen,
      String? categoriaId,
      int? contadorReportes,
      int? contadorComentarios});
  NoticiaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _NoticiaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Noticia, $Out>
    implements NoticiaCopyWith<$R, Noticia, $Out> {
  _NoticiaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Noticia> $mapper =
      NoticiaMapper.ensureInitialized();
  @override
  $R call(
          {Object? id = $none,
          String? titulo,
          String? descripcion,
          String? fuente,
          DateTime? publicadaEl,
          String? urlImagen,
          Object? categoriaId = $none,
          Object? contadorReportes = $none,
          Object? contadorComentarios = $none}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (titulo != null) #titulo: titulo,
        if (descripcion != null) #descripcion: descripcion,
        if (fuente != null) #fuente: fuente,
        if (publicadaEl != null) #publicadaEl: publicadaEl,
        if (urlImagen != null) #urlImagen: urlImagen,
        if (categoriaId != $none) #categoriaId: categoriaId,
        if (contadorReportes != $none) #contadorReportes: contadorReportes,
        if (contadorComentarios != $none)
          #contadorComentarios: contadorComentarios
      }));
  @override
  Noticia $make(CopyWithData data) => Noticia(
      id: data.get(#id, or: $value.id),
      titulo: data.get(#titulo, or: $value.titulo),
      descripcion: data.get(#descripcion, or: $value.descripcion),
      fuente: data.get(#fuente, or: $value.fuente),
      publicadaEl: data.get(#publicadaEl, or: $value.publicadaEl),
      urlImagen: data.get(#urlImagen, or: $value.urlImagen),
      categoriaId: data.get(#categoriaId, or: $value.categoriaId),
      contadorReportes:
          data.get(#contadorReportes, or: $value.contadorReportes),
      contadorComentarios:
          data.get(#contadorComentarios, or: $value.contadorComentarios));

  @override
  NoticiaCopyWith<$R2, Noticia, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _NoticiaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
