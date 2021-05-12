import CYoga
import SwiftYoga
import UIKit

private extension Yoga.Config {
    static let `default` = Yoga.Config(pointScale: UIScreen.main.scale)
}

public final class LayoutNode {
    let children: [LayoutNode]
    let viewFactory: ViewFactory?
    let yoga: Yoga.Node

    public init<ViewType: UIView>(
        children: () -> [LayoutNode?],
        layout: ((Yoga.Node) -> Void)? = nil,
        view: ((ViewType, Bool) -> Void)? = nil
    ) {
        self.children = children().compactMap { $0 }
        self.viewFactory = view.flatMap { GenericViewFactory(closure: $0) }
        self.yoga = .init(config: .default)

        layout?(self.yoga)

        self.children.forEach {
            self.yoga.add(child: $0.yoga)
        }
    }

    public init<ViewType: UIView>(
        sizeProvider: @escaping (CGSize) -> CGSize,
        layout: ((Yoga.Node) -> Void)? = nil,
        view: ((ViewType, Bool) -> Void)? = nil
    ) {
        self.children = []
        self.viewFactory = view.flatMap { GenericViewFactory(closure: $0) }
        self.yoga = .init(config: .default, measureFunc: { (width, height) -> YGSize in
            let size = sizeProvider(.init(width: CGFloat(width), height: CGFloat(height)))
            return .init(width: Float(size.width), height: Float(size.height))
        })

        layout?(self.yoga)
    }

    public func makeLayout(bounds: CGSize, rightToLeft: Bool = false) -> Layout {
        self.markAsDirty()

        self.yoga.calculateLayout(
            width: Float(bounds.width),
            height: Float(bounds.height),
            parentDirection: rightToLeft ? .RTL : .LTR
        )

        let rootLayout = Layout(
            frame: .init(origin: .zero, size: self.yoga.frame.size),
            viewFactory: self.viewFactory ?? GenericViewFactory(closure: { _, _ in })
        )

        self.children.forEach {
            $0.traverse(parentLayout: rootLayout, offset: .zero)
        }

        return rootLayout
    }

    private func markAsDirty() {
        self.yoga.markAsDirty()

        self.children.forEach {
            $0.markAsDirty()
        }
    }

    private func traverse(parentLayout: Layout, offset: CGPoint) {
        let frame = self.yoga.frame.offsetBy(dx: offset.x, dy: offset.y)

        if let viewFactory = self.viewFactory {
            let layout = Layout(frame: frame, viewFactory: viewFactory)

            parentLayout.children.append(layout)

            self.children.forEach {
                $0.traverse(parentLayout: layout, offset: .zero)
            }
        } else {
            self.children.forEach {
                $0.traverse(parentLayout: parentLayout, offset: frame.origin)
            }
        }
    }
}
