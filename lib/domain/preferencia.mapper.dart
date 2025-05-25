// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'preferencia.dart';

class PreferenciaMapper extends ClassMapperBase<Preferencia> {
  PreferenciaMapper._();

  static PreferenciaMapper? _instance;
  static PreferenciaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PreferenciaMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Preferencia';

  static String _$email(Preferencia v) => v.email;
  static const Field<Preferencia, String> _f$email = Field('email', _$email);
  static List<String> _$categoriasSeleccionadas(Preferencia v) =>
      v.categoriasSeleccionadas;
  static const Field<Preferencia, List<String>> _f$categoriasSeleccionadas =
      Field('categoriasSeleccionadas', _$categoriasSeleccionadas);

  @override
  final MappableFields<Preferencia> fields = const {
    #email: _f$email,
    #categoriasSeleccionadas: _f$categoriasSeleccionadas,
  };

  static Preferencia _instantiate(DecodingData data) {
    return Preferencia(
        email: data.dec(_f$email),
        categoriasSeleccionadas: data.dec(_f$categoriasSeleccionadas));
  }

  @override
  final Function instantiate = _instantiate;

  static Preferencia fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Preferencia>(map);
  }

  static Preferencia fromJson(String json) {
    return ensureInitialized().decodeJson<Preferencia>(json);
  }
}

mixin PreferenciaMappable {
  String toJson() {
    return PreferenciaMapper.ensureInitialized()
        .encodeJson<Preferencia>(this as Preferencia);
  }

  Map<String, dynamic> toMap() {
    return PreferenciaMapper.ensureInitialized()
        .encodeMap<Preferencia>(this as Preferencia);
  }

  PreferenciaCopyWith<Preferencia, Preferencia, Preferencia> get copyWith =>
      _PreferenciaCopyWithImpl<Preferencia, Preferencia>(
          this as Preferencia, $identity, $identity);
  @override
  String toString() {
    return PreferenciaMapper.ensureInitialized()
        .stringifyValue(this as Preferencia);
  }

  @override
  bool operator ==(Object other) {
    return PreferenciaMapper.ensureInitialized()
        .equalsValue(this as Preferencia, other);
  }

  @override
  int get hashCode {
    return PreferenciaMapper.ensureInitialized().hashValue(this as Preferencia);
  }
}

extension PreferenciaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, Preferencia, $Out> {
  PreferenciaCopyWith<$R, Preferencia, $Out> get $asPreferencia =>
      $base.as((v, t, t2) => _PreferenciaCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PreferenciaCopyWith<$R, $In extends Preferencia, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get categoriasSeleccionadas;
  $R call({String? email, List<String>? categoriasSeleccionadas});
  PreferenciaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PreferenciaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Preferencia, $Out>
    implements PreferenciaCopyWith<$R, Preferencia, $Out> {
  _PreferenciaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Preferencia> $mapper =
      PreferenciaMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get categoriasSeleccionadas => ListCopyWith(
          $value.categoriasSeleccionadas,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(categoriasSeleccionadas: v));
  @override
  $R call({String? email, List<String>? categoriasSeleccionadas}) =>
      $apply(FieldCopyWithData({
        if (email != null) #email: email,
        if (categoriasSeleccionadas != null)
          #categoriasSeleccionadas: categoriasSeleccionadas
      }));
  @override
  Preferencia $make(CopyWithData data) => Preferencia(
      email: data.get(#email, or: $value.email),
      categoriasSeleccionadas: data.get(#categoriasSeleccionadas,
          or: $value.categoriasSeleccionadas));

  @override
  PreferenciaCopyWith<$R2, Preferencia, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PreferenciaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
