import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';

class SourceAsset {
  final String id;
  final String contents;

  const SourceAsset(this.id, this.contents);
}

class TestAsset {
  final SourceAsset input;
  final SourceAsset output;

  const TestAsset(this.input, this.output);
}

SourceAsset _compiledMirrorsSource;
Future<SourceAsset> get compiledMirrorsSource async {
  if (_compiledMirrorsSource != null) {
    return _compiledMirrorsSource;
  }
  var runfiles = Platform.environment['RUNFILES'];
  print(runfiles);
  var annotationFile = 'lib/compiled_mirrors.dart';
  return _compiledMirrorsSource = new SourceAsset(
    'compiled_mirrors|lib/compiled_mirrors.dart',
    await new File('$annotationFile').readAsString(),
  );
}

Future<Null> testBuilderWithAssets(
    Builder toTest, Iterable<TestAsset> assets) async {
  var compiledMirrors = await compiledMirrorsSource;
  var inputs = <String, String>{
    compiledMirrors.id: compiledMirrors.contents,
  };
  var outputs = <String, String>{};
  for (var asset in assets) {
    inputs[asset.input.id] = asset.input.contents;
    outputs[asset.output.id] = asset.output.contents;
  }
  return await testBuilder(
    toTest,
    inputs,
    generateFor: new Set.from(assets.map((a) => a.input.id)),
    outputs: outputs,
  );
}
