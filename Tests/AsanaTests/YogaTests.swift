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

        yoga.overflow = .scroll
        XCTAssert(yoga.overflow == .scroll)

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
}
