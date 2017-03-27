/// The deep equality annotation.
const compileMirrors = const CompileMirrors._();

class CompileMirrors {
  const CompileMirrors._();
}

typedef dynamic FieldAccessor<C, T>(C classInstance);

abstract class CompiledMirrors<C> {
  Map<String, FieldAccessor> get fields;
}
