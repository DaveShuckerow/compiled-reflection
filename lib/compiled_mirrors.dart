/// The deep equality annotation.
const compileReflection = const CompileReflection._();

class CompileReflection {
  const CompileReflection._();
}

typedef dynamic FieldAccessor<C, T>(C classInstance);

abstract class CompiledReflection<C> {
  Map<String, FieldAccessor> get fields;
}
