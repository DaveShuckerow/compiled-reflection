import 'dart:async';

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
    for (var library in resolver.libraries) {
      library.visitChildren(new DeepEqualityVisitor());
    }
  }

  @override
  List<AssetId> declareOutputs(AssetId inputId) => [_transformId(inputId)];

  AssetId _transformId(AssetId inputId) =>
      inputId.changeExtension('.deep_equals.dart');
}

class DeepEqualityVisitor extends RecursiveElementVisitor {
  final classElementToPublicFields = <ClassElement, FieldElement>{};

  visitClassElement(ClassElement element) {
    if (!element.metadata.contains(deepEquality)) {
      return;
    }
  }
}
