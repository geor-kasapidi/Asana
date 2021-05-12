import CYoga

public extension YGEdge {
    static var top: YGEdge { YGEdgeTop }
    static var bottom: YGEdge { YGEdgeBottom }
    static var left: YGEdge { YGEdgeLeft }
    static var right: YGEdge { YGEdgeRight }
}

public extension YGUnit {
    static var point: YGUnit { YGUnitPoint }
    static var percent: YGUnit { YGUnitPercent }
}

public extension YGPositionType {
    static var relative: YGPositionType { YGPositionTypeRelative }
    static var absolute: YGPositionType { YGPositionTypeAbsolute }
}

public extension YGAlign {
    static var auto: YGAlign { YGAlignAuto }
    static var flexStart: YGAlign { YGAlignFlexStart }
    static var center: YGAlign { YGAlignCenter }
    static var flexEnd: YGAlign { YGAlignFlexEnd }
    static var stretch: YGAlign { YGAlignStretch }
    static var spaceBetween: YGAlign { YGAlignSpaceBetween }
    static var spaceAround: YGAlign { YGAlignSpaceAround }
}

public extension YGJustify {
    static var flexStart: YGJustify { YGJustifyFlexStart }
    static var center: YGJustify { YGJustifyCenter }
    static var flexEnd: YGJustify { YGJustifyFlexEnd }
    static var spaceBetween: YGJustify { YGJustifySpaceBetween }
    static var spaceAround: YGJustify { YGJustifySpaceAround }
    static var spaceEvenly: YGJustify { YGJustifySpaceEvenly }
}

public extension YGWrap {
    static var noWrap: YGWrap { YGWrapNoWrap }
    static var wrap: YGWrap { YGWrapWrap }
    static var wrapReverse: YGWrap { YGWrapWrapReverse }
}

public extension YGFlexDirection {
    static var row: YGFlexDirection { YGFlexDirectionRow }
    static var column: YGFlexDirection { YGFlexDirectionColumn }
    static var rowReverse: YGFlexDirection { YGFlexDirectionRowReverse }
    static var columnReverse: YGFlexDirection { YGFlexDirectionColumnReverse }
}

public extension YGDirection {
    static var LTR: YGDirection { YGDirectionLTR }
    static var RTL: YGDirection { YGDirectionRTL }
}

public extension YGDisplay {
    static var none: YGDisplay { YGDisplayNone }
    static var flex: YGDisplay { YGDisplayFlex }
}

public extension YGOverflow {
    static var hidden: YGOverflow { YGOverflowHidden }
    static var scroll: YGOverflow { YGOverflowScroll }
    static var visible: YGOverflow { YGOverflowVisible }
}

postfix operator %

public extension Int {
    static postfix func % (value: Int) -> YGValue {
        YGValue(value: Float(value), unit: .percent)
    }
}

extension YGValue: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = YGValue(value: Float(value), unit: .point)
    }
}

extension YGValue: Equatable {
    public static func == (lhs: YGValue, rhs: YGValue) -> Bool {
        lhs.value == rhs.value && lhs.unit == rhs.unit
    }
}

public extension Yoga.Node {
    func padding(uniform value: YGValue) {
        self.paddingTop = value
        self.paddingLeft = value
        self.paddingBottom = value
        self.paddingRight = value
    }

    func margin(uniform value: YGValue) {
        self.marginTop = value
        self.marginLeft = value
        self.marginBottom = value
        self.marginRight = value
    }

    func padding(top: YGValue? = nil, left: YGValue? = nil, bottom: YGValue? = nil, right: YGValue? = nil) {
        top.flatMap { self.paddingTop = $0 }
        left.flatMap { self.paddingLeft = $0 }
        bottom.flatMap { self.paddingBottom = $0 }
        right.flatMap { self.paddingRight = $0 }
    }

    func margin(top: YGValue? = nil, left: YGValue? = nil, bottom: YGValue? = nil, right: YGValue? = nil) {
        top.flatMap { self.marginTop = $0 }
        left.flatMap { self.marginLeft = $0 }
        bottom.flatMap { self.marginBottom = $0 }
        right.flatMap { self.marginRight = $0 }
    }

    func position(top: YGValue? = nil, left: YGValue? = nil, bottom: YGValue? = nil, right: YGValue? = nil) {
        top.flatMap { self.top = $0 }
        left.flatMap { self.left = $0 }
        bottom.flatMap { self.bottom = $0 }
        right.flatMap { self.right = $0 }
    }
}
