//
//  ViewModel.swift
//  ParkingGang
//
//  Created by segev perets on 22/01/2024.
//

import UIKit
import VisionKit

class ViewModel: NSObject, VNDocumentCameraViewControllerDelegate {
    
    @Published var imageBase64EncodedString: String?
    @Published var alertController: UIAlertController?
    
    let gpt = GPTLogic()
    
    func openCamera(_ VC:UIViewController) {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        
        VC.present(documentCameraViewController, animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true) {
            let firstImageDataString = scan.imageOfPage(at: 0).jpegData(compressionQuality: 0.1)
            guard let compressedData = firstImageDataString else {
                fatalError()
            }
            self.imageBase64EncodedString = compressedData.base64EncodedString()
        }
    }
    
    func askGPT(question:String,image:String) {
        Task {
            guard let queryData = gpt.formQuery(question: question,
                                                imageDataString: image) else {
                Logger.log("Invalid queryData")
                return
            }
            do {
                let data = try await Network.shared.postRequest(.completions,
                                                                queryData: queryData)
                let answer = String(data: data, encoding: .utf8)
                Logger.log("GPT answer:",answer ?? "no answer")
            } catch {
                Logger.log(error)
                showAlert("Something went wrong",
                          error.localizedDescription,
                          "OK")
            }
            
        }
        
        
    }
    
    func showAlert(_ title:String,_ messsage:String,_ dismissText:String) {
        let alert = UIAlertController(title: title, message: messsage, preferredStyle: .alert)
        alert.addAction(.init(title: dismissText, style: .cancel))
        self.alertController = alert
    }

}
