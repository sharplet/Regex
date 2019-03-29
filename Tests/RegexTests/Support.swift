struct DynamicCastError: Error {
  var value: Any
  var expectedType: Any.Type
  var file: String
  var line: Int
}

func cast<T>(_ value: Any, to _: T.Type, file: String = #file, line: Int = #line) throws -> T {
  if let value = value as? T {
    return value
  } else {
    throw DynamicCastError(value: value, expectedType: T.self, file: file, line: line)
  }
}
