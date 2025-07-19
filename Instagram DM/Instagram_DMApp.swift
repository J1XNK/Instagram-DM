import SwiftUI
import WebKit

@main
struct InstagramMiniDMApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 375, minHeight: 550)  // 최소 높이 550으로 고정
        }
        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.setContentSize(NSSize(width: 375, height: 550))  // 초기 크기 설정
            // 창 크기 조절 막는 코드 제거함 (이제 resizable 허용)
            window.contentView?.enclosingScrollView?.hasHorizontalScroller = false
            window.contentView?.enclosingScrollView?.hasVerticalScroller = false
            window.contentView?.wantsLayer = true
            window.contentView?.layer?.masksToBounds = true
        }
    }
}
