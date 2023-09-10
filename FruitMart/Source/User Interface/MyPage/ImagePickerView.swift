//
//  ImagePickerView.swift
//  FruitMart
//
//  Created by 김희진 on 2023/09/09.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var pickedImage: Image
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerControler = UIImagePickerController()
        imagePickerControler.delegate = context.coordinator
        imagePickerControler.modalPresentationStyle = .overFullScreen
        imagePickerControler.allowsEditing = true
        return imagePickerControler
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    final class Coordinator: NSObject {
        let parent: ImagePickerView
        
        init(parent: ImagePickerView) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

extension ImagePickerView.Coordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[.originalImage] as! UIImage
        let editedImage = info[.editedImage] as? UIImage
        let selectedImage = editedImage ?? originalImage

        parent.pickedImage = Image(uiImage: selectedImage)
        picker.dismiss(animated: true)
    }
}
