import Foundation

/// Convenience wrapper for generically storing values of type `T` in thread-local storage.
internal final class ThreadLocal<T> {
  let key: String

  init(_ key: String) {
    self.key = key
  }

  var value: T? {
    get {
#if swift(>=3.1)
      return Thread.current.threadDictionary[key] as? T
#else
      let box = Thread.current.threadDictionary[key] as? Box<T>
      return box?.value
#endif
    }
    set {
#if !swift(>=3.1)
      let newValue = newValue.map(Box.init(_:))
#endif
      Thread.current.threadDictionary[key] = newValue
    }
  }
}

#if !swift(>=3.1)
private final class Box<T> {
  let value: T

  init(_ value: T) {
    self.value = value
  }
}
#endif
