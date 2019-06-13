import SwiftUI

public struct ViewConverter<Source: ViewConverterWrappable> {
    let source: Source
}

public protocol ViewConverterWrappable {
    var view: ViewConverter<Self> { get }
}

public extension ViewConverterWrappable {
    var view: ViewConverter<Self> { return ViewConverter(source: self) }
}

extension String: ViewConverterWrappable {}
@available(OSX 10.15, *)
public extension ViewConverter where Source: StringProtocol {
    var text: Text { return Text(self.source) }
}
