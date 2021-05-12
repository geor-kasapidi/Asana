import UIKit

public protocol ViewFactory: AnyObject {
    func makeView(frame: CGRect) -> UIView

    func setup(view: UIView, isNew: Bool)
}

final class GenericViewFactory<T: UIView>: ViewFactory {
    private let closure: (T, Bool) -> Void

    init(closure: @escaping (T, Bool) -> Void) {
        self.closure = closure
    }

    func makeView(frame: CGRect) -> UIView {
        T(frame: frame)
    }

    func setup(view: UIView, isNew: Bool) {
        (view as? T).flatMap {
            self.closure($0, isNew)
        }
    }
}
