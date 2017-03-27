import 'package:example/example.dart';

void main() {
  var eq1 = new Eq1();
  var eq2 = new Eq1();
  print('two eqs without their equals methods implemented will not be '
      'equal: ${eq1 == eq2}');
  var eq1Mirror = new Eq1$CompiledMirror(eq1);
  var eq2Mirror = new Eq1$CompiledMirror(eq2);
  print('two mirrors can determine that they are equal: '
      '${eq1Mirror.deepEquals(eq2Mirror)}');
}
