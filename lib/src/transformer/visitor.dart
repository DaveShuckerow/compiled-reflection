import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

import 'generator.dart';

class DeepEqualityVisitor extends SimpleElementVisitor {
  static const deepEqualityKey = const _UniqueKey(
      'asset:compiled_mirrors/lib/compiled_mirrors.dart', 'CompileMirror');
  final List<DescriptionGenerator> descriptionGenerators =
      <DescriptionGenerator>[];

  DeepEqualityVisitor();

  visitCompilationUnitElement(CompilationUnitElement element) {
    for (var classElement in element.types) {
      visitClassElement(classElement);
    }
  }

  @override
  visitClassElement(ClassElement element) {
    var hasDeepEquality = false;
    for (var annotation in element.metadata) {
      var key = new _UniqueKey.fromElementAnnotation(annotation);
      if (key.key == deepEqualityKey.key) hasDeepEquality = true;
    }
    if (!hasDeepEquality) {
      return;
    }
    var generator = new DescriptionGenerator(element);
    descriptionGenerators.add(generator);
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
