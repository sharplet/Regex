extension String {
  // MARK: Replacing the first match (mutating)

  /// If `regex` matches at least one substring, replace the first match with
  /// `template`.
  ///
  /// The template string may be a literal string, or include template variables:
  /// the variable `$0` will be replaced with the entire matched substring, `$1`
  /// with the first capture group, etc.
  ///
  /// For example, to include the literal string "$1" in the replacement string,
  /// you must escape the "$": `\$1`.
  ///
  /// - parameters:
  ///     - regex: A regular expression to match against `self`.
  ///     - template: A template string used to replace matches.
  public mutating func replaceFirst(matching regex: Regex, with template: String) {
    if let match = regex.firstMatch(in: self) {
      let replacement = regex
        ._regex
        .replacementString(
          for: match._result,
          in: self,
          offset: 0,
          template: template
        )

      replaceSubrange(match.range, with: replacement)
    }
  }

  /// If the regular expression described by `pattern` matches at least one
  /// substring, replace the first match with `template`.
  ///
  /// Convenience overload that accepts a `StaticString` instead of a `Regex`.
  ///
  /// The template string may be a literal string, or include template variables:
  /// the variable `$0` will be replaced with the entire matched substring, `$1`
  /// with the first capture group, etc.
  ///
  /// For example, to include the literal string "$1" in the replacement string,
  /// you must escape the "$": `\$1`.
  ///
  /// - requires: `pattern` is a valid regular expression. Invalid regular
  ///   expressions will cause this method to trap.
  ///
  /// - parameters:
  ///     - pattern: A regular expression pattern to match against `self`.
  ///     - template: A template string used to replace matches.
  public mutating func replaceFirst(matching pattern: StaticString, with template: String) {
    replaceFirst(matching: Regex(pattern), with: template)
  }

  // MARK: Replacing the first match (nonmutating)

  /// Returns a new string where the first match of `regex` is replaced with
  /// `template`.
  ///
  /// The template string may be a literal string, or include template variables:
  /// the variable `$0` will be replaced with the entire matched substring, `$1`
  /// with the first capture group, etc.
  ///
  /// For example, to include the literal string "$1" in the replacement string,
  /// you must escape the "$": `\$1`.
  ///
  /// - parameters:
  ///     - regex: A regular expression to match against `self`.
  ///     - template: A template string used to replace matches.
  ///
  /// - returns: A string with the first match of `regex` replaced by `template`.
  public func replacingFirst(matching regex: Regex, with template: String) -> String {
    var string = self
    string.replaceFirst(matching: regex, with: template)
    return string
  }

  /// Returns a new string where the first match of the regular expression
  /// described by `pattern` is replaced with `template`.
  ///
  /// Convenience overload that accepts a `StaticString` instead of a `Regex`.
  ///
  /// The template string may be a literal string, or include template variables:
  /// the variable `$0` will be replaced with the entire matched substring, `$1`
  /// with the first capture group, etc.
  ///
  /// For example, to include the literal string "$1" in the replacement string,
  /// you must escape the "$": `\$1`.
  ///
  /// - requires: `pattern` is a valid regular expression. Invalid regular
  ///   expressions will cause this method to trap.
  ///
  /// - parameters:
  ///     - pattern: A regular expression pattern to match against `self`.
  ///     - template: A template string used to replace matches.
  ///
  /// - returns: A string with the first match of `pattern` replaced by `template`.
  public func replacingFirst(matching pattern: StaticString, with template: String) -> String {
    return replacingFirst(matching: Regex(pattern), with: template)
  }

  // MARK: Replacing all matches (mutating)

  /// Replace each substring matched by `regex` with `template`.
  ///
  /// The template string may be a literal string, or include template variables:
  /// the variable `$0` will be replaced with the entire matched substring, `$1`
  /// with the first capture group, etc.
  ///
  /// For example, to include the literal string "$1" in the replacement string,
  /// you must escape the "$": `\$1`.
  ///
  /// - parameters:
  ///     - regex: A regular expression to match against `self`.
  ///     - template: A template string used to replace matches.
  public mutating func replaceAll(matching regex: Regex, with template: String) {
    var offset = 0

    for match in regex.matches(in: self) {
      let replacement = regex._regex.replacementString(
        for: match._result,
        in: self,
        offset: offset,
        template: template
      )

      var nsRange = match._result.range
      nsRange.location += offset

      replaceSubrange(Range(nsRange, in: self)!, with: replacement)

      offset += replacement.utf16.count - nsRange.length
    }
  }

  /// Replace each substring matched by the regular expression described in
  /// `pattern` with `template`.
  ///
  /// Convenience overload that accepts a `StaticString` instead of a `Regex`.
  ///
  /// The template string may be a literal string, or include template variables:
  /// the variable `$0` will be replaced with the entire matched substring, `$1`
  /// with the first capture group, etc.
  ///
  /// For example, to include the literal string "$1" in the replacement string,
  /// you must escape the "$": `\$1`.
  ///
  /// - requires: `pattern` is a valid regular expression. Invalid regular
  ///   expressions will cause this method to trap.
  ///
  /// - parameters:
  ///     - pattern: A regular expression pattern to match against `self`.
  ///     - template: A template string used to replace matches.
  public mutating func replaceAll(matching pattern: StaticString, with template: String) {
    replaceAll(matching: Regex(pattern), with: template)
  }

  // MARK: Replacing all matches (nonmutating)

  /// Returns a new string where each substring matched by `regex` is replaced
  /// with `template`.
  ///
  /// The template string may be a literal string, or include template variables:
  /// the variable `$0` will be replaced with the entire matched substring, `$1`
  /// with the first capture group, etc.
  ///
  /// For example, to include the literal string "$1" in the replacement string,
  /// you must escape the "$": `\$1`.
  ///
  /// - parameters:
  ///     - regex: A regular expression to match against `self`.
  ///     - template: A template string used to replace matches.
  ///
  /// - returns: A string with all matches of `regex` replaced by `template`.
  public func replacingAll(matching regex: Regex, with template: String) -> String {
    var string = self
    string.replaceAll(matching: regex, with: template)
    return string
  }

  /// Returns a new string where each substring matched by the regular
  /// expression described in `pattern` is replaced with `template`.
  ///
  /// Convenience overload that accepts a `StaticString` instead of a `Regex`.
  ///
  /// The template string may be a literal string, or include template variables:
  /// the variable `$0` will be replaced with the entire matched substring, `$1`
  /// with the first capture group, etc.
  ///
  /// For example, to include the literal string "$1" in the replacement string,
  /// you must escape the "$": `\$1`.
  ///
  /// - requires: `pattern` is a valid regular expression. Invalid regular
  ///   expressions will cause this method to trap.
  ///
  /// - parameters:
  ///     - pattern: A regular expression pattern to match against `self`.
  ///     - template: A template string used to replace matches.
  ///
  /// - returns: A string with all matches of `pattern` replaced by `template`.
  public func replacingAll(matching pattern: StaticString, with template: String) -> String {
    return replacingAll(matching: Regex(pattern), with: template)
  }
}
