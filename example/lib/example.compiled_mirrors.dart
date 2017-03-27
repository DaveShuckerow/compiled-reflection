import 'package:compiled_mirrors/compiled_mirrors.dart';
import 'example.dart';

class Eq1$CompiledMirror extends CompiledMirror<Eq1> {
  @override
  final Eq1 instance;

  @override
  final Map<Symbol, FieldAccessor> fields;

  Eq1$CompiledMirror(Eq1 instance):
    this.instance = instance,
    this.fields = {
      #foo: () => instance.foo,
      #bar: () => instance.bar,
    };

}
