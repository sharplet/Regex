extension Regex {
  internal static let _lastMatch: ThreadLocal<MatchResult> = ThreadLocal("me.sharplet.Regex.lastMatch")

  /// After any match, the result will be stored in this property for later use.
  /// This is useful when pattern matching:
  ///
  ///     switch "hello" {
  ///     case Regex("l+"):
  ///       let count = Regex.lastMatch!.matchedString.count
  ///       print("matched \(count) characters")
  ///     default:
  ///       break
  ///     }
  ///
  /// This property uses thread-local storage, and thus is thread safe.
  public static var lastMatch: MatchResult? {
    return _lastMatch.value
  }
}
