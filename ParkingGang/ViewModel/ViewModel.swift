//
//  ViewModel.swift
//  ParkingGang
//
//  Created by segev perets on 22/01/2024.
//

import UIKit
import VisionKit
import Lottie
class ViewModel: NSObject, VNDocumentCameraViewControllerDelegate {
    
    @Published var imageBase64EncodedString: String?
    @Published var alertController: UIAlertController?
    
    let gpt = GPTLogic()
    
    enum LottieAnimationType {
        case V,X
    }
    
    @discardableResult
    func showLottie(_ type:LottieAnimationType, on view:UIView) -> LottieAnimationView {
        let lottieString = switch type {
        case .V: "VAnimation"
        case .X: "XAnimation"
        }
        
        let screenWidth = view.frame.width
        let lottieView = LottieAnimationView(name: lottieString)
        lottieView.frame = .init(origin: .zero, size: .init(width: screenWidth*0.8,
                                                            height: screenWidth*0.8))
        lottieView.loopMode = .playOnce
        lottieView.center = view.center
        view.addSubview(lottieView)
        lottieView.play()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred(intensity: 1)
        return lottieView
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
    
    func askGPT(question:String,image:String) async -> String? {
        
        guard let queryData = gpt.formQuery(question: question,
                                            imageDataString: image) else {
            Logger.log("Invalid queryData")
            return nil
        }
        do {
            let data = try await Network.shared.postRequest(.completions,
                                                            queryData: queryData)
            
            let gptData = try JSONDecoder().decode(GPTAnswerModel.self, from: data)

            Logger.log(gptData.usage.total_tokens)
            guard let answer = gptData.choices.first?.message.content else {
                Logger.log("no answer")
                return nil
            }
            return answer
        } catch {
            Logger.log(error)
            showAlert("Something went wrong",
                      error.localizedDescription,
                      "OK")
            return nil
        }
    }
    
    func showAlert(_ title:String,_ messsage:String,_ dismissText:String) {
        let alert = UIAlertController(title: title, message: messsage, preferredStyle: .alert)
        alert.addAction(.init(title: dismissText, style: .cancel))
        self.alertController = alert
    }

}
