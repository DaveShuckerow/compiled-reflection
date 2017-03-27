import 'package:analyzer/dart/element/element.dart';

/// Generates code describing the fields on a deep-equality class.
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

  String get className => classElement.name;
  Iterable<Element> get classFields => classElement.fields;

  /// Writes Dart that builds a map from field names in [classElement] to
  /// the accessor that retrieves the value of the field.
  String get generatedCode {
    var code = '';
    code += 'class $className\$CompiledMirror extends CompiledMirror {\n';
    code += '}\n';
    return code;
  }

  String get _fieldDescription {
    var code = 'var \$$className\$fieldNamesToAccessor = {\n';
    for (var field in classFields) {
      code += "  '${field.name}': (c) => c.${field.name},\n";
    }
    code += '};\n';
    return code;
  }
}
