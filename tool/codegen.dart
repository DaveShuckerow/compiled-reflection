import 'dart:async';

import 'package:build_runner/build_runner.dart';
import 'package:compiled_mirrors/transformer.dart';

Future main() async {
  /// Builds a full package dependency graph for the current package.
  var graph = new PackageGraph.forThisPackage();
  var phases = new PhaseGroup()
    ..newPhase().addAction(new DeepEqualityBuilder(),
        new InputSet(graph.root.name, ['**/*.dart']));

  await build(phases);
}
