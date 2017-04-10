import Cocoa
import ScreenSaver
import CoreImage

class Win10BlueScreen: ScreenSaverView {
    private static let backgroundColor = CIColor(red: 41.0 / 255, green: 86.0 / 255, blue: 178.0 / 255)
    private static let fontColor = CIColor(red: 1, green: 1, blue: 1)
    private let fontName = "YuGothic"
    private static let qrCodeSize: CGFloat = 170
    private static let qrCodeMessage = "http://karaage.ne.jp/"
    private var count = 0
    private let countMax: Int

    private let qrCodeImage: NSImage

    required init!(coder: NSCoder) {
        self.qrCodeImage = Win10BlueScreen.qrCodeMake(
            message: Win10BlueScreen.qrCodeMessage,
            size: Win10BlueScreen.qrCodeSize,
            backgroundColor: Win10BlueScreen.backgroundColor,
            fontColor: Win10BlueScreen.fontColor
        )
        self.countMax = 66 + Int(arc4random_uniform(34))
        super.init(coder: coder)
    }

    override init(frame: NSRect, isPreview: Bool) {
        self.qrCodeImage = Win10BlueScreen.qrCodeMake(
            message: Win10BlueScreen.qrCodeMessage,
            size: Win10BlueScreen.qrCodeSize,
            backgroundColor: Win10BlueScreen.backgroundColor,
            fontColor: Win10BlueScreen.fontColor
        )
        self.countMax = 66 + Int(arc4random_uniform(34))
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
        let x = rect.width / 5
        let y = rect.height * 3 / 4
        let backgroundColor = NSColor(ciColor: Win10BlueScreen.backgroundColor)
        let fontColor = NSColor(ciColor: Win10BlueScreen.fontColor)
        backgroundColor.setFill()
        NSBezierPath.fill(rect)

        let paragraphStyle0 = NSMutableParagraphStyle()
        paragraphStyle0.paragraphSpacing = 20
        NSAttributedString(
            string: "問題が発生したため、PCを再起動する必要があります。\nエラー情報を収集しています。自動的に再起動します。",
            attributes: [
                NSForegroundColorAttributeName: fontColor,
                NSFontAttributeName: NSFont(name: fontName, size: 20)!,
                NSParagraphStyleAttributeName: paragraphStyle0
            ]
        ).draw(at: NSPoint(x: x, y: y))

        qrCodeImage.draw(in: NSRect(origin: NSPoint(x: x, y: y - 290), size: qrCodeImage.size))

        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.paragraphSpacing = 17
        NSAttributedString(
            string: "この問題と可能な解決方法の詳細については、\(Win10BlueScreen.qrCodeMessage)\nを参照してください。",
            attributes: [
                NSForegroundColorAttributeName: fontColor,
                NSFontAttributeName: NSFont(name: fontName, size: 15)!,
                NSParagraphStyleAttributeName: paragraphStyle1
            ]
        ).draw(at: NSPoint(x: x + Win10BlueScreen.qrCodeSize + 30, y: y - 170))

        NSAttributedString(
            string: "サポート担当者に連絡する場合は、この情報を伝えてください:\n停止コード: KARAAGE TABETAKATTA EXCEPTION NOT HANDLED\n失敗した内容: karaage.ogotte.morau",
            attributes: [
                NSForegroundColorAttributeName: fontColor,
                NSFontAttributeName: NSFont(name: fontName, size: 12)!,
                NSParagraphStyleAttributeName: paragraphStyle1
            ]
        ).draw(at: NSPoint(x: x + Win10BlueScreen.qrCodeSize + 30, y: y - 290))

        if count < countMax {
            progressMessageMake(progress: count, fontColor: fontColor).draw(at: NSPoint(x: x, y: y - 70))
            if arc4random_uniform(50) == 0 {
                count += 1
            }
        } else {
            progressMessageMake(progress: countMax, fontColor: fontColor).draw(at: NSPoint(x: x, y: y - 70))
        }
    }

    private class func qrCodeMake(message: String, size: CGFloat = 100, backgroundColor: CIColor, fontColor: CIColor) -> NSImage {
        let data = message.data(using: String.Encoding.utf8)
        let qrCodeGenerator = CIFilter(name: "CIQRCodeGenerator", withInputParameters: [
            "inputMessage": data,
            "inputCorrectionLevel": "M"
        ])!
        let ciQRCode = qrCodeGenerator.outputImage!
        let falseColor = CIFilter(name: "CIFalseColor", withInputParameters: [
            kCIInputImageKey: ciQRCode,
            "inputColor0": backgroundColor,
            "inputColor1": fontColor
        ])!
        let ciImage = falseColor.outputImage!
        let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent)!
        return NSImage(cgImage: cgImage, size: NSSize(width: size, height: size))
    }

    private func progressMessageMake(progress: Int, fontColor: NSColor) -> NSAttributedString {
        return NSAttributedString(
            string: "\(progress)% 完了",
            attributes: [
                NSForegroundColorAttributeName: fontColor,
                NSFontAttributeName: NSFont(name: fontName, size: 20)!
            ]
        )
    }
}
