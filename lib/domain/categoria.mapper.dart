// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'categoria.dart';

class CategoriaMapper extends ClassMapperBase<Categoria> {
  CategoriaMapper._();

  static CategoriaMapper? _instance;
  static CategoriaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CategoriaMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Categoria';

  static String? _$id(Categoria v) => v.id;
  static const Field<Categoria, String> _f$id = Field('id', _$id, opt: true);
  static String _$nombre(Categoria v) => v.nombre;
  static const Field<Categoria, String> _f$nombre = Field('nombre', _$nombre);
  static String _$descripcion(Categoria v) => v.descripcion;
  static const Field<Categoria, String> _f$descripcion =
      Field('descripcion', _$descripcion);
  static String _$imagenUrl(Categoria v) => v.imagenUrl;
  static const Field<Categoria, String> _f$imagenUrl =
      Field('imagenUrl', _$imagenUrl);

  @override
  final MappableFields<Categoria> fields = const {
    #id: _f$id,
    #nombre: _f$nombre,
    #descripcion: _f$descripcion,
    #imagenUrl: _f$imagenUrl,
  };

  static Categoria _instantiate(DecodingData data) {
    return Categoria(
        id: data.dec(_f$id),
        nombre: data.dec(_f$nombre),
        descripcion: data.dec(_f$descripcion),
        imagenUrl: data.dec(_f$imagenUrl));
  }

  @override
  final Function instantiate = _instantiate;

  static Categoria fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Categoria>(map);
  }

  static Categoria fromJson(String json) {
    return ensureInitialized().decodeJson<Categoria>(json);
  }
}

mixin CategoriaMappable {
  String toJson() {
    return CategoriaMapper.ensureInitialized()
        .encodeJson<Categoria>(this as Categoria);
  }

  Map<String, dynamic> toMap() {
    return CategoriaMapper.ensureInitialized()
        .encodeMap<Categoria>(this as Categoria);
  }

  CategoriaCopyWith<Categoria, Categoria, Categoria> get copyWith =>
      _CategoriaCopyWithImpl<Categoria, Categoria>(
          this as Categoria, $identity, $identity);
  @override
  String toString() {
    return CategoriaMapper.ensureInitialized()
        .stringifyValue(this as Categoria);
  }

  @override
  bool operator ==(Object other) {
    return CategoriaMapper.ensureInitialized()
        .equalsValue(this as Categoria, other);
  }

  @override
  int get hashCode {
    return CategoriaMapper.ensureInitialized().hashValue(this as Categoria);
  }
}

extension CategoriaValueCopy<$R, $Out> on ObjectCopyWith<$R, Categoria, $Out> {
  CategoriaCopyWith<$R, Categoria, $Out> get $asCategoria =>
      $base.as((v, t, t2) => _CategoriaCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CategoriaCopyWith<$R, $In extends Categoria, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? nombre, String? descripcion, String? imagenUrl});
  CategoriaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CategoriaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Categoria, $Out>
    implements CategoriaCopyWith<$R, Categoria, $Out> {
  _CategoriaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Categoria> $mapper =
      CategoriaMapper.ensureInitialized();
  @override
  $R call(
          {Object? id = $none,
          String? nombre,
          String? descripcion,
          String? imagenUrl}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (nombre != null) #nombre: nombre,
        if (descripcion != null) #descripcion: descripcion,
        if (imagenUrl != null) #imagenUrl: imagenUrl
      }));
  @override
  Categoria $make(CopyWithData data) => Categoria(
      id: data.get(#id, or: $value.id),
      nombre: data.get(#nombre, or: $value.nombre),
      descripcion: data.get(#descripcion, or: $value.descripcion),
      imagenUrl: data.get(#imagenUrl, or: $value.imagenUrl));

  @override
  CategoriaCopyWith<$R2, Categoria, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _CategoriaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
