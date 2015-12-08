public struct Options: OptionSetType {

  public static let IgnoreCase = Options(rawValue: 1)
  public static let IgnoreMetacharacters = Options(rawValue: 1 << 1)
  public static let AnchorsMatchLines = Options(rawValue: 1 << 2)

  // MARK: OptionSetType

  public let rawValue: Int

  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

}

internal extension Options {

  func toNSRegularExpressionOptions() -> NSRegularExpressionOptions {
    var options = NSRegularExpressionOptions()
    if contains(.IgnoreCase) { options.insert(.CaseInsensitive) }
    if contains(.IgnoreMetacharacters) { options.insert(.IgnoreMetacharacters) }
    if contains(.AnchorsMatchLines) { options.insert(.AnchorsMatchLines) }
    return options
  }

}
