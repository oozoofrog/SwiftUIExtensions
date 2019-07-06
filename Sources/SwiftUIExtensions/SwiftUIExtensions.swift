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

public extension ViewConverterWrappable where Self: NSObject {
    var swiftUI: ViewConverter<Self> { return ViewConverter(source: self) }
}

extension String: ViewConverterWrappable {
    public var swiftUI: ViewConverter<String> { return ViewConverter(source: self) }
}
@available(OSX 10.15, iOS 13.0, *)
public extension ViewConverter where Source: StringProtocol {
    var text: Text { return Text(self.source) }
}

@available(OSX 10.15, iOS 13.0, *)
extension Color: ViewConverterWrappable {
    public var swiftUI: ViewConverter<Color> { return ViewConverter(source: self) }
}
#if os(iOS)
public typealias SourceColor = UIColor
#elseif os(macOS)
public typealias SourceColor = NSColor
#else
#endif
@available(OSX 10.15, iOS 13.0, *)
public extension Color {
    static private func convert(_ handler: (UnsafeMutablePointer<CGFloat>?, UnsafeMutablePointer<CGFloat>?, UnsafeMutablePointer<CGFloat>?, UnsafeMutablePointer<CGFloat>?) -> Void) -> (Double, Double, Double, Double) {
        var hsba: (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        handler(&hsba.0, &hsba.1, &hsba.2, &hsba.3)
        return (Double(hsba.0), saturation: Double(hsba.1), brightness: Double(hsba.2), alpha: Double(hsba.3))
    }
    static func color(from color: SourceColor) -> Color {
        let hsba = self.convert(color.getHue)
        return Color(hue: hsba.0, saturation: hsba.1, brightness: hsba.2, opacity: hsba.3)
    }
}
@available(OSX 10.15, iOS 13.0, *)
public extension ViewConverter where Source: SourceColor {
    var color: Color {
        return Color.color(from: self.source)
    }
}
