import 'dart:async';
import 'dart:io';

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

Future<SourceAsset> get compiledMirrorsSource async {
  var runfiles = Platform.environment['RUNFILES'];
  print(runfiles);
  var annotationFile = 'lib/compiled_mirrors.dart';
  return new SourceAsset(
    'compiled_mirrors|lib/compiled_mirrors.dart',
    await new File('$annotationFile').readAsString(),
  );
}
