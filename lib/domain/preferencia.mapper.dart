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

  static List<String> _$categoriasSeleccionadas(Preferencia v) =>
      v.categoriasSeleccionadas;
  static const Field<Preferencia, List<String>> _f$categoriasSeleccionadas =
      Field('categoriasSeleccionadas', _$categoriasSeleccionadas,
          mode: FieldMode.member);
  static String? _$id(Preferencia v) => v.id;
  static const Field<Preferencia, String> _f$id =
      Field('id', _$id, mode: FieldMode.member);

  @override
  final MappableFields<Preferencia> fields = const {
    #categoriasSeleccionadas: _f$categoriasSeleccionadas,
    #id: _f$id,
  };

  static Preferencia _instantiate(DecodingData data) {
    return Preferencia.empty();
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
  $R call();
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
  $R call() => $apply(FieldCopyWithData({}));
  @override
  Preferencia $make(CopyWithData data) => Preferencia.empty();

  @override
  PreferenciaCopyWith<$R2, Preferencia, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PreferenciaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
