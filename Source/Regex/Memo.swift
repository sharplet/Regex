// Copyright (c) 2014 Rob Rix. All rights reserved.
//
// Source: https://github.com/robrix/Memo/blob/326153487940ab19c1d25761656269e25fbbf119/Memo/Memo.swift

/// Deferred, memoized evaluation.
internal struct Memo<T> {
  // MARK: Lifecycle

  /// Constructs a `Memo` which lazily evaluates the argument.
  init(_ unevaluated:  @escaping () -> T) {
    self.init(unevaluated: unevaluated)
  }

  /// Constructs a `Memo` which lazily evaluates the passed function.
  init(unevaluated: @escaping () -> T) {
    self.init(state: .unevaluated(unevaluated))
  }

  /// Constructs a `Memo` wrapping the already-evaluated argument.
  init(evaluated: T) {
    self.init(state: .evaluated(evaluated))
  }

  // MARK: Properties

  /// Returns the value held by the receiver, computing & memoizing it first if necessary.
  var value: T {
    return state.value.value()
  }

  // MARK: Private

  /// Initialize with the passed `state`.
  private init(state: MemoState<T>) {
    self.state = MutableBox(state)
  }

  /// The underlying state.
  ///
  /// The `enum` implements the basic semantics (either evaluated or un),
  /// while the `MutableBox` provides us with reference semantics for the
  /// memoized result.
  private let state: MutableBox<MemoState<T>>
}

// MARK: Private

/// Private state for memoization.
private enum MemoState<T> {
  case evaluated(T)
  case unevaluated(() -> T)

  /// Return the value, computing and memoizing it first if necessary.
  mutating func value() -> T {
    switch self {
    case let .evaluated(x):
      return x
    case let .unevaluated(f):
      let value = f()
      self = .evaluated(value)
      return value
    }
  }
}

/// A mutable reference type boxing a value.
private final class MutableBox<T> {
  init(_ value: T) {
    self.value = value
  }

  var value: T
}
