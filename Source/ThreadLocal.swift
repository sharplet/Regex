#if swift(>=3.0)
private typealias _Thread = Thread
#else
private typealias _Thread = NSThread
#endif

/// Convenience wrapper for generically storing values of type `T` in thread-local storage.
internal final class ThreadLocal<T> {

  let key: String

  init(_ key: String) {
    self.key = key
  }

  var value: T? {
    get {
#if swift(>=3.0)
      return _currentThread.threadDictionary[key] as? T
#else
      guard let value = _currentThread.threadDictionary[key] else { return nil }
      return (value as? Box<T>).map { $0.value } ?? value as? T
#endif
    }
    set {
#if swift(>=3.0)
      _currentThread.threadDictionary[key] = newValue
#else
      _currentThread.threadDictionary[key] = (newValue as? AnyObject) ?? newValue.map(Box.init)
#endif
    }
  }

  private var _currentThread: _Thread {
#if swift(>=3.0)
    return _Thread.current
#else
    return _Thread.currentThread()
#endif
  }

}

private class Box<T> {
  let value: T
  init(_ value: T) { self.value = value }
}

import Foundation
