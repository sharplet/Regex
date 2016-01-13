extension SequenceType {

  internal func takeFirst() -> Generator.Element? {
    var generator = generate()
    return generator.next()
  }

}
