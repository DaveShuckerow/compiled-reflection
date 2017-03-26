/// The deep equality annotation.
const compileReflection = const CompileReflection._();

class CompileReflection {
  const CompileReflection._();
}

typedef T FieldAccessor<C, T>(C classInstance);

abstract class CompiledReflection<C> {
  Map<String, FieldAccessor> get fields;
}
