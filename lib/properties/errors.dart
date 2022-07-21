class InvalidPropertyError extends Error {
  String lexeme;
  String message;

  InvalidPropertyError(this.lexeme, this.message);

  @override
  String toString() {
    return 'InvalidPropertyError with `$lexeme`: $message';
  }
}

class ChildCountError extends Error {
  String message;

  ChildCountError(this.message);

  @override
  String toString() {
    return 'ChildCountError: $message';
  }
}
