extension SequenceType where Generator.Element == String {

  public func grep(regex: Regex) -> AnySequence<(String, MatchResult)> {
    let result = self
      .lazy
      .flatMap { line in
        regex.match(line).map { (line, $0) }
      }

    return AnySequence(result)
  }

  public func grep(pattern: String) -> AnySequence<(String, MatchResult)> {
    return grep(Regex(pattern))
  }

}
