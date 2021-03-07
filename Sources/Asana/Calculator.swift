import CoreGraphics

public enum LayoutCalculator {
    public static func makeLayout(
        node: LayoutNode,
        bounds: CGSize,
        rtl: Bool = false
    ) -> Layout {
        node.yogaNode.calculateLayout(
            width: Float(bounds.width),
            height: Float(bounds.height),
            parentDirection: rtl ? .RTL : .LTR
        )

        let frame = node.yogaNode.frame

        var views: [ViewData] = []

        self.traverse(node: node, offset: frame.origin, views: &views)

        let layout = Layout(size: frame.size, views: views)

        return layout
    }

    private static func traverse(node: LayoutNode, offset: CGPoint, views: inout [ViewData]) {
        let frame = node.yogaNode.frame.offsetBy(dx: offset.x, dy: offset.y)

        node.viewFactory.flatMap {
            views.append(ViewData(
                frame: frame,
                factory: $0
            ))
        }

        node.children.forEach {
            self.traverse(node: $0, offset: frame.origin, views: &views)
        }
    }
}
