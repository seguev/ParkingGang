//
//  ViewController.swift
//  ParkingGang
//
//  Created by segev perets on 22/01/2024.
//

import UIKit
import VisionKit
import Combine
import AVFoundation
import Lottie
class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    let vm = ViewModel()
    var listener = Set<AnyCancellable>()
    
    private var simpleObjectDetector: VideoObjectDetectionManager!
    private let session = AVCaptureSession()
     private let videoDataOutput = AVCaptureVideoDataOutput()
     private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    var lottieView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.isEditable = false
//        simpleObjectDetector = VideoObjectDetectionManager(bufferSize: .init(width: 640.0, height: 480.0))
//        simpleObjectDetector.startSession()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPress)))

    }
    
 
    
    @objc private func didPress() {
        present(documentCameraViewController(), animated: true)
    }
    
    func documentCameraViewController() -> VNDocumentCameraViewController {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = vm
        return documentCameraViewController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener.removeAll()
    }

    func bind() {
        vm.$imageBase64EncodedString.sink { imageStr in
            guard let imageStr else {return}
            
            DispatchQueue.main.async {
                Task {
                    print("👨🏻‍💻 "+Constants.Prompt.gptImagePrompt)
                    let answer = await self.vm.askGPT(question: Constants.Prompt.gptImagePrompt,
                                         image: imageStr)
                    
                    Logger.log("🤖 \(answer ?? "no answer")")
                    self.determineIfCanPark(answer)
                }
            }
        }.store(in: &listener)
    }
    
    func determineIfCanPark(_ gptAnswer:String?) {
        guard let gptAnswer else {
            textView.text = "No answer"
            return
        }
        
        if gptAnswer.lowercased().contains("yes") {
            self.lottieView = vm.showLottie(.V, on: view)
        } else if gptAnswer.lowercased().contains("no") {
            self.lottieView = vm.showLottie(.X, on: view)
        }
        textView.text = gptAnswer
    }
    
}

