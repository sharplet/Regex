internal extension NSTextCheckingResult {
  var ranges: [NSRange] {
#if swift(>=3.0)
    return stride(from: 0, to: numberOfRanges, by: 1).map(rangeAt)
#else
    return 0.stride(to: numberOfRanges, by: 1).map(rangeAtIndex)
#endif
  }
}

internal extension String {
  var entireRange: NSRange {
    return NSRange(location: 0, length: utf16.count)
  }
}

import Foundation
