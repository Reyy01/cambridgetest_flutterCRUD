class Result<T> {
  const Result._();

  factory Result.ok({required T data}) = Ok<T>;

  factory Result.fail({required dynamic error}) = Fail<T>;

  static Result<T> guard<T>(T Function() body) {
    try {
      return Result<T>.ok(data: body());
    } on Exception catch (e) {
      return Result<T>.fail(error: e);
    }
  }

  static Future<Result<T>> guardFuture<T>(Future<T> Function() future) async {
    try {
      return Result<T>.ok(data: await future());
    } on Exception catch (e) {
      return Result<T>.fail(error: e);
    }
  }

  R when<R>({
    required R Function(T data) ok,
    required R Function(dynamic error) fail,
  }) {
    if (this is Ok<T>) {
      return ok((this as Ok<T>).data);
    } else if (this is Fail<T>) {
      return fail((this as Fail<T>).error);
    }
    throw Exception('Unhandled case');
  }

  R maybeWhen<R>({
    R Function(T data)? ok,
    R Function(dynamic error)? fail,
    required R Function() orElse,
  }) {
    if (this is Ok<T> && ok != null) {
      return ok((this as Ok<T>).data);
    } else if (this is Fail<T> && fail != null) {
      return fail((this as Fail<T>).error);
    }
    return orElse();
  }

  bool get isSuccess => this is Ok<T>;

  bool get isFailure => this is Fail<T>;

  void ifOk(void Function(T data) body) {
    if (this is Ok<T>) {
      body((this as Ok<T>).data);
    }
  }

  void ifFail(void Function(dynamic error) body) {
    if (this is Fail<T>) {
      body((this as Fail<T>).error);
    }
  }

  T get getValue {
    if (this is Ok<T>) {
      return (this as Ok<T>).data;
    } else {
      throw (this as Fail<T>).error;
    }
  }

  dynamic get getError {
    if (this is Fail<T>) {
      return (this as Fail<T>).error;
    } else {
      throw 'No error';
    }
  }
}

class Ok<T> extends Result<T> {
  final T data;
  Ok({required this.data}) : super._();
}

class Fail<T> extends Result<T> {
  final dynamic error;
  Fail({required this.error}) : super._();
}

extension ResultObjectExt<T> on T {
  Result<T> get asOk => Result<T>.ok(data: this);

  Result<T> asFail(Exception e) => Result<T>.fail(error: e);
}
