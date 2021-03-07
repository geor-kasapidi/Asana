import SwiftYoga

#if os(iOS)
    import UIKit

    public typealias OSView = UIView

    extension Yoga.Config {
        static let `default` = Yoga.Config(pointScale: UIScreen.main.scale)
    }

#elseif os(macOS)
    import AppKit

    public typealias OSView = NSView

    extension Yoga.Config {
        static let `default` = Yoga.Config(pointScale: 1)
    }
#endif
