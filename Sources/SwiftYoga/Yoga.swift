import CoreGraphics
import CYoga
import Foundation

// https://yogalayout.com/docs

public enum Yoga {
    public typealias MeasureFunc = (Float, Float) -> YGSize

    public final class Config {
        fileprivate private(set) var ref: YGConfigRef!

        public init(pointScale: CGFloat) {
            self.ref = YGConfigNew()

            YGConfigSetPointScaleFactor(self.ref, Float(pointScale))
        }

        deinit {
            YGConfigFree(self.ref)
        }
    }

    public final class Node {
        public let measureFunc: MeasureFunc?

        fileprivate private(set) var ref: YGNodeRef!

        public init(config: Config, measureFunc: MeasureFunc? = nil) {
            self.measureFunc = measureFunc

            self.ref = YGNodeNewWithConfig(config.ref)

            if self.measureFunc != nil {
                YGNodeSetContext(self.ref, Unmanaged.passUnretained(self).toOpaque())

                YGNodeSetMeasureFunc(self.ref) { (ref, width, _, height, _) -> YGSize in
                    Unmanaged<Node>
                        .fromOpaque(YGNodeGetContext(ref))
                        .takeUnretainedValue()
                        .measureFunc.unsafelyUnwrapped(width, height)
                }
            }
        }

        deinit {
            YGNodeFree(self.ref)
        }

        // MARK: -

        public func calculateLayout(width: Float, height: Float, parentDirection: YGDirection) {
            YGNodeCalculateLayout(self.ref, width, height, parentDirection)
        }

        // MARK: -

        public private(set) var children: [Node] = []

        @discardableResult
        public func add(child: Node) -> Self {
            self.children.append(child)

            YGNodeInsertChild(self.ref, child.ref, YGNodeGetChildCount(self.ref))

            return self
        }

        public func markAsDirty() {
            guard self.measureFunc != nil else {
                return
            }

            YGNodeMarkDirty(self.ref)
        }

        // MARK: -

        public var frame: CGRect {
            CGRect(
                x: CGFloat(YGNodeLayoutGetLeft(self.ref)),
                y: CGFloat(YGNodeLayoutGetTop(self.ref)),
                width: CGFloat(YGNodeLayoutGetWidth(self.ref)),
                height: CGFloat(YGNodeLayoutGetHeight(self.ref))
            )
        }

        public var flexDirection: YGFlexDirection {
            get { YGNodeStyleGetFlexDirection(self.ref) }
            set { YGNodeStyleSetFlexDirection(self.ref, newValue) }
        }

        public var flex: Float {
            get { YGNodeStyleGetFlex(self.ref) }
            set { YGNodeStyleSetFlex(self.ref, newValue) }
        }

        public var flexWrap: YGWrap {
            get { YGNodeStyleGetFlexWrap(self.ref) }
            set { YGNodeStyleSetFlexWrap(self.ref, newValue) }
        }

        public var flexGrow: Float {
            get { YGNodeStyleGetFlexGrow(self.ref) }
            set { YGNodeStyleSetFlexGrow(self.ref, newValue) }
        }

        public var flexShrink: Float {
            get { YGNodeStyleGetFlexShrink(self.ref) }
            set { YGNodeStyleSetFlexShrink(self.ref, newValue) }
        }

        public var flexBasis: YGValue {
            get { YGNodeStyleGetFlexBasis(self.ref) }
            set { Yoga.set(self.ref, newValue, YGNodeStyleSetFlexBasis, YGNodeStyleSetFlexBasisPercent) }
        }

        public var display: YGDisplay {
            get { YGNodeStyleGetDisplay(self.ref) }
            set { YGNodeStyleSetDisplay(self.ref, newValue) }
        }

        public var aspectRatio: Float {
            get { YGNodeStyleGetAspectRatio(self.ref) }
            set { YGNodeStyleSetAspectRatio(self.ref, newValue) }
        }

        public var justifyContent: YGJustify {
            get { YGNodeStyleGetJustifyContent(self.ref) }
            set { YGNodeStyleSetJustifyContent(self.ref, newValue) }
        }

        public var alignContent: YGAlign {
            get { YGNodeStyleGetAlignContent(self.ref) }
            set { YGNodeStyleSetAlignContent(self.ref, newValue) }
        }

        public var alignItems: YGAlign {
            get { YGNodeStyleGetAlignItems(self.ref) }
            set { YGNodeStyleSetAlignItems(self.ref, newValue) }
        }

        public var alignSelf: YGAlign {
            get { YGNodeStyleGetAlignSelf(self.ref) }
            set { YGNodeStyleSetAlignSelf(self.ref, newValue) }
        }

