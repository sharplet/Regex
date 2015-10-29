//  Copyright © 2015 Outware Mobile. All rights reserved.

internal extension NSTextCheckingResult {
  var ranges: [NSRange] {
    return 0.stride(to: numberOfRanges, by: 1).map(rangeAtIndex)
  }
}

internal extension String {
  var entireRange: NSRange {
    return NSRange(location: 0, length: utf16.count)
  }
}

import Foundation
