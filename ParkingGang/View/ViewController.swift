//
//  ViewController.swift
//  ParkingGang
//
//  Created by segev perets on 22/01/2024.
//

import UIKit
import VisionKit
import Combine

class ViewController: UIViewController {

    let vm = ViewModel()
    var listener = Set<AnyCancellable>()
    var count = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            print(self.count)
            self.count -= 1
            if self.count == 0 {
                timer.invalidate()
                self.vm.openCamera(self)
            }
        }
        
        
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
                self.vm.askGPT(question: Constants.gptImagePrompt, image: imageStr)
            }
        }.store(in: &listener)
    }
    
    
    
}

extension ViewController: VNDocumentCameraViewControllerDelegate {

}
