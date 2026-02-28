import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewControllerRepresentable {
    var completion: (Result<String, Error>) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> ScannerViewController {
        let vc = ScannerViewController()
        vc.delegate = context.coordinator  // ✅ ここでエラーが解消される
        return vc
    }

    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}

    // ④ Coordinator が ScannerViewControllerDelegate に準拠
    class Coordinator: NSObject, ScannerViewControllerDelegate {
        let parent: QRCodeScannerView

        init(parent: QRCodeScannerView) {
            self.parent = parent
        }

        func didFind(code: String) {
            parent.dismiss()
            parent.completion(.success(code))
        }
    }
}
