import SwiftUI
import PhotosUI

@MainActor
final class PassportImageUploadViewModel: ObservableObject {
    // Published state for the view
    @Published var selectedImage: UIImage?
    @Published var isPresentingImagePicker: Bool = false
    @Published var isTakingPhoto: Bool = false
    @Published var selectedItem: PhotosPickerItem?
    @Published var isShowingSourcePicker: Bool = false

    // Derived state
    var canProceed: Bool { selectedImage != nil }

    // Handle PhotosPicker item selection
    func handleSelectedItemChange() {
        Task { [weak self] in
            guard let self = self else { return }
            if let item = self.selectedItem,
               let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                self.selectedImage = uiImage
            }
        }
    }

    // Trigger camera capture (placeholder implementation)
    func takePhotoPlaceholder() {
        self.selectedImage = dummyImage(color: .blue, size: CGSize(width: 200, height: 200))
        self.isTakingPhoto = false
    }

    // Utilities
    private func dummyImage(color: UIColor, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            let circleRect = CGRect(
                x: size.width * 0.25,
                y: size.height * 0.25,
                width: size.width * 0.5,
                height: size.height * 0.5
            )
            UIColor.white.setFill()
            context.cgContext.fillEllipse(in: circleRect)
        }
    }
}
