import Foundation
import Vision
import UIKit

enum QRCodeDetectorError: Error {
    case invalidImage
}

struct QRCodeDetector {
    func detectFirstPayloadString(in image: UIImage) throws -> String? {
        guard let cgImage = image.cgImage else {
            throw QRCodeDetectorError.invalidImage
        }

        let request = VNDetectBarcodesRequest()
        request.symbologies = [.QR]

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([request])

        let observations = request.results ?? []
        return observations.first?.payloadStringValue
    }
}

