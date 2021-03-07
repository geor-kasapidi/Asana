import CoreGraphics

public protocol SizeProvider {
    func calculateSize(bounds: CGSize) -> CGSize
}

extension Optional: SizeProvider where Wrapped: SizeProvider {
    public func calculateSize(bounds: CGSize) -> CGSize {
        switch self {
        case .none:
            return .zero
        case let .some(provider):
            return provider.calculateSize(bounds: bounds)
        }
    }
}
