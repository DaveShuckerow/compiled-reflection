import 'package:compiled_mirrors/compiled_mirrors.dart';
import 'example.dart';

class Example$CompiledMirror extends CompiledMirror<Example> {
  @override
  final Example instance;

  @override
  final Map<Symbol, FieldAccessor> fields;

  Example$CompiledMirror(Example instance):
    this.instance = instance,
    this.fields = {
      #bar: () => instance.bar,
      #foo: () => instance.foo,
    };

}
