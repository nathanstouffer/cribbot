import Foundation

enum CribOwner: CaseIterable {
  case computer
  case human

  mutating func toggle() {
    if self == .computer {
      self = .human
    } else {
      self = .computer
    }
  }
}
