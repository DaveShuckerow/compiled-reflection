import 'package:compiled_mirrors/compiled_mirrors.dart';
import 'package:quiver/core.dart';

/// Utility for generating object override methods.
class MirrorEquality {
  // This static class shouldn't be constructed.
  MirrorEquality._();

  /// Evaluates whether two reflections are equal.
  ///
  /// To use this as a class' equals operator, do the following:
  ///
  /// @compileMirror
  /// class Foo {
  ///   @override
  ///   bool operator==(Object other) => MirrorEquality<Foo>.equals(
  ///         this, other, (foo) => new Foo$CompiledMirror(foo));
  /// }
  static bool equals<T>(T self, other, CompiledMirror<T> mirror(T object)) {
    if (other is T) {
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
  static int hash<T>(T self, CompiledMirror<T> mirror(T object)) {
    var mirrored = mirror(self);
    var fieldValues =
        mirrored.fields.values.map((valueGetter) => valueGetter());
    return hashObjects(fieldValues);
  }
}
