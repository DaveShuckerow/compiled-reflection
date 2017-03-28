import 'package:example/example.dart';

void main() {
  var ex1 = new Example()..foo = 'Foo';
  var ex2 = new Example()..foo = 'Foo';
  print('two equal examples will be equal: ${ex1 == ex2}');
  ex1.bar = 7;
  ex2.bar = -12;
  print('two nonequal examples will not be equal: ${ex1 == ex2}');
}
