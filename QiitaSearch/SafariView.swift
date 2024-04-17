import SwiftUI
import SafariServices

// SFSafariViewControllerを起動する構造体
struct SafariView: UIViewControllerRepresentable {
    // 表示する記事のURLを受け取る変数
    let url: URL
    // 表示するViewを生成する時に実行
    func makeUIViewController(context: Context) -> SFSafariViewController {
        // Safariを起動
        return SFSafariViewController(url: url)
    }
    
    // Viewが更新された時に実行
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // 処理なし
    }
}
