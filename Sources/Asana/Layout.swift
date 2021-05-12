import UIKit

public final class Layout {
    public let frame: CGRect
    public let viewFactory: ViewFactory

    init(frame: CGRect, viewFactory: ViewFactory) {
        self.frame = frame
        self.viewFactory = viewFactory
    }

    public internal(set) var children: [Layout] = []
}

public extension Layout {
    func makeView() -> UIView {
        let view = self.viewFactory.makeView(frame: self.frame)
        self.children.forEach {
            view.addSubview($0.makeView())
        }
        self.viewFactory.setup(view: view, isNew: true)
        return view
    }

    func setup(view: UIView, isNew: Bool = false) {
        view.frame = self.frame
        zip(view.subviews, self.children).forEach {
            $0.1.setup(view: $0.0, isNew: isNew)
        }
        self.viewFactory.setup(view: view, isNew: isNew)
    }
}
