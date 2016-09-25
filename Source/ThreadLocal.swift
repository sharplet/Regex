import Foundation

/// Convenience wrapper for generically storing values of type `T` in thread-local storage.
internal final class ThreadLocal<T> {

  let key: String

  init(_ key: String) {
    self.key = key
  }

  var value: T? {
    get {
      return Thread.current.threadDictionary[key] as? T
    }
    set {
      Thread.current.threadDictionary[key] = newValue
    }
  }

}
