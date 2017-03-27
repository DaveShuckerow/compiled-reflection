import 'dart:async';
import 'package:build/build.dart';

import 'visitor.dart';

class CompiledMirrorsBuilder extends Builder {
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
    var visitor = new DeepEqualityVisitor();
    library.visitChildren(visitor);
    if (visitor.descriptionGenerators.isNotEmpty) {
      // write output.
      var outStr = "import 'package:compiled_mirrors/compiled_mirrors.dart';\n";
      outStr += "import '${inputId.path.split('/').last}';\n";
      for (var generator in visitor.descriptionGenerators) {
        outStr += '\n';
        outStr += generator.generatedCode;
      }
      log.info('Found classes annotated @compileMirrors in $inputId.\n'
          'Generating $outputId');
      buildStep.writeAsString(outputId, outStr);
    }
  }

  @override
  List<AssetId> declareOutputs(AssetId inputId) {
    if (inputId.extension == '.dart') {
      return [_transformId(inputId)];
    }
    return const [];
  }

  AssetId _transformId(AssetId inputId) =>
      inputId.changeExtension('.compiled_mirrors').addExtension('.dart');
}
