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
            Logger.log("got image")
            DispatchQueue.main.async {
//                let mockURL = "https://t4.ftcdn.net/jpg/00/97/58/97/360_F_97589769_t45CqXyzjz0KXwoBZT9PRaWGHRk5hQqQ.jpg"
                self.vm.askGPT(question: Constants.Prompt.mockPrompt,
                               image: imageStr)
            }
        }.store(in: &listener)
    }
    
    
    
}

extension ViewController: VNDocumentCameraViewControllerDelegate {

}
