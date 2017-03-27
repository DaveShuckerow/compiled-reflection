import 'dart:async';

import 'package:build_runner/build_runner.dart';
import 'package:compiled_mirrors/src/transformer/builder.dart';

/// Generates compiled mirrors for the annotated classes in the current package.
Future main() async {
  var graph = new PackageGraph.forThisPackage();
  var phases = new PhaseGroup()
    ..newPhase().addAction(new CompiledMirrorsBuilder(),
        new InputSet(graph.root.name, ['**/*.dart']));

  await build(phases);
}
