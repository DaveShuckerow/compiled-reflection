import 'package:compiled_mirrors/src/transformer/builder.dart';
import 'package:test/test.dart';
import 'package:build_test/build_test.dart';

import 'util.dart';

main() {
  CompiledMirrorsBuilder builderToTest;
  setUp(() {
    builderToTest = new CompiledMirrorsBuilder();
  });

  group('Builder generates for a library', () {
    test('with a single class', () async {
      var compiledMirrors = await compiledMirrorsSource;
      await testBuilder(
        builderToTest,
        {
          compiledMirrors.id: compiledMirrors.contents,
          _oneClassAnnotatedLibrary.input.id:
              _oneClassAnnotatedLibrary.input.contents,
        },
        generateFor: new Set.from([_oneClassAnnotatedLibrary.input.id]),
        outputs: {
          _oneClassAnnotatedLibrary.output.id:
              _oneClassAnnotatedLibrary.output.contents,
        },
      );
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
'''),
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
'''),
);
