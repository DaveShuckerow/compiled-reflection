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

    test('with an empty class', () async {
      await testBuilderWithAssets(builder, [_nameCollisionLibrary]);
    });

    test('with multiple classes', () async {
      await testBuilderWithAssets(builder, [_multiClassLibrary]);
    });

    test('with subclasses, superclasses, and mixins', () async {
      await testBuilderWithAssets(builder, [_extendedClassLibrary]);
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

    test('with a name collision in class names', () async {
      await testBuilderWithAssets(builder, [
        _emptyClassLibrary,
        _nameCollisionLibrary,
      ]);
    });
  });
}

// TODO(DaveShuckerow): find a way to regenerate the test outputs when
// changing the code generation.
const TestAsset _oneClassAnnotatedLibrary = const TestAsset(
  const SourceAsset(
    'test_builder|lib/one_class.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';

@compileMirror
class OneClass {
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

class OneClass$CompiledMirror extends CompiledMirror<OneClass> {
  @override
  final OneClass instance;

  @override
  final Map<Symbol, FieldAccessor> fields;

  OneClass$CompiledMirror(OneClass instance):
    this.instance = instance,
    this.fields = {
      #bar: () => instance.bar,
      #foo: () => instance.foo,
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
  int _bup;
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
      #_bup: () => instance._bup,
      #bar: () => instance.bar,
      #baz: () => instance.baz,
      #bop: () => instance.bop,
      #constantField: () => instance.constantField,
      #foo: () => instance.foo,
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

const TestAsset _emptyClassLibrary = const TestAsset(
  const SourceAsset(
    'test_builder|lib/empty_class.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';

@compileMirror
class EmptyClass {}
''',
  ),
  const SourceAsset(
    'test_builder|lib/empty_class.compiled_mirrors.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';
import 'empty_class.dart';

class EmptyClass$CompiledMirror extends CompiledMirror<EmptyClass> {
  @override
  final EmptyClass instance;

  @override
  final Map<Symbol, FieldAccessor> fields;

  EmptyClass$CompiledMirror(EmptyClass instance):
    this.instance = instance,
    this.fields = {
    };

}
''',
  ),
);

/// The class name in this library collides with [_emptyClassLibrary].
const TestAsset _nameCollisionLibrary = const TestAsset(
  const SourceAsset(
    'test_builder|lib/name_collision.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';

@compileMirror
class EmptyClass {}
''',
  ),
  const SourceAsset(
    'test_builder|lib/name_collision.compiled_mirrors.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';
import 'name_collision.dart';

class EmptyClass$CompiledMirror extends CompiledMirror<EmptyClass> {
  @override
  final EmptyClass instance;

  @override
  final Map<Symbol, FieldAccessor> fields;

  EmptyClass$CompiledMirror(EmptyClass instance):
    this.instance = instance,
    this.fields = {
    };

}
''',
  ),
);

const TestAsset _multiClassLibrary = const TestAsset(
  const SourceAsset(
    'test_builder|lib/multi_class.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';

@compileMirror
class ClassOne {
  String foo;
}

@compileMirror
class ClassTwo {
  var bar;
  var baz = 7;
}

class ClassThree {
  var ham;
  final spam;
  int eggs;
}

@compileMirror
class ClassFour {}
''',
  ),
  const SourceAsset(
    'test_builder|lib/multi_class.compiled_mirrors.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';
import 'multi_class.dart';

class ClassOne$CompiledMirror extends CompiledMirror<ClassOne> {
  @override
  final ClassOne instance;

  @override
  final Map<Symbol, FieldAccessor> fields;

  ClassOne$CompiledMirror(ClassOne instance):
    this.instance = instance,
    this.fields = {
      #foo: () => instance.foo,
    };

}

class ClassTwo$CompiledMirror extends CompiledMirror<ClassTwo> {
  @override
  final ClassTwo instance;

  @override
  final Map<Symbol, FieldAccessor> fields;

  ClassTwo$CompiledMirror(ClassTwo instance):
    this.instance = instance,
    this.fields = {
      #bar: () => instance.bar,
      #baz: () => instance.baz,
    };

}

class ClassFour$CompiledMirror extends CompiledMirror<ClassFour> {
  @override
  final ClassFour instance;

  @override
  final Map<Symbol, FieldAccessor> fields;

  ClassFour$CompiledMirror(ClassFour instance):
    this.instance = instance,
    this.fields = {
    };

}
''',
  ),
);

const TestAsset _extendedClassLibrary = const TestAsset(
  const SourceAsset(
    'test_builder|lib/extended_class.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';

@compileMirror
class BaseClass {
  String foo;
  int bar;
}

@compileMirror
class ExtendedClass extends BaseClass {
  @override
  String get foo => 5;

  @override
  set foo(String newValue) {}

  final var baz;
}

class Mixin {
  int ham;
  int spam;
}

@compileMirror
class ExtendedClassWithMixin extends BaseClass with Mixin {
  bool eggs = false;
}
''',
  ),
  const SourceAsset(
    'test_builder|lib/extended_class.compiled_mirrors.dart',
    r'''
import 'package:compiled_mirrors/compiled_mirrors.dart';
import 'extended_class.dart';

class BaseClass$CompiledMirror extends CompiledMirror<BaseClass> {
  @override
  final BaseClass instance;

  @override
  final Map<Symbol, FieldAccessor> fields;

  BaseClass$CompiledMirror(BaseClass instance):
    this.instance = instance,
    this.fields = {
      #bar: () => instance.bar,
      #foo: () => instance.foo,
    };

}

class ExtendedClass$CompiledMirror extends CompiledMirror<ExtendedClass> {
  @override
  final ExtendedClass instance;

  @override
  final Map<Symbol, FieldAccessor> fields;

  ExtendedClass$CompiledMirror(ExtendedClass instance):
    this.instance = instance,
    this.fields = {
      #bar: () => instance.bar,
      #baz: () => instance.baz,
      #foo: () => instance.foo,
    };

}

class ExtendedClassWithMixin$CompiledMirror extends CompiledMirror<ExtendedClassWithMixin> {
  @override
  final ExtendedClassWithMixin instance;

  @override
  final Map<Symbol, FieldAccessor> fields;

  ExtendedClassWithMixin$CompiledMirror(ExtendedClassWithMixin instance):
    this.instance = instance,
    this.fields = {
      #bar: () => instance.bar,
      #eggs: () => instance.eggs,
      #foo: () => instance.foo,
      #ham: () => instance.ham,
      #spam: () => instance.spam,
    };

}
''',
  ),
);
