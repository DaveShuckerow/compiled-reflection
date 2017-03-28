import 'package:analyzer/dart/element/element.dart';

/// Generates code describing the fields on a class.
///
/// We'll do this by building two levels of map.  The first level will be a
/// map from class types to field descriptors, then the field descriptors will
/// be a map from field names to accessors.
///
/// This class defines the field descriptor map, as well as the key to use in
/// the type to field descriptor map.
class DescriptionGenerator {
  final ClassElement classElement;

  DescriptionGenerator(this.classElement);

  String get _className => classElement.name;
  Iterable<Element> get _classFields {
    Map<String, Element> fromIterable(Iterable<Element> elements) {
      return new Map.fromIterables(elements.map((e) => e.name), elements);
    }

    var fields = fromIterable(classElement.fields);
    for (var mixin in classElement.mixins) {
      fields.addAll(fromIterable(mixin.accessors.where((a) => a.isGetter)));
    }
    var supertype = classElement.supertype;
    while (!supertype.isObject) {
      fields.addAll(fromIterable(supertype.accessors.where((a) => a.isGetter)));
      for (var mixin in supertype.mixins) {
        fields.addAll(fromIterable(mixin.accessors.where((a) => a.isGetter)));
      }
      supertype = supertype.superclass;
    }
    // By definition of [CompiledMirrors], we exclude the Object fields.
    var objectFields =
        new Set<String>.from(supertype.accessors.map((f) => f.name));
    for (var fieldName in objectFields) {
      fields.remove(fieldName);
    }
    var sortedKeys = fields.keys.toList()..sort();
    return sortedKeys.map((key) => fields[key]);
  }

  String get _generatedClassName => '$_className\$CompiledMirror';

  /// Writes Dart that builds a map from field names in [classElement] to
  /// the accessor that retrieves the value of the field.
  String get generatedCode {
    var code = '';
    code +=
        'class $_generatedClassName extends CompiledMirror<$_className> {\n';
    code += _fields;
    code += _constructor;
    code += '}\n';
    return code;
  }

  String get _constructor {
    var code = '';
    code += '  $_generatedClassName($_className instance):\n';
    code += '    this.instance = instance,\n';
    code += '    this.fields = {\n';
    for (var field in _classFields) {
      code += '      #${field.name}: () => instance.${field.name},\n';
    }
    code += '    };\n';
    code += '\n';
    return code;
  }

  String get _fields {
    var code = '';
    code += '  @override\n';
    code += '  final $_className instance;\n';
    code += '\n';
    code += '  @override\n';
    code += '  final Map<Symbol, FieldAccessor> fields;\n';
    code += '\n';
    return code;
  }
}
