import Foundation
import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#else
#endif

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

@available(OSX 10.15, iOS 13.0, *)
extension Color: ViewConverterWrappable {}
@available(OSX 10.15, iOS 13.0, *)
public extension ViewConverter where Source == Color {
    private func convert(_ handler: (UnsafeMutablePointer<CGFloat>?, UnsafeMutablePointer<CGFloat>?, UnsafeMutablePointer<CGFloat>?, UnsafeMutablePointer<CGFloat>?) -> Void) -> (Double, Double, Double, Double) {
        var hsba: (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        handler(&hsba.0, &hsba.1, &hsba.2, &hsba.3)
        return (Double(hsba.0), saturation: Double(hsba.1), brightness: Double(hsba.2), alpha: Double(hsba.3))
    }
    
    #if os(iOS)
    typealias SourceColor = UIColor
    #elseif os(macOS)
    typealias SourceColor = NSColor
    #else
    #endif
    func color(from color: SourceColor) -> Color {
        let hsba = self.convert(color.getHue)
        return Color(hue: hsba.0, saturation: hsba.1, brightness: hsba.2, opacity: hsba.3)
    }
}
