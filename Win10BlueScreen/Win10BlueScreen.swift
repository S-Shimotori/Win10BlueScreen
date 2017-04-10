import Foundation
import ScreenSaver

class Win10BlueScreen: ScreenSaverView {
    required init!(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)!
    }

    override func startAnimation() {
        super.startAnimation()
    }

    override func stopAnimation() {
        super.stopAnimation()
    }

    override func hasConfigureSheet() -> Bool {
        return false
    }

    override func configureSheet() -> NSWindow? {
        return nil
    }

    override func animateOneFrame() {
        super.needsDisplay = true
    }

    override func draw(_ rect: NSRect) {
        NSColor.lightGray.setFill()
        NSBezierPath.fill(rect)

        let word = "hoge"
        let attributes: [String: Any] = [
            NSForegroundColorAttributeName: NSColor.black
        ]
        let text = NSAttributedString(string: word, attributes: attributes)
        let point = SSRandomPointForSizeWithinRect(NSSize.zero, rect)
        text.draw(at: point)
    }
}
