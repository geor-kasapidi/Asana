import CYoga
import SwiftYoga
import XCTest

final class YogaTests: XCTestCase {
    func testStability() {
        let yoga = Yoga.Node(config: .init(pointScale: 1))

        yoga.flexDirection = .column
        XCTAssert(yoga.flexDirection == .column)

        yoga.flex = 1
        XCTAssert(yoga.flex == 1)

        yoga.flexWrap = .wrap
        XCTAssert(yoga.flexWrap == .wrap)

        yoga.flexGrow = 1
        XCTAssert(yoga.flexGrow == 1)

        yoga.flexShrink = 1
        XCTAssert(yoga.flexShrink == 1)

        yoga.flexBasis = 100%
        XCTAssert(yoga.flexBasis == 100%)

        yoga.display = .none
        XCTAssert(yoga.display == .none)

        yoga.aspectRatio = Float(4.0 / 3.0)
        XCTAssert(yoga.aspectRatio == Float(4.0 / 3.0))

        yoga.justifyContent = .center
        XCTAssert(yoga.justifyContent == .center)

        yoga.alignContent = .center
        XCTAssert(yoga.alignContent == .center)

        yoga.alignItems = .center
        XCTAssert(yoga.alignItems == .center)

        yoga.alignSelf = .stretch
        XCTAssert(yoga.alignSelf == .stretch)

        yoga.positionType = .absolute
        XCTAssert(yoga.positionType == .absolute)

        yoga.width = 100%
        XCTAssert(yoga.width == 100%)

        yoga.height = 100%
        XCTAssert(yoga.height == 100%)

        yoga.minWidth = 10
        XCTAssert(yoga.minWidth == 10)

        yoga.minHeight = 10
        XCTAssert(yoga.minHeight == 10)

        yoga.maxWidth = 10
        XCTAssert(yoga.maxWidth == 10)

        yoga.maxHeight = 10
        XCTAssert(yoga.maxHeight == 10)

        yoga.top = 10
        XCTAssert(yoga.top == 10)

        yoga.right = 10
        XCTAssert(yoga.right == 10)

        yoga.bottom = 10
        XCTAssert(yoga.bottom == 10)

        yoga.left = 10
        XCTAssert(yoga.left == 10)

        yoga.paddingTop = 10
        yoga.paddingLeft = 10
        yoga.paddingRight = 10
        yoga.paddingBottom = 10

        XCTAssert(yoga.paddingTop == 10)
        XCTAssert(yoga.paddingLeft == 10)
        XCTAssert(yoga.paddingRight == 10)
        XCTAssert(yoga.paddingBottom == 10)

        yoga.marginTop = 10
        yoga.marginLeft = 10
        yoga.marginRight = 10
        yoga.marginBottom = 10

        XCTAssert(yoga.marginTop == 10)
        XCTAssert(yoga.marginLeft == 10)
        XCTAssert(yoga.marginRight == 10)
        XCTAssert(yoga.marginBottom == 10)
    }

    func testCalculateLayout() {
        let config = Yoga.Config(pointScale: 1)

        let node1 = Yoga.Node(config: config)
        node1.alignItems = .center
        node1.justifyContent = .center
        node1.flexDirection = .row

        let node2 = Yoga.Node(config: config)
        node2.positionType = .absolute
        node2.top = 10
        node2.left = 10
        node2.right = 10
        node2.bottom = 10

        node1.add(child: node2)

        node1.calculateLayout(width: 100, height: 100, parentDirection: .LTR)

        XCTAssert(node2.frame == CGRect(x: 10, y: 10, width: 80, height: 80))
    }

    func testNodeWithCustomMeasureFunc() {
        let config = Yoga.Config(pointScale: 1)

        let node1 = Yoga.Node(config: config)

        let node2 = Yoga.Node(config: config) { _, _ in
            .init(width: 56, height: 56)
        }
        node2.flexGrow = 0
        node2.flexShrink = 1

        node1.add(child: node2)

        node1.calculateLayout(width: .nan, height: .nan, parentDirection: .LTR)

        XCTAssert(node2.frame.width == 56)
        XCTAssert(node2.frame.height == 56)
    }

    func testStringAttributes() {
        let attributes: [String: String] = [
            "flexDirection": "column",
            "flex": "10",
            "flexWrap": "wrap",
            "flexGrow": "10",
            "flexShrink": "10",
            "flexBasis": "70%",
            "aspectRatio": "1.3",
            "justifyContent": "center",
            "alignContent": "center",
            "alignItems": "center",
            "alignSelf": "center",
            "positionType": "absolute",
            "width": "50%",
            "height": "50",
            "minWidth": "50%",
            "minHeight": "50",
            "maxWidth": "50%",
            "maxHeight": "50",
            "top": "10%",
            "right": "10",
            "bottom": "10%",
            "left": "10",
            "marginTop": "10%",
            "marginRight": "10",
            "marginBottom": "10%",
            "marginLeft": "10",
            "paddingTop": "10%",
            "paddingRight": "10",
            "paddingBottom": "10%",
            "paddingLeft": "10",
        ]

        let node = Yoga.Node(config: .init(pointScale: 1))

        node.setup(attributes: attributes)

        XCTAssert(node.flexDirection == .column)
        XCTAssert(node.flex == 10)
        XCTAssert(node.flexWrap == .wrap)
        XCTAssert(node.flexGrow == 10)
        XCTAssert(node.flexShrink == 10)
        XCTAssert(node.flexBasis == 70%)
        XCTAssert(node.aspectRatio == 1.3)
        XCTAssert(node.justifyContent == .center)
        XCTAssert(node.alignContent == .center)
        XCTAssert(node.alignItems == .center)
        XCTAssert(node.alignSelf == .center)
        XCTAssert(node.positionType == .absolute)
        XCTAssert(node.width == 50%)
        XCTAssert(node.height == 50)
        XCTAssert(node.minWidth == 50%)
        XCTAssert(node.minHeight == 50)
        XCTAssert(node.maxWidth == 50%)
        XCTAssert(node.maxHeight == 50)
        XCTAssert(node.top == 10%)
        XCTAssert(node.right == 10)
        XCTAssert(node.bottom == 10%)
        XCTAssert(node.left == 10)
        XCTAssert(node.marginTop == 10%)
        XCTAssert(node.marginRight == 10)
        XCTAssert(node.marginBottom == 10%)
        XCTAssert(node.marginLeft == 10)
        XCTAssert(node.paddingTop == 10%)
        XCTAssert(node.paddingRight == 10)
        XCTAssert(node.paddingBottom == 10%)
        XCTAssert(node.paddingLeft == 10)
    }
}
