/// All classes annotated with this annotation will compile a mirror.
const compileMirror = const CompileMirror._();

class CompileMirror {
  const CompileMirror._();
}

typedef dynamic FieldAccessor<C, T>(C classInstance);

abstract class CompiledMirror<C> {
  Map<String, FieldAccessor> get fields;
}
