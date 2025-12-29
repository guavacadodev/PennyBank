import PhotosUI
import SwiftUI
import UIKit

struct ScanQRCodeView: View {
    @StateObject private var viewModel = ScanQRCodeViewModel(detector: QRCodeDetector())
    @State private var pickedItem: PhotosPickerItem?
    @Environment(\.openURL) private var openURL

    let onClose: () -> Void
    let onShowMyCode: () -> Void

    var body: some View {
        ZStack {
            switch viewModel.cameraState {
            case .authorized:
                QRCodeCameraScannerView(
                    isTorchOn: $viewModel.isTorchOn,
                    isScanningEnabled: viewModel.isScanningEnabled,
                    onCodeScanned: viewModel.handleScannedCode
                )
                .ignoresSafeArea()

            case .unknown:
                permissionPlaceholder(
                    title: "需要相机权限",
                    message: "用于扫描二维码。"
                ) {
                    viewModel.requestCameraAccessIfNeeded()
                }

            case .denied:
                permissionPlaceholder(
                    title: "相机权限未开启",
                    message: "请在系统设置中允许相机访问。"
                ) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        openURL(url)
                    }
                }
            }

            overlay
        }
        .onAppear {
            viewModel.onAppear()
        }
        .alert("扫描结果", isPresented: Binding(get: { viewModel.scannedCode != nil }, set: { _ in
            viewModel.dismissScannedCode()
        })) {
            Button("关闭") {
                viewModel.dismissScannedCode()
            }
        } message: {
            Text(viewModel.scannedCode ?? "")
        }
        .alert("提示", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { _ in
            viewModel.errorMessage = nil
        })) {
            Button("好") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onChange(of: pickedItem) { _, newItem in
            guard let newItem else { return }
            Task { @MainActor in
                defer { pickedItem = nil }
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    viewModel.scanFromPickedImage(image)
                } else {
                    viewModel.errorMessage = "无法读取照片。"
                }
            }
        }
    }

    private var overlay: some View {
        VStack {
            HStack {
                Button {
                    onClose()
                } label: {
                    CircularIconView(
                        systemImageName: "xmark",
                        diameter: 40,
                        backgroundColor: Color.black.opacity(0.25),
                        foregroundColor: .white,
                        font: .system(size: 14, weight: .semibold)
                    )
                }
                .buttonStyle(.plain)
                .padding(.leading, 16)
                .padding(.top, 12)

                Spacer(minLength: 0)
            }

            Spacer(minLength: 0)

            ScanGuideFrameView()

            Spacer(minLength: 0)

            bottomControls
                .padding(.horizontal, 20)
                .padding(.bottom, 26)
        }
    }

    private var bottomControls: some View {
        HStack(spacing: 18) {
            PhotosPicker(selection: $pickedItem, matching: .images) {
                CircularIconView(
                    systemImageName: "photo.on.rectangle",
                    diameter: 54,
                    backgroundColor: Color.black.opacity(0.25),
                    foregroundColor: .white,
                    font: .system(size: 20, weight: .semibold)
                )
            }
            .accessibilityLabel("选择相册照片")

            Spacer(minLength: 0)

            Button {
                onShowMyCode()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "qrcode")
                        .font(.system(size: 16, weight: .semibold))
                    Text("My Code")
                        .font(.system(size: 14, weight: .semibold))
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .background(
                    Capsule(style: .continuous)
                        .fill(Color.brandLime)
                )
                .foregroundStyle(.black)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("My Code")

            Spacer(minLength: 0)

            Button {
                viewModel.isTorchOn.toggle()
            } label: {
                CircularIconView(
                    systemImageName: "bolt.fill",
                    diameter: 54,
                    backgroundColor: Color.black.opacity(0.25),
                    foregroundColor: .white,
                    font: .system(size: 20, weight: .semibold)
                )
            }
            .buttonStyle(.plain)
            .disabled(!viewModel.isTorchAvailable || viewModel.cameraState != .authorized)
            .accessibilityLabel("闪光灯")
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func permissionPlaceholder(title: String, message: String, action: @escaping () -> Void) -> some View {
        ZStack {
            Color.black.opacity(0.85).ignoresSafeArea()

            VStack(spacing: 10) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)

                Text(message)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)

                Button("继续") {
                    action()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.brandLime)
                .foregroundStyle(.black)
                .padding(.top, 8)
            }
            .padding(.horizontal, 20)
        }
    }
}

private struct ScanGuideFrameView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.white.opacity(0.9), lineWidth: 2)

            ScanGuideCorners()
                .padding(10)
        }
        .frame(width: 260, height: 260)
    }
}

private struct ScanGuideCorners: View {
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let cornerLength: CGFloat = 34

            Path { path in
                // Top-left
                path.move(to: CGPoint(x: 0, y: cornerLength))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: cornerLength, y: 0))

                // Top-right
                path.move(to: CGPoint(x: width - cornerLength, y: 0))
                path.addLine(to: CGPoint(x: width, y: 0))
                path.addLine(to: CGPoint(x: width, y: cornerLength))

                // Bottom-right
                path.move(to: CGPoint(x: width, y: height - cornerLength))
                path.addLine(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: width - cornerLength, y: height))

                // Bottom-left
                path.move(to: CGPoint(x: cornerLength, y: height))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: 0, y: height - cornerLength))
            }
            .stroke(
                Color.white.opacity(0.95),
                style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
            )
        }
    }
}

#Preview {
    ScanQRCodeView(onClose: {}, onShowMyCode: {})
}
