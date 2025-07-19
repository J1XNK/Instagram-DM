import SwiftUI
import WebKit

struct ContentView: NSViewRepresentable {
    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.setValue(false, forKey: "drawsBackground")

        if let scrollView = webView.enclosingScrollView {
            scrollView.hasVerticalScroller = false
            scrollView.hasHorizontalScroller = false
            scrollView.scrollerStyle = .overlay
            scrollView.verticalScrollElasticity = .none
            scrollView.horizontalScrollElasticity = .none
            scrollView.drawsBackground = false
            scrollView.borderType = .noBorder
        }

        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"

        if let url = URL(string: "https://m.instagram.com/direct/inbox") {
            webView.load(URLRequest(url: url))
            let js = """
            document.addEventListener("DOMContentLoaded", function() {
                var style = document.createElement('style');
                style.innerHTML = `
                    ::-webkit-scrollbar { display: none !important; }
                    body, html { overflow: hidden !important; }

                    /* 모든 스크롤 가능한 div 요소 숨기기 */
                    div, section, main, aside {
                        scrollbar-width: none !important;
                        -ms-overflow-style: none !important;
                    }
                    div::-webkit-scrollbar, section::-webkit-scrollbar, main::-webkit-scrollbar {
                        display: none !important;
                    }
                `;
                document.head.appendChild(style);
            });
            """
            webView.evaluateJavaScript(js)
        }

        webView.autoresizingMask = [.width, .height]

        if let scrollView = webView.subviews.first(where: { $0 is NSScrollView }) as? NSScrollView {
            scrollView.hasVerticalScroller = false
            scrollView.hasHorizontalScroller = false
            scrollView.scrollerStyle = .overlay
            scrollView.verticalScrollElasticity = .none
            scrollView.horizontalScrollElasticity = .none
            scrollView.drawsBackground = false
            scrollView.borderType = .noBorder
            scrollView.automaticallyAdjustsContentInsets = false

            for subview in scrollView.subviews {
                if let scroller = subview as? NSScroller {
                    scroller.alphaValue = 0
                    scroller.isHidden = true
                }
            }

            if let contentView = scrollView.contentView as? NSClipView {
                contentView.postsBoundsChangedNotifications = false
            }
        }

        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        // 창 크기 바뀔 때마다 자동 적용되므로 여긴 비워둬도 됨
    }

}

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("설정")
                .font(.title)
                .bold()

            Toggle("스크롤바 숨기기", isOn: .constant(true))
            Toggle("모바일 뷰 강제 적용", isOn: .constant(true))
            Toggle("마지막 창 크기 기억", isOn: .constant(true))

            Spacer()
        }
        .padding()
        .frame(width: 300, height: 200)
    }
}
