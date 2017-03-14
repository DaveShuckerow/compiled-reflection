import 'package:barback/barback.dart';

class DeepEqualityTransformer extends Transformer {
  DeepEqualityTransformer.asPlugin();

  @override
  Future apply(Transform transform) async {
    var content = transform.primaryInput.readAsString();
    print(content);
  }

  @override
  String get allowedExtensions => ".dart";
}
