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

  static String _$id(Noticia v) => v.id;
  static const Field<Noticia, String> _f$id =
      Field('id', _$id, key: r'urlImagen');
  static String _$categoryId(Noticia v) => v.categoryId;
  static const Field<Noticia, String> _f$categoryId =
      Field('categoryId', _$categoryId, opt: true);
  static String _$titulo(Noticia v) => v.titulo;
  static const Field<Noticia, String> _f$titulo = Field('titulo', _$titulo);
  static String _$fuente(Noticia v) => v.fuente;
  static const Field<Noticia, String> _f$fuente = Field('fuente', _$fuente);
  static String _$urlImagen(Noticia v) => v.urlImagen;
  static const Field<Noticia, String> _f$urlImagen =
      Field('urlImagen', _$urlImagen);
  static DateTime _$publicadaEl(Noticia v) => v.publicadaEl;
  static const Field<Noticia, DateTime> _f$publicadaEl =
      Field('publicadaEl', _$publicadaEl);
  static String _$descripcion(Noticia v) => v.descripcion;
  static const Field<Noticia, String> _f$descripcion =
      Field('descripcion', _$descripcion);
  static String? _$url(Noticia v) => v.url;
  static const Field<Noticia, String> _f$url = Field('url', _$url, opt: true);
  static String? _$autor(Noticia v) => v.autor;
  static const Field<Noticia, String> _f$autor =
      Field('autor', _$autor, opt: true);
  static String? _$contenido(Noticia v) => v.contenido;
  static const Field<Noticia, String> _f$contenido =
      Field('contenido', _$contenido, opt: true);
  static int _$tiempoLectura(Noticia v) => v.tiempoLectura;
  static const Field<Noticia, int> _f$tiempoLectura =
      Field('tiempoLectura', _$tiempoLectura, opt: true);

  @override
  final MappableFields<Noticia> fields = const {
    #id: _f$id,
    #categoryId: _f$categoryId,
    #titulo: _f$titulo,
    #fuente: _f$fuente,
    #urlImagen: _f$urlImagen,
    #publicadaEl: _f$publicadaEl,
    #descripcion: _f$descripcion,
    #url: _f$url,
    #autor: _f$autor,
    #contenido: _f$contenido,
    #tiempoLectura: _f$tiempoLectura,
  };

  static Noticia _instantiate(DecodingData data) {
    return Noticia(
        id: data.dec(_f$id),
        categoryId: data.dec(_f$categoryId),
        titulo: data.dec(_f$titulo),
        fuente: data.dec(_f$fuente),
        urlImagen: data.dec(_f$urlImagen),
        publicadaEl: data.dec(_f$publicadaEl),
        descripcion: data.dec(_f$descripcion),
        url: data.dec(_f$url),
        autor: data.dec(_f$autor),
        contenido: data.dec(_f$contenido),
        tiempoLectura: data.dec(_f$tiempoLectura));
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
      String? categoryId,
      String? titulo,
      String? fuente,
      String? urlImagen,
      DateTime? publicadaEl,
      String? descripcion,
      String? url,
      String? autor,
      String? contenido,
      int? tiempoLectura});
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
          {String? id,
          Object? categoryId = $none,
          String? titulo,
          String? fuente,
          String? urlImagen,
          DateTime? publicadaEl,
          String? descripcion,
          Object? url = $none,
          Object? autor = $none,
          Object? contenido = $none,
          Object? tiempoLectura = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (categoryId != $none) #categoryId: categoryId,
        if (titulo != null) #titulo: titulo,
        if (fuente != null) #fuente: fuente,
        if (urlImagen != null) #urlImagen: urlImagen,
        if (publicadaEl != null) #publicadaEl: publicadaEl,
        if (descripcion != null) #descripcion: descripcion,
        if (url != $none) #url: url,
        if (autor != $none) #autor: autor,
        if (contenido != $none) #contenido: contenido,
        if (tiempoLectura != $none) #tiempoLectura: tiempoLectura
      }));
  @override
  Noticia $make(CopyWithData data) => Noticia(
      id: data.get(#id, or: $value.id),
      categoryId: data.get(#categoryId, or: $value.categoryId),
      titulo: data.get(#titulo, or: $value.titulo),
      fuente: data.get(#fuente, or: $value.fuente),
      urlImagen: data.get(#urlImagen, or: $value.urlImagen),
      publicadaEl: data.get(#publicadaEl, or: $value.publicadaEl),
      descripcion: data.get(#descripcion, or: $value.descripcion),
      url: data.get(#url, or: $value.url),
      autor: data.get(#autor, or: $value.autor),
      contenido: data.get(#contenido, or: $value.contenido),
      tiempoLectura: data.get(#tiempoLectura, or: $value.tiempoLectura));

  @override
  NoticiaCopyWith<$R2, Noticia, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _NoticiaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
