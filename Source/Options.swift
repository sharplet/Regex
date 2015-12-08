public struct Options: OptionSetType {

  public static let IgnoreCase = Options(rawValue: 1)

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
    return options
  }

}
