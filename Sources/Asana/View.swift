import CoreGraphics

protocol ViewFactory {
    func makeView() -> OSView

    func setup(view: OSView, isNew: Bool)
}

final class TemplateViewFactory<T: OSView>: ViewFactory {
    private let closure: (T, Bool) -> Void

    init(closure: @escaping (T, Bool) -> Void) {
        self.closure = closure
    }

    func makeView() -> OSView {
        T(frame: .zero)
    }

    func setup(view: OSView, isNew: Bool) {
        self.closure(view as! T, isNew)
    }
}

final class ViewData {
    let frame: CGRect
    let factory: ViewFactory

    init(frame: CGRect, factory: ViewFactory) {
        self.frame = frame
        self.factory = factory
    }
}
