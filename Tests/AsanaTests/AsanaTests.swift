#if os(iOS)

    @testable import Asana
    import SwiftYoga
    import XCTest

    extension NSAttributedString: SizeProvider {
        public func calculateSize(bounds: CGSize) -> CGSize {
            self.boundingRect(with: bounds, options: .usesLineFragmentOrigin, context: nil).size
        }
    }

    private enum Layouts {
        static func l1(text: String) -> LayoutNode {
            let string = NSAttributedString(string: text, attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.black,
            ])

            return LayoutNode(sizeProvider: string, view: { (label: UILabel, _) in
                label.numberOfLines = 0
                label.attributedText = string
            })
        }

        static func l2() -> LayoutNode {
            let node1 = LayoutNode {
                $0.width = 100
                $0.height = 100
            } view: { (_: UIView, _) in }

            let node2 = LayoutNode {
                $0.width = 110
                $0.height = 110
                $0.marginLeft = 10
            } view: { (_: UIView, _) in }

            let node3 = LayoutNode(children: [node1, node2]) {
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
            LayoutNode(sizeProvider: string, view: { (label: UILabel, _) in
                label.numberOfLines = 0
                label.attributedText = string
            })
        }

        static func l4(
            newAction: @escaping () -> Void,
            oldAction: @escaping () -> Void
        ) -> LayoutNode {
            LayoutNode {
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
    }

    final class AsanaTests: XCTestCase {
        func testConfigView() {
            let view = UIView()

            let ls1 = LayoutCalculator.makeLayout(
                node: Layouts.l1(text: "abc"),
                bounds: CGSize(width: 100, height: CGFloat.nan)
            )

            let ls2 = LayoutCalculator.makeLayout(
                node: Layouts.l1(text: "xyz"),
                bounds: CGSize(width: 100, height: CGFloat.nan)
            )

            ls1.setup(view: view)

            let lbl1 = view.subviews.first as! UILabel

            XCTAssert(lbl1.attributedText?.string == "abc")

            ls2.setup(view: view)

            let lbl2 = view.subviews.first as! UILabel

            XCTAssert(lbl1 === lbl2)

            XCTAssert(lbl2.attributedText?.string == "xyz")
        }

        func testFramesAndOrigins() {
            let view = UIView()

            LayoutCalculator.makeLayout(
                node: Layouts.l2(),
                bounds: .init(width: CGFloat.nan, height: .nan)
            ).setup(view: view)

            XCTAssert(view.frame.size == CGSize(width: 240, height: 130))
            XCTAssert(view.subviews[0].frame == CGRect(x: 10, y: 15, width: 100, height: 100))
            XCTAssert(view.subviews[1].frame == CGRect(x: 120, y: 10, width: 110, height: 110))
        }

        func testNilText() {
            do {
                let view = UIView()

                LayoutCalculator.makeLayout(
                    node: Layouts.l3(string: nil),
                    bounds: CGSize(width: .nan, height: CGFloat.nan)
                ).setup(view: view)

                let firstChild = view.subviews[0]

                XCTAssert(firstChild.frame.width == 0 && firstChild.frame.height == 0)
            }

            do {
                let view = UIView()

                LayoutCalculator.makeLayout(
                    node: Layouts.l3(string: NSAttributedString(string: "qwe", attributes: [
                        .font: UIFont.boldSystemFont(ofSize: 40),
                    ])),
                    bounds: CGSize(width: .nan, height: CGFloat.nan)
                ).setup(view: view)

                let firstChild = view.subviews[0]

                XCTAssert(firstChild.frame.width > 0 && firstChild.frame.height > 0)
            }
        }

        func testReuseView() {
            let view = UIView()

            var newCount = 0
            var reuseCount = 0

            let layout = LayoutCalculator.makeLayout(
                node: Layouts.l4(newAction: { newCount += 1 }, oldAction: { reuseCount += 1 }),
                bounds: CGSize(width: .nan, height: CGFloat.nan)
            )

            layout.setup(view: view)
            layout.setup(view: view)

            XCTAssert(newCount == 1)
            XCTAssert(reuseCount == 1)
        }
    }

#endif
