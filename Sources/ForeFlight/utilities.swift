import Foundation

extension Array {
  var second: Element? { indices.contains(1) ? self[1] : nil }
  var third: Element? { indices.contains(2) ? self[2] : nil }
  var fourth: Element? { indices.contains(3) ? self[3] : nil }
  var fifth: Element? { indices.contains(4) ? self[4] : nil }
  var sixth: Element? { indices.contains(5) ? self[5] : nil }
}
