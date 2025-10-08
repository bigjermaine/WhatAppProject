//
//  PhotoValidationResult.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 08/10/2025.
//


import SwiftUI
import Vision
import CoreML

import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

struct PhotoAnalysisResult {
    var faceDetected: Bool = false
    var qualityScore: Double = 0.0
    var lightingGood: Bool = false
    var eyesVisible: Bool = false
    var glareDetected: Bool = false
    var glassesDetected: Bool = false
}

struct PhotoAnalyzerView: View {
    @State private var selectedImage: UIImage?
    @State private var result = PhotoAnalysisResult()
    @State private var showingPicker = false

    var body: some View {
        VStack(spacing: 20) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(10)
                    .shadow(radius: 4)
            }

            Button("Select Photo") {
                showingPicker = true
            }
            .buttonStyle(.borderedProminent)

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Text("📸 Photo Analysis Result:")
                    .font(.headline)
                Text("✅ Face detected: \(result.faceDetected ? "Yes" : "No")")
                Text("📊 Quality score: \(String(format: "%.2f", result.qualityScore))")
                Text("🌤️ Lighting good: \(result.lightingGood ? "Yes" : "No")")
                Text("👀 Eyes visible: \(result.eyesVisible ? "Yes" : "No")")
                Text("⚡ Glare detected: \(result.glareDetected ? "Yes" : "No")")
                Text("🕶️ Glasses detected: \(result.glassesDetected ? "Yes" : "No")")
            }
            .padding()
        }
        .sheet(isPresented: $showingPicker) {
          //  ImagePicker(image: $selectedImage, onImagePicked: analyzePhoto)
        }
        .padding()
    }

    private func analyzePhoto(_ image: UIImage) {
        guard let ciImage = CIImage(image: image) else { return }

        var newResult = PhotoAnalysisResult()

        // MARK: 1️⃣ Detect Face
        let faceRequest = VNDetectFaceRectanglesRequest { req, _ in
            if let faces = req.results as? [VNFaceObservation], !faces.isEmpty {
                newResult.faceDetected = true
            }
        }

        // MARK: 2️⃣ Estimate Brightness (Lighting)
        let brightness = ciImage.averageBrightness
        newResult.lightingGood = brightness > 0.4 && brightness < 0.8

        // MARK: 3️⃣ Estimate Image Quality
        newResult.qualityScore = ciImage.estimatedSharpness

        // MARK: 4️⃣ Detect Glasses or Glare (Heuristic)
        newResult.glareDetected = ciImage.glareDetected()
        newResult.glassesDetected = ciImage.detectGlassesLikeReflection()

        // Perform face request
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([faceRequest])

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            result = newResult
        }
    }
}
import CoreImage
import CoreImage.CIFilterBuiltins

extension CIImage {
    /// Average brightness from 0.0 (dark) to 1.0 (bright)
    var averageBrightness: Double {
        let context = CIContext()
        let extentRect = extent
        let extentVector = CIVector(
            x: extentRect.origin.x,
            y: extentRect.origin.y,
            z: extentRect.size.width,
            w: extentRect.size.height
        )

        let filter = CIFilter.areaAverage()
        filter.inputImage = self
        filter.extent = extentVector

        guard let outputImage = filter.outputImage else { return 0 }

        var bitmap = [UInt8](repeating: 0, count: 4)
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        let r = Double(bitmap[0]) / 255.0
        let g = Double(bitmap[1]) / 255.0
        let b = Double(bitmap[2]) / 255.0
        return (r + g + b) / 3.0
    }

    /// Rough estimate of sharpness (0–1)
    var estimatedSharpness: Double {
        let context = CIContext()
        let filter = CIFilter(name: "Laplacian") ?? CIFilter.edges()
        filter.setValue(self, forKey: kCIInputImageKey)
        guard let output = filter.outputImage else { return 0 }

        // Calculate average intensity of the edge map
        let outputExtent = output.extent
        let filter2 = CIFilter.areaAverage()
        filter2.inputImage = output
        filter2.extent = CIVector(
            x: outputExtent.origin.x,
            y: outputExtent.origin.y,
            z: outputExtent.size.width,
            w: outputExtent.size.height
        )

        guard let avgImage = filter2.outputImage else { return 0 }

        var bitmap = [UInt8](repeating: 0, count: 4)
        context.render(avgImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        let avg = Double(bitmap[0]) / 255.0
        return min(max(avg * 10, 0), 1)
    }

    func glareDetected() -> Bool {
        return averageBrightness > 0.85
    }

    func detectGlassesLikeReflection() -> Bool {
        // Simple heuristic: bright edges in upper region
        let cropped = self.cropped(to: CGRect(x: 0, y: extent.height * 0.4,
                                              width: extent.width,
                                              height: extent.height * 0.3))
        let edges = cropped.applyingFilter("CIEdges")
        return edges.averageBrightness > 0.5
    }
}
