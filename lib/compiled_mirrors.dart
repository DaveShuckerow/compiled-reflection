/// All classes annotated with this annotation will compile a mirror.
const compileMirror = const CompileMirror._();

class CompileMirror {
  const CompileMirror._();
}

typedef T FieldAccessor<T>();

/// A mirror of an [instance] of a class.
///
/// Contains all of the fields of [instance].
abstract class CompiledMirror<C> {
  /// The particular instance that is being mirrored.
  C get instance;

  /// Symbols for each field's name to an accessor for [instance]'s field value.
  Map<Symbol, FieldAccessor> get fields;

  String toDeepString() {
    var result = '${instance.runtimeType}(\n';
    for (var symbol in fields.keys) {
      result += '  $symbol: ${fields[symbol]()},\n';
    }
    result += ')';
    return result;
  }
}
