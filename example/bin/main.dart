import 'package:example/example.dart';

void main() {
  var eq1 = new Eq1();
  var eq2 = new Eq1();
  print(eq1 == eq2);
  var eq1Mirror = new Eq1$CompiledMirror(eq1);
  var eq2Mirror = new Eq1$CompiledMirror(eq2);
  print(eq1Mirror.deepEquals(eq2Mirror));
}
