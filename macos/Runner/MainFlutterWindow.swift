import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  private let startupSplashContentSize = NSSize(width: 640, height: 460)

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    configureForStartupSplash()
    flutterViewController.backgroundColor = NSColor.clear

    self.contentViewController = flutterViewController
    self.setContentSize(startupSplashContentSize)
    self.center()
    configureForStartupSplash()

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }

  private func configureForStartupSplash() {
    self.isOpaque = false
    self.backgroundColor = NSColor.clear
    self.hasShadow = false
    self.titleVisibility = .hidden
    self.titlebarAppearsTransparent = true
    self.styleMask.insert(.fullSizeContentView)
    self.standardWindowButton(.closeButton)?.isHidden = true
    self.standardWindowButton(.miniaturizeButton)?.isHidden = true
    self.standardWindowButton(.zoomButton)?.isHidden = true
  }
}
