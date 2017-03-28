import 'package:compiled_mirrors/compiled_mirrors.dart';
import 'package:compiled_mirrors/equality.dart';

export 'example.compiled_mirrors.dart';

@compileMirror
class Example {
  String foo;
  int bar;

  @override
  bool operator ==(Object other) => MirrorEquality.equals<Example>(
      this, other, (c) => new Example$CompiledMirror(c));

  @override
  int get hashCode =>
      MirrorEquality.hash<Example>(this, (c) => new Example$CompiledMirror(c));
}
