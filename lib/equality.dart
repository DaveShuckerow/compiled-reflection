import 'package:compiled_mirrors/compiled_mirrors.dart';
import 'package:quiver/core.dart';

/// Utility for generating object override methods.
class MirrorEquality {
  // This static class shouldn't be constructed.
  MirrorEquality._();

  /// Evaluates whether two reflections are equal.
  ///
  /// To use this as an operator==, do the following:
  ///
  /// @compileMirror
  /// class Foo {
  ///   @override
  ///   bool operator==(Object other) => MirrorEquality.equals(
  ///         this, other, (foo) => new Foo$CompiledMirror(foo));
  /// }
  static bool equals<T>(T self, other, CompiledMirror<T> mirror(T object)) {
    // If [other] is castable to [T] then we will test its fields for equality.
    if (other as T != null) {
      var myMirror = mirror(self);
      var otherMirror = mirror(other);
      for (var symbol in myMirror.fields.keys) {
        if (myMirror.fields[symbol]() != otherMirror.fields[symbol]()) {
          return false;
        }
      }
      // If all fields are equal, then the objects are equal.
      return true;
    }
    // If the types are incompatible, then the objects are not equal.
    return false;
  }

  /// Returns the hash of all the fields of [instance].
  ///
  /// To use this as a hashCode getter, do the following:
  ///
  /// @compileMirror
  /// class Foo {
  ///   @override
  ///   int get hashCode => MirrorEquality.hash(
  ///         this, (foo) => new Foo$CompiledMirror(foo));
  /// }
  static int hash<T>(T self, CompiledMirror<T> mirror(T object)) {
    var fields = mirror(self).fields;
    var fieldValues = fields.values.map((valueGetter) => valueGetter());
    return hashObjects(fieldValues);
  }

  /// Represents a [T] as a String describing all of its fields.
  ///
  /// This is useful for debugging in tests. To use it as a toString method,
  /// do the following:
  ///
  /// @compileMirror
  /// class Foo {
  ///   @override
  ///   String toString => MirrorEquality.asString(
  ///         this, (foo) => new Foo$CompiledMirror(foo));
  /// }
  static String asString<T>(T self, CompiledMirror<T> mirror(T object)) {
    var fields = mirror(self).fields;
    var result = '${self.runtimeType}(\n';
    for (var symbol in fields.keys) {
      result += '  $symbol: ${fields[symbol]()},\n';
    }
    result += ')';
    return result;
  }
}