        public var positionType: YGPositionType {
            get { YGNodeStyleGetPositionType(self.ref) }
            set { YGNodeStyleSetPositionType(self.ref, newValue) }
        }

        public var overflow: YGOverflow {
            get { YGNodeStyleGetOverflow(self.ref) }
            set { YGNodeStyleSetOverflow(self.ref, newValue) }
        }

        public var width: YGValue {
            get { YGNodeStyleGetWidth(self.ref) }
            set { Yoga.set(self.ref, newValue, YGNodeStyleSetWidth, YGNodeStyleSetWidthPercent) }
        }

        public var height: YGValue {
            get { YGNodeStyleGetHeight(self.ref) }
            set { Yoga.set(self.ref, newValue, YGNodeStyleSetHeight, YGNodeStyleSetHeightPercent) }
        }

        public var minWidth: YGValue {
            get { YGNodeStyleGetMinWidth(self.ref) }
            set { Yoga.set(self.ref, newValue, YGNodeStyleSetMinWidth, YGNodeStyleSetMinWidthPercent) }
        }

        public var minHeight: YGValue {
            get { YGNodeStyleGetMinHeight(self.ref) }
            set { Yoga.set(self.ref, newValue, YGNodeStyleSetMinHeight, YGNodeStyleSetMinHeightPercent) }
        }

        public var maxWidth: YGValue {
            get { YGNodeStyleGetMaxWidth(self.ref) }
            set { Yoga.set(self.ref, newValue, YGNodeStyleSetMaxWidth, YGNodeStyleSetMaxWidthPercent) }
        }

        public var maxHeight: YGValue {
            get { YGNodeStyleGetMaxHeight(self.ref) }
            set { Yoga.set(self.ref, newValue, YGNodeStyleSetMaxHeight, YGNodeStyleSetMaxHeightPercent) }
        }

        public var top: YGValue {
            get { YGNodeStyleGetPosition(self.ref, .top) }
            set { Yoga.set(self.ref, newValue, .top, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
        }

        public var right: YGValue {
            get { YGNodeStyleGetPosition(self.ref, .right) }
            set { Yoga.set(self.ref, newValue, .right, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
        }

        public var bottom: YGValue {
            get { YGNodeStyleGetPosition(self.ref, .bottom) }
            set { Yoga.set(self.ref, newValue, .bottom, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
        }

        public var left: YGValue {
            get { YGNodeStyleGetPosition(self.ref, .left) }
            set { Yoga.set(self.ref, newValue, .left, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
        }

        public var marginTop: YGValue {
            get { YGNodeStyleGetMargin(self.ref, .top) }
            set { Yoga.set(self.ref, newValue, .top, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
        }

        public var marginRight: YGValue {
            get { YGNodeStyleGetMargin(self.ref, .right) }
            set { Yoga.set(self.ref, newValue, .right, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
        }

        public var marginBottom: YGValue {
            get { YGNodeStyleGetMargin(self.ref, .bottom) }
            set { Yoga.set(self.ref, newValue, .bottom, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
        }

        public var marginLeft: YGValue {
            get { YGNodeStyleGetMargin(self.ref, .left) }
            set { Yoga.set(self.ref, newValue, .left, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
        }

        public var paddingTop: YGValue {
            get { YGNodeStyleGetPadding(self.ref, .top) }
            set { Yoga.set(self.ref, newValue, .top, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
        }

        public var paddingRight: YGValue {
            get { YGNodeStyleGetPadding(self.ref, .right) }
            set { Yoga.set(self.ref, newValue, .right, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
        }

        public var paddingBottom: YGValue {
            get { YGNodeStyleGetPadding(self.ref, .bottom) }
            set { Yoga.set(self.ref, newValue, .bottom, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
        }

        public var paddingLeft: YGValue {
            get { YGNodeStyleGetPadding(self.ref, .left) }
            set { Yoga.set(self.ref, newValue, .left, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
        }
    }

    private static func set(
        _ ref: YGNodeRef,
        _ value: YGValue,
        _ pointSetter: (YGNodeRef?, Float) -> Void,
        _ percentSetter: (YGNodeRef?, Float) -> Void
    ) {
        switch value.unit {
        case .point:
            pointSetter(ref, value.value)
        case .percent:
            percentSetter(ref, value.value)
        default:
            assertionFailure()
        }
    }

    private static func set(
        _ ref: YGNodeRef,
        _ value: YGValue,
        _ edge: YGEdge,
        _ pointSetter: (YGNodeRef?, YGEdge, Float) -> Void,
        _ percentSetter: (YGNodeRef?, YGEdge, Float) -> Void
    ) {
        switch value.unit {
        case .point:
            pointSetter(ref, edge, value.value)
        case .percent:
            percentSetter(ref, edge, value.value)
        default:
            assertionFailure()
        }
    }
}
