# Compiled Mirrors

Statically reflecting Dart classes.

Reflection in Dart through `dart:mirrors` is a powerful tool for building tests
and assorted utilities. However, when compiled to JavaScript and run in a
browser, mirrors can severely reduce code's performance. In Flutter, mirrors
are disabled entirely.

Compiled Mirrors generates a reflection of Dart classes annotated with
`@compileMirrors`. This allows you to do a number of interesting things.

## Testing complex classes
My focus has been on using this as a testing utility for evaluating the fields
between two complex objects. For example, suppose we have the following class:

```dart
class Person {
  final String firstName;
  final String lastName;
  final int age;
  final Location birthplace;
  final Location residence;
  final University almaMater;

  Person(this.firstName, this.lastName, this.gender, this.age,
      this.birthplace, this.residence, this.almaMater);

  factory Person.fromParents(Person mother, Person father) {
    // Make a new person with traits of both parents.
  }
}
```

Suppose we want to test the `fromParents` factory. We'd need to build an
expected Person for the results of the test, and an actual Person:

```dart
test('fromParents Person factory', () {
  var expected = new Person(/* various fields */);
  var actual = new Person.fromParents(testMother, testFather);
```

Without an equality definition for this person, we need to test against every
field in the Person object:
```dart
  expect(actual.firstName, expected.firstName);
  expect(actual.lastName, expected.lastName);
  // boilerplate continues.
});
```
Very verbose!

Also, if we decide later on that we want to add a birthDate field to Person,
the test will pass even if the factory generates a birthDate we didn't expect!
This is a bug waiting to happen.

### Mirrored fields
We can avoid this problem with a mirror of the object's fields. If we compile a
mirror for the Person object, we can generate an automatically-updating
equality test:

```dart
test('fromParents Person factory', () {
  var expected = new Person(/* various fields */);
  var actual = new Person.fromParents(testMother, testFather);
  var expectedFields = new Person$CompiledMirror(expected).fields;
  var actualFields = new Person$CompiledMirror(actual).fields;
  for (var fieldName in expectedFields.keys) {
    expect(actualFields[fieldName](), expectedFields[fieldName]());
  }
});
```

Much simpler and much more reliable!

## Other uses
There are other uses for mirrors. If there's a use case that you'd like a
compiled mirror for, please
[file an issue](https://github.com/DaveShuckerow/compiled-mirrors/issues/).
