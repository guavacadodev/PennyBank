import AVFoundation
import SwiftUI

struct QRCodeCameraScannerView: UIViewControllerRepresentable {
    @Binding var isTorchOn: Bool
    let isScanningEnabled: Bool
    let onCodeScanned: (String) -> Void

    func makeUIViewController(context: Context) -> QRCodeCameraScannerViewController {
        let controller = QRCodeCameraScannerViewController()
        controller.onCodeScanned = onCodeScanned
        controller.setTorch(isOn: isTorchOn)
        controller.isScanningEnabled = isScanningEnabled
        return controller
    }

    func updateUIViewController(_ uiViewController: QRCodeCameraScannerViewController, context: Context) {
        uiViewController.isScanningEnabled = isScanningEnabled
        uiViewController.setTorch(isOn: isTorchOn)
    }
}

final class QRCodeCameraScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var onCodeScanned: ((String) -> Void)?
    var isScanningEnabled: Bool = true

    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "pennybank.scan.session")
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var videoDevice: AVCaptureDevice?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureSession()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sessionQueue.async { [weak self] in
            guard let self else { return }
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sessionQueue.async { [weak self] in
            guard let self else { return }
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }

    func setTorch(isOn: Bool) {
        sessionQueue.async { [weak self] in
            guard let self, let device = self.videoDevice, device.hasTorch else { return }
            do {
                try device.lockForConfiguration()
                device.torchMode = isOn ? .on : .off
                device.unlockForConfiguration()
            } catch {
            }
        }
    }

    private func configureSession() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            self.session.beginConfiguration()
            defer { self.session.commitConfiguration() }

            self.session.sessionPreset = .high

            guard
                let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                let input = try? AVCaptureDeviceInput(device: device),
                self.session.canAddInput(input)
            else {
                return
            }

            self.videoDevice = device
            self.session.addInput(input)

            let output = AVCaptureMetadataOutput()
            guard self.session.canAddOutput(output) else { return }
            self.session.addOutput(output)

            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [.qr]

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                let layer = AVCaptureVideoPreviewLayer(session: self.session)
                layer.videoGravity = .resizeAspectFill
                layer.frame = self.view.bounds
                self.view.layer.insertSublayer(layer, at: 0)
                self.previewLayer = layer
            }
        }
    }

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard isScanningEnabled else { return }
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
        guard object.type == .qr else { return }
        guard let code = object.stringValue, !code.isEmpty else { return }
        onCodeScanned?(code)
    }
}

