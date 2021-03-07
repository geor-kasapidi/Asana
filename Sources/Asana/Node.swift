import CoreGraphics
import CYoga
import SwiftYoga

public final class LayoutNode {
    let children: [LayoutNode]
    let viewFactory: ViewFactory?
    let yogaNode: Yoga.Node

    public init<ViewType: OSView>(
        children: [LayoutNode?] = [],
        layout: ((Yoga.Node) -> Void)? = nil,
        view: ((ViewType, Bool) -> Void)? = nil
    ) {
        self.children = children.compactMap { $0 }
        self.viewFactory = view.flatMap { TemplateViewFactory(closure: $0) }
        self.yogaNode = .init(config: .default)

        layout?(self.yogaNode)

        self.children.forEach { self.yogaNode.add(child: $0.yogaNode) }
    }

    public init<ViewType: OSView>(
        sizeProvider: SizeProvider,
        layout: ((Yoga.Node) -> Void)? = nil,
        view: ((ViewType, Bool) -> Void)? = nil
    ) {
        self.children = []
        self.viewFactory = view.flatMap { TemplateViewFactory(closure: $0) }
        self.yogaNode = .init(config: .default, measureFunc: { (width, height) -> YGSize in
            let size = sizeProvider.calculateSize(
                bounds: .init(width: CGFloat(width), height: CGFloat(height))
            )
            return .init(width: Float(size.width), height: Float(size.height))
        })

        layout?(self.yogaNode)
    }
}
