import AVFoundation
import Combine
import Foundation
import UIKit

@MainActor
final class ScanQRCodeViewModel: ObservableObject {
    enum CameraState: Equatable {
        case unknown
        case authorized
        case denied
    }

    @Published private(set) var cameraState: CameraState = .unknown
    @Published var isTorchOn = false
    @Published private(set) var isTorchAvailable: Bool
    @Published var isScanningEnabled = true
    @Published var scannedCode: String?
    @Published var errorMessage: String?

    private let detector: QRCodeDetector

    init(detector: QRCodeDetector) {
        self.detector = detector
        self.isTorchAvailable = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)?.hasTorch ?? false
        refreshCameraState()
    }

    func onAppear() {
        requestCameraAccessIfNeeded()
    }

    func dismissScannedCode() {
        scannedCode = nil
        isScanningEnabled = true
    }

    func handleScannedCode(_ code: String) {
        guard isScanningEnabled else { return }
        isScanningEnabled = false
        scannedCode = code
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    func scanFromPickedImage(_ image: UIImage) {
        do {
            if let code = try detector.detectFirstPayloadString(in: image) {
                handleScannedCode(code)
            } else {
                errorMessage = "未在图片中识别到二维码。"
            }
        } catch {
            errorMessage = "二维码识别失败，请重试。"
        }
    }

    func requestCameraAccessIfNeeded() {
        refreshCameraState()
        guard cameraState == .unknown else { return }

        Task {
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            cameraState = granted ? .authorized : .denied
        }
    }

    func refreshCameraState() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraState = .authorized
        case .denied, .restricted:
            cameraState = .denied
        case .notDetermined:
            cameraState = .unknown
        @unknown default:
            cameraState = .unknown
        }
    }
}
