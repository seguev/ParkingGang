//
//  VideoObjectDetectionManager.swift
//  ParkingGang
//
//  Created by segev perets on 26/01/2024.
//
import UIKit
import AVFoundation
import Vision

class VideoObjectDetectionManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let bufferSize: CGSize
    private var requests = [VNRequest]()
    
    private let session = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    
    init(bufferSize: CGSize) {
        self.bufferSize = bufferSize
        super.init()
        setupVision()
    }
    
    private func setupVision() {
        
        //model
        guard let modelURL = Bundle.main.url(forResource: "YOLOv3Tiny", withExtension: "mlmodelc") else {
            fatalError("Model file is missing")
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    if let results = request.results {
                        self.handleVisionResults(results)
                    }
                })
            })
            self.requests = [objectRecognition]
        } catch let error as NSError {
            fatalError("Model loading went wrong: \(error)")
        }
        
        //config
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        
    }
    
    func startSession() {
        
        self.session.startRunning()
        
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        self.captureOutput(output, didOutput: sampleBuffer, from: connection)
    }
    
    private func handleVisionResults(_ results: [Any]) {
        DispatchQueue.main.async {
            // Handle vision results here (update UI or perform other tasks)
            for observation in results where observation is VNRecognizedObjectObservation {
                guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                    continue
                }
                let topLabelObservation = objectObservation.labels[0]
                print("Detected object: \(topLabelObservation.identifier) with confidence \(topLabelObservation.confidence)")
                
                // Update UI or perform other tasks on the main thread
            }
        }
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let exifOrientation = exifOrientationFromDeviceOrientation()
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    private func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case .portraitUpsideDown: exifOrientation = .left
        case .landscapeLeft: exifOrientation = .upMirrored
        case .landscapeRight: exifOrientation = .down
        case .portrait, .faceUp, .faceDown: exifOrientation = .up
        @unknown default: exifOrientation = .up
        }
        return exifOrientation
    }
}
