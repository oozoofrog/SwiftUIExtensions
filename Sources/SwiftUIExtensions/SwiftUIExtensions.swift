import SwiftUI

public struct ViewConverter<Source: ViewConverterWrappable> {
    let source: Source
}

public protocol ViewConverterWrappable {
    var swiftUI: ViewConverter<Self> { get }
}

public extension ViewConverterWrappable {
    var swiftUI: ViewConverter<Self> { return ViewConverter(source: self) }
}

extension String: ViewConverterWrappable {}
@available(OSX 10.15, iOS 13.0, *)
public extension ViewConverter where Source: StringProtocol {
    var text: Text { return Text(self.source) }
}
