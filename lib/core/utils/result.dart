sealed class Result<T> {
  const Result();
  R when<R>({required R Function(T) ok, required R Function(Object) err}) => switch (this) {
        Ok<T>(:final value) => ok(value),
        Err<T>(:final error) => err(error),
      };
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

class Err<T> extends Result<T> {
  final Object error;
  const Err(this.error);
}
