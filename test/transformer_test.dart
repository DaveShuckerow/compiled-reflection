import 'package:compiled_mirrors/src/transformer/builder.dart';
import 'package:test/test.dart';

import 'util.dart';

main() {
  CompiledMirrorsBuilder builder;
  setUp(() {
    builder = new CompiledMirrorsBuilder();
  });

  group('Builder generates for a library', () {
    test('with a single class', () async {
      await testBuilderWithAssets(builder, [_oneClassAnnotatedLibrary]);
    });
    test('with varied type annotations', () async {
      await testBuilderWithAssets(builder, [_variedDeclarationsLibrary]);
    });
    test('with no annotations', () async {
      await testBuilderWithAssets(builder, [_noAnnotationsLibrary]);
    });
  });

  group('Builder generates with several libraries', () {
    test('with 3 libraries', () async {
      await testBuilderWithAssets(builder, [
        _oneClassAnnotatedLibrary,
        _variedDeclarationsLibrary,
        _noAnnotationsLibrary,
      ]);
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

const TestAsset _variedDeclarationsLibrary = const TestAsset(
  const SourceAsset(
    'test_builder|lib/various_declarations.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';

@compileMirror
class VariedDeclarations {
  static const constantField = 'static const';
  var foo = 7;
  final int bar = 8;
  final int baz;
  var bop;
}
''',
  ),
  const SourceAsset(
    'test_builder|lib/various_declarations.compiled_mirrors.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';
import 'various_declarations.dart';

class VariedDeclarations$CompiledMirror extends CompiledMirror<VariedDeclarations> {
  @override
  final VariedDeclarations instance;

  @override
  final Map<Symbol, FieldAccessor> fields;

  VariedDeclarations$CompiledMirror(VariedDeclarations instance):
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

const TestAsset _noAnnotationsLibrary = const TestAsset(
  const SourceAsset(
    'test_builder|lib/no_annotations.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';

class NoAnnotations {
  var foo;
  final bar = 8;
  static baz;
}
''',
  ),
  null,
);
