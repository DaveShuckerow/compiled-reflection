import 'package:compiled_mirrors/src/transformer/builder.dart';
import 'package:test/test.dart';

import 'util.dart';

main() {
  CompiledMirrorsBuilder builderToTest;
  setUp(() {
    builderToTest = new CompiledMirrorsBuilder();
  });

  group('Builder generates for a library', () {
    test('with a single class', () async {
      await testBuilderWithAssets(builderToTest, [_oneClassAnnotatedLibrary]);
    });
    test('with varied type annotations', () async {
      await testBuilderWithAssets(
          builderToTest, [_varAndFinalAnnotatedLibrary]);
    });
  });
}

const TestAsset _oneClassAnnotatedLibrary = const TestAsset(
  const SourceAsset(
    'test_builder|lib/one_class.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';

@compileMirror
class Eq1 {
  String foo;
  int bar;
}
''',
  ),
  const SourceAsset(
    'test_builder|lib/one_class.compiled_mirrors.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';
import 'one_class.dart';

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
''',
  ),
);

const TestAsset _varAndFinalAnnotatedLibrary = const TestAsset(
  const SourceAsset(
    'test_builder|lib/varied_types.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';

@compileMirror
class VariedTypes {
  static const constantField = 'static const';
  var foo = 7;
  final int bar = 8;
  final int baz;
  var bop;
}
''',
  ),
  const SourceAsset(
    'test_builder|lib/varied_types.compiled_mirrors.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';
import 'varied_types.dart';

class VariedTypes$CompiledMirror extends CompiledMirror<VariedTypes> {
  @override
  final VariedTypes instance;

  @override
  final Map<Symbol, FieldAccessor> fields;

  VariedTypes$CompiledMirror(VariedTypes instance):
    this.instance = instance,
    this.fields = {
      #constantField: () => instance.constantField,
      #foo: () => instance.foo,
      #bar: () => instance.bar,
      #baz: () => instance.baz,
      #bop: () => instance.bop,
    };

}
''',
  ),
);
