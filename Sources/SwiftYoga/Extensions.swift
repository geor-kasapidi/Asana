import CYoga

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

public extension YGValue {
    init?(_ description: String) {
        if description.last == "%", let value = Int(description.dropLast(1)) {
            self = YGValue(value: Float(value), unit: .percent)
        } else if let value = Int(description) {
            self = YGValue(value: Float(value), unit: .point)
        } else {
            return nil
        }
    }
}

public extension YGFlexDirection {
    init?(_ description: String) {
        switch description {
        case "row": self = .row
        case "column": self = .column
        case "rowReverse": self = .rowReverse
        case "columnReverse": self = .columnReverse
        default: return nil
        }
    }
}

public extension YGWrap {
    init?(_ description: String) {
        switch description {
        case "noWrap": self = .noWrap
        case "wrap": self = .wrap
        case "wrapReverse": self = .wrapReverse
        default: return nil
        }
    }
}

public extension YGJustify {
    init?(_ description: String) {
        switch description {
        case "flexStart": self = .flexStart
        case "center": self = .center
        case "flexEnd": self = .flexEnd
        case "spaceBetween": self = .spaceBetween
        case "spaceAround": self = .spaceAround
        case "spaceEvenly": self = .spaceEvenly
        default: return nil
        }
    }
}

public extension YGAlign {
    init?(_ description: String) {
        switch description {
        case "flexStart": self = .flexStart
        case "center": self = .center
        case "flexEnd": self = .flexEnd
        case "stretch": self = .stretch
        case "baseline": self = .baseline
        case "spaceBetween": self = .spaceBetween
        case "spaceAround": self = .spaceAround
        default: return nil
        }
    }
}

public extension YGPositionType {
    init?(_ description: String) {
        switch description {
        case "relative": self = .relative
        case "absolute": self = .absolute
        default: return nil
        }
    }
}

public extension Yoga.Node {
    func setup(attributes: [String: String]) {
        attributes["flexDirection"].flatMap { YGFlexDirection($0).flatMap { self.flexDirection = $0 } }
        attributes["flex"].flatMap { Float($0).flatMap { self.flex = $0 } }
        attributes["flexWrap"].flatMap { YGWrap($0).flatMap { self.flexWrap = $0 } }
        attributes["flexGrow"].flatMap { Float($0).flatMap { self.flexGrow = $0 } }
        attributes["flexShrink"].flatMap { Float($0).flatMap { self.flexShrink = $0 } }
        attributes["flexBasis"].flatMap { YGValue($0).flatMap { self.flexBasis = $0 } }
        attributes["aspectRatio"].flatMap { Float($0).flatMap { self.aspectRatio = $0 } }
        attributes["justifyContent"].flatMap { YGJustify($0).flatMap { self.justifyContent = $0 } }
        attributes["alignContent"].flatMap { YGAlign($0).flatMap { self.alignContent = $0 } }
        attributes["alignItems"].flatMap { YGAlign($0).flatMap { self.alignItems = $0 } }
        attributes["alignSelf"].flatMap { YGAlign($0).flatMap { self.alignSelf = $0 } }
        attributes["positionType"].flatMap { YGPositionType($0).flatMap { self.positionType = $0 } }
        attributes["width"].flatMap { YGValue($0).flatMap { self.width = $0 } }
        attributes["height"].flatMap { YGValue($0).flatMap { self.height = $0 } }
        attributes["minWidth"].flatMap { YGValue($0).flatMap { self.minWidth = $0 } }
        attributes["minHeight"].flatMap { YGValue($0).flatMap { self.minHeight = $0 } }
        attributes["maxWidth"].flatMap { YGValue($0).flatMap { self.maxWidth = $0 } }
        attributes["maxHeight"].flatMap { YGValue($0).flatMap { self.maxHeight = $0 } }
        attributes["top"].flatMap { YGValue($0).flatMap { self.top = $0 } }
        attributes["right"].flatMap { YGValue($0).flatMap { self.right = $0 } }
        attributes["bottom"].flatMap { YGValue($0).flatMap { self.bottom = $0 } }
        attributes["left"].flatMap { YGValue($0).flatMap { self.left = $0 } }
        attributes["marginTop"].flatMap { YGValue($0).flatMap { self.marginTop = $0 } }
        attributes["marginRight"].flatMap { YGValue($0).flatMap { self.marginRight = $0 } }
        attributes["marginBottom"].flatMap { YGValue($0).flatMap { self.marginBottom = $0 } }
        attributes["marginLeft"].flatMap { YGValue($0).flatMap { self.marginLeft = $0 } }
        attributes["paddingTop"].flatMap { YGValue($0).flatMap { self.paddingTop = $0 } }
        attributes["paddingRight"].flatMap { YGValue($0).flatMap { self.paddingRight = $0 } }
        attributes["paddingBottom"].flatMap { YGValue($0).flatMap { self.paddingBottom = $0 } }
        attributes["paddingLeft"].flatMap { YGValue($0).flatMap { self.paddingLeft = $0 } }
    }
}
