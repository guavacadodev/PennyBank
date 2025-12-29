import SwiftUI

struct MyQRCodeSheetView: View {
    let codeString: String
    let onClose: () -> Void

    private let generator = QRCodeGenerator()

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 12)

            Divider()
                .opacity(0.6)

            VStack(spacing: 18) {
                qrCode
                    .padding(.top, 24)

                Text("Show and scan this QR code\nto start transactions")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)

            shareButton
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .padding(.top, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private var header: some View {
        HStack {
            Text("My QR Code")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)

            Spacer(minLength: 0)

            Button {
                onClose()
            } label: {
                CircularIconView(
                    systemImageName: "xmark",
                    diameter: 28,
                    backgroundColor: Color.secondary.opacity(0.12),
                    foregroundColor: .secondary,
                    font: .system(size: 11, weight: .bold)
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Close")
        }
    }

    private var qrCode: some View {
        ZStack {
            if let image = generator.makeImage(from: codeString, scale: 10) {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .padding(6)

                Circle()
                    .fill(Color.brandLime)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text("PB.")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.black)
                    )
                    .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 4)
                    .accessibilityHidden(true)
            } else {
                Text("二维码生成失败")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 260, height: 260)
        .accessibilityLabel("My QR Code")
    }

    private var shareButton: some View {
        ShareLink(item: codeString) {
            Text("Share Code")
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
        }
        .buttonStyle(PrimaryButtonStyle())
        .accessibilityLabel("Share Code")
    }
}

#Preview {
    MyQRCodeSheetView(codeString: "pennybank://me", onClose: {})
}
