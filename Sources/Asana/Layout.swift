import CoreGraphics

public final class Layout {
    public let size: CGSize

    private let views: [ViewData]

    init(size: CGSize, views: [ViewData]) {
        self.size = size
        self.views = views
    }

    public func setup(view: OSView) {
        view.frame.size = self.size

        if view.subviews.isEmpty {
            self.views.forEach { viewData in
                let subview = viewData.factory.makeView()

                view.addSubview(subview)

                subview.frame = viewData.frame

                viewData.factory.setup(view: subview, isNew: true)
            }
        } else {
            zip(view.subviews, self.views).forEach { subview, viewData in
                subview.frame = viewData.frame

                viewData.factory.setup(view: subview, isNew: false)
            }
        }
    }
}

public extension Layout {
    func makeView<T: OSView>() -> T {
        let view = T(frame: .zero)
        self.setup(view: view)
        return view
    }
}
