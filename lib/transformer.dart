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
      print(l.source.uri);
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
    log.warning('Looking at $element metadata: ${element.metadata}');
    var hasDeepEquality = false;
    for (var annotation in element.metadata) {
      log.warning('$element is annotated ${annotation.constantValue.type}!');
    }
    if (!hasDeepEquality) {
      return;
    }
    for (var field in element.fields) {
      log.warning('Found field $field');
    }
  }
}
