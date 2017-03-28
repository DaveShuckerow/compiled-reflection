import 'package:compiled_mirrors/compiled_mirrors.dart';
import 'package:compiled_mirrors/equality.dart';

import 'example.compiled_mirrors.dart';

class Super1 {
  int ham;
}

class Super2 {
  int spam;
}

@compileMirror
class Example extends Super1 {
  String foo;
  int bar;

  @override
  bool operator ==(Object other) =>
      MirrorEquality.equals(this, other, (c) => new Example$CompiledMirror(c));

  @override
  int get hashCode =>
      MirrorEquality.hash(this, (c) => new Example$CompiledMirror(c));

  @override
  String toString() =>
      MirrorEquality.asString(this, (c) => new Example$CompiledMirror(c));
}
