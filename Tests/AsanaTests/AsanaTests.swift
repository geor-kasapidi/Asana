@testable import Asana
import SwiftYoga
import XCTest

private enum Layouts {
    static func l1(text: String) -> LayoutNode {
        let string = NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.black,
        ])

        return LayoutNode(sizeProvider: {
            string.boundingRect(with: $0, options: .usesLineFragmentOrigin, context: nil).size
        }, view: { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = string
        })
    }

    static func l2() -> LayoutNode {
        let node1 = LayoutNode {
            []
        } layout: {
            $0.width = 100
            $0.height = 100
        } view: { (_: UIView, _) in }

        let node2 = LayoutNode {
            []
        } layout: {
            $0.width = 110
            $0.height = 110
            $0.marginLeft = 10
        } view: { (_: UIView, _) in }

        let node3 = LayoutNode {
            [node1, node2]
        } layout: {
            $0.paddingTop = 10
            $0.paddingLeft = 10
            $0.paddingRight = 10
            $0.paddingBottom = 10
            $0.flexDirection = .row
            $0.alignItems = .center
        }

        return node3
    }

    static func l3(string: NSAttributedString?) -> LayoutNode {
        LayoutNode(sizeProvider: {
            string?.boundingRect(with: $0, options: .usesLineFragmentOrigin, context: nil).size ?? .zero
        }, view: { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = string
        })
    }

    static func l4(
        newAction: @escaping () -> Void,
        oldAction: @escaping () -> Void
    ) -> LayoutNode {
        LayoutNode {
            []
        } layout: {
            $0.width = 40
            $0.height = 40
        } view: { (_: UIView, isNew) in
            if isNew {
                newAction()
            } else {
                oldAction()
            }
        }
    }

    static func l5() -> LayoutNode {
        LayoutNode {
            [
                LayoutNode {
                    [
                        LayoutNode {
                            [
                                LayoutNode {
                                    []
                                } layout: {
                                    $0.width = 100
                                    $0.height = 100
                                } view: { view, _ in
                                    view.backgroundColor = .red
                                },
                            ]
                        } layout: {
                            $0.padding(uniform: 100)
                        },
                    ]
                } layout: {
                    $0.padding(uniform: 100)
                },
            ]
        }
    }

    static func l6() -> LayoutNode {
        self.makeTestTree(depth: 0)
    }

    private static func makeTestTree(depth: Int) -> LayoutNode {
        if depth < 5 {
            return LayoutNode {
                (0 ..< 10).map { _ in
                    self.makeTestTree(depth: depth + 1)
                }
            } layout: {
                $0.padding(uniform: .init(value: Float(Int.random(in: 10 ... 20)), unit: .point))
            }
        } else {
            return LayoutNode {
                []
            } layout: {
                $0.width = .init(value: Float(Int.random(in: 100 ... 200)), unit: .point)
                $0.height = .init(value: Float(Int.random(in: 100 ... 200)), unit: .point)
            } view: { _, _ in }
        }
    }
}

final class AsanaTests: XCTestCase {
    func testConfigView() {
        let ls1 = Layouts.l1(text: "abc").makeLayout(bounds: CGSize(width: 100, height: CGFloat.nan))
        let ls2 = Layouts.l1(text: "xyz").makeLayout(bounds: CGSize(width: 100, height: CGFloat.nan))

        let view = ls1.makeView()

        let lbl1 = view as! UILabel

        XCTAssert(lbl1.attributedText?.string == "abc")

        ls2.setup(view: view)

        let lbl2 = view as! UILabel

        XCTAssert(lbl1 === lbl2)

        XCTAssert(lbl2.attributedText?.string == "xyz")
    }

    func testFramesAndOrigins() {
        let view = Layouts.l2().makeLayout(bounds: .init(width: CGFloat.nan, height: .nan)).makeView()

        XCTAssert(view.frame.size == CGSize(width: 240, height: 130))
        XCTAssert(view.subviews[0].frame == CGRect(x: 10, y: 15, width: 100, height: 100))
        XCTAssert(view.subviews[1].frame == CGRect(x: 120, y: 10, width: 110, height: 110))
    }

    func testNilText() {
        do {
            let view = Layouts.l3(string: nil).makeLayout(bounds: CGSize(width: .nan, height: CGFloat.nan)).makeView()

            XCTAssert(view.frame.width == 0 && view.frame.height == 0)
        }

        do {
            let view = Layouts.l3(string: NSAttributedString(string: "qwe", attributes: [
                .font: UIFont.boldSystemFont(ofSize: 40),
            ])).makeLayout(bounds: CGSize(width: .nan, height: CGFloat.nan)).makeView()

            XCTAssert(view.frame.width > 0 && view.frame.height > 0)
        }
    }

    func testReuseView() {
        var newCount = 0
        var reuseCount = 0

        let layout = Layouts.l4(newAction: { newCount += 1 }, oldAction: { reuseCount += 1 }).makeLayout(bounds: CGSize(width: .nan, height: CGFloat.nan))

        let view = layout.makeView()

        layout.setup(view: view)

        XCTAssert(newCount == 1)
        XCTAssert(reuseCount == 1)
    }

    func testNoViewsForLayouts() {
        let view = Layouts.l5().makeLayout(bounds: .init(width: CGFloat.nan, height: .nan)).makeView()

        XCTAssert(view.subviews.count == 1)

        XCTAssert(view.subviews[0].frame == .init(x: 200, y: 200, width: 100, height: 100))
    }

    func _testSpeed() {
        let node = Layouts.l6()

        self.measure {
            _ = node.makeLayout(bounds: .init(width: CGFloat.nan, height: .nan))
        }
    }
}
