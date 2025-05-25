// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'task_cache_prefs.dart';

class TaskCachePrefsMapper extends ClassMapperBase<TaskCachePrefs> {
  TaskCachePrefsMapper._();

  static TaskCachePrefsMapper? _instance;
  static TaskCachePrefsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TaskCachePrefsMapper._());
      TaskMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TaskCachePrefs';

  static String _$usuario(TaskCachePrefs v) => v.usuario;
  static const Field<TaskCachePrefs, String> _f$usuario =
      Field('usuario', _$usuario);
  static List<Task> _$misTareas(TaskCachePrefs v) => v.misTareas;
  static const Field<TaskCachePrefs, List<Task>> _f$misTareas =
      Field('misTareas', _$misTareas);

  @override
  final MappableFields<TaskCachePrefs> fields = const {
    #usuario: _f$usuario,
    #misTareas: _f$misTareas,
  };

  static TaskCachePrefs _instantiate(DecodingData data) {
    return TaskCachePrefs(
        usuario: data.dec(_f$usuario), misTareas: data.dec(_f$misTareas));
  }

  @override
  final Function instantiate = _instantiate;

  static TaskCachePrefs fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TaskCachePrefs>(map);
  }

  static TaskCachePrefs fromJson(String json) {
    return ensureInitialized().decodeJson<TaskCachePrefs>(json);
  }
}

mixin TaskCachePrefsMappable {
  String toJson() {
    return TaskCachePrefsMapper.ensureInitialized()
        .encodeJson<TaskCachePrefs>(this as TaskCachePrefs);
  }

  Map<String, dynamic> toMap() {
    return TaskCachePrefsMapper.ensureInitialized()
        .encodeMap<TaskCachePrefs>(this as TaskCachePrefs);
  }

  TaskCachePrefsCopyWith<TaskCachePrefs, TaskCachePrefs, TaskCachePrefs>
      get copyWith =>
          _TaskCachePrefsCopyWithImpl<TaskCachePrefs, TaskCachePrefs>(
              this as TaskCachePrefs, $identity, $identity);
  @override
  String toString() {
    return TaskCachePrefsMapper.ensureInitialized()
        .stringifyValue(this as TaskCachePrefs);
  }

  @override
  bool operator ==(Object other) {
    return TaskCachePrefsMapper.ensureInitialized()
        .equalsValue(this as TaskCachePrefs, other);
  }

  @override
  int get hashCode {
    return TaskCachePrefsMapper.ensureInitialized()
        .hashValue(this as TaskCachePrefs);
  }
}

extension TaskCachePrefsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TaskCachePrefs, $Out> {
  TaskCachePrefsCopyWith<$R, TaskCachePrefs, $Out> get $asTaskCachePrefs =>
      $base.as((v, t, t2) => _TaskCachePrefsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TaskCachePrefsCopyWith<$R, $In extends TaskCachePrefs, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Task, TaskCopyWith<$R, Task, Task>> get misTareas;
  $R call({String? usuario, List<Task>? misTareas});
  TaskCachePrefsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TaskCachePrefsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TaskCachePrefs, $Out>
    implements TaskCachePrefsCopyWith<$R, TaskCachePrefs, $Out> {
  _TaskCachePrefsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TaskCachePrefs> $mapper =
      TaskCachePrefsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Task, TaskCopyWith<$R, Task, Task>> get misTareas =>
      ListCopyWith($value.misTareas, (v, t) => v.copyWith.$chain(t),
          (v) => call(misTareas: v));
  @override
  $R call({String? usuario, List<Task>? misTareas}) =>
      $apply(FieldCopyWithData({
        if (usuario != null) #usuario: usuario,
        if (misTareas != null) #misTareas: misTareas
      }));
  @override
  TaskCachePrefs $make(CopyWithData data) => TaskCachePrefs(
      usuario: data.get(#usuario, or: $value.usuario),
      misTareas: data.get(#misTareas, or: $value.misTareas));

  @override
  TaskCachePrefsCopyWith<$R2, TaskCachePrefs, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TaskCachePrefsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
