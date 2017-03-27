/// The deep equality annotation.
const compileMirros = const CompileMirrors._();

class CompileMirrors {
  const CompileMirrors._();
}

typedef dynamic FieldAccessor<C, T>(C classInstance);

abstract class CompiledMirrors<C> {
  Map<String, FieldAccessor> get fields;
}
