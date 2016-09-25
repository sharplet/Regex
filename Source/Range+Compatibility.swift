#if !swift(>=3.0)
extension Range {
  var lowerBound: Element {
    return startIndex
  }

  var upperBound: Element {
    return endIndex
  }
}
#endif
