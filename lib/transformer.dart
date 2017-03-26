import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:deep_equality/deep_equality.dart';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:build_barback/build_barback.dart';

class DeepEqualityTransformer extends BuilderTransformer {
  DeepEqualityTransformer.asPlugin() : super(new DeepEqualityBuilder());

  @override
  String get allowedExtensions => '.dart';
}

class DeepEqualityBuilder extends Builder {
  @override
  Future build(BuildStep buildStep) async {
    var inputId = await buildStep.inputId;
    var outputId = _transformId(inputId);
    var resolver = await buildStep.resolver;
    for (var l in resolver.libraries) {
      print(l.library.source.uri);
    }
    var library = resolver.getLibrary(inputId);
    log.warning(
        'Investigating library ${library.exportNamespace.definedNames.keys}');
    library.visitChildren(new DeepEqualityVisitor());
  }

  @override
  List<AssetId> declareOutputs(AssetId inputId) => [_transformId(inputId)];

  AssetId _transformId(AssetId inputId) =>
      inputId.changeExtension('.deep_equals.dart');
}

class DeepEqualityVisitor extends SimpleElementVisitor {
  final classElementToPublicFields = <ClassElement, FieldElement>{};

  DeepEqualityVisitor();

  visitCompilationUnitElement(CompilationUnitElement element) {
    log.warning('looking at types ${element.types}');
    for (var classElement in element.types) {
      visitClassElement(classElement);
    }
  }

  @override
  visitClassElement(ClassElement element) {
    var eKey = new _UniqueKey.fromClassElement(element);
    log.warning('Looking at ${eKey.key} metadata: ${element.metadata}');
    var hasDeepEquality = false;
    for (var annotation in element.metadata) {
      var key = new _UniqueKey.fromElementAnnotation(annotation);
      log.warning('$element is annotated ${key.key}!');
      log.warning('${annotation.constantValue.runtimeType}');
    }
    if (!hasDeepEquality) {
      return;
    }
    for (var field in element.fields) {
      log.warning('Found field $field');
    }
  }
}

/// A uniquely-identifying key for a class or annotation.
class _UniqueKey {
  final String key;

  const _UniqueKey(String uri, String name) : key = '$uri:$name';
  _UniqueKey.fromClassElement(ClassElement element)
      : this('${element.librarySource.uri}', '${element.name}');
  _UniqueKey.fromElementAnnotation(ElementAnnotation annotation)
      : this('${resolve(annotation).librarySource.uri}',
            '${annotation.computeConstantValue().type}');

  static ClassElement resolve(ElementAnnotation annotation,
      [LibraryElement library, Set<LibraryElement> visited]) {
    ClassElement resolution;
    // Search our library if none is specified.
    if (library == null) {
      library = annotation.element.library;
    }
    if (visited == null) {
      visited = new Set<LibraryElement>();
    }
    if (!visited.contains(library)) {
      visited.add(library);
    }
    // Resolve the annotation if possible.  If not, search imports for the
    // annotation.
    resolution = library.getType('${annotation.constantValue.type}');
    for (var importedLibrary in library.importedLibraries) {
      resolution ??=
          importedLibrary.getType('${annotation.constantValue.type}');
    }
    return resolution;
  }
}
