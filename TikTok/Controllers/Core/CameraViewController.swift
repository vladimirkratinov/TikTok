//
//  CameraViewController.swift
//  TikTok
//
//  Created by Vladimir Kratinov on 2022-11-03.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    // Capture Session
    var captureSession = AVCaptureSession()
    
    // Capture Device
    var videoCaptureDevice: AVCaptureDevice?
    
    // Capture Output
    var captureOutput = AVCaptureMovieFileOutput()
    
    // Capture Preview
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(cameraView)
        setUPCamera()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc func didTapClose() {
        captureSession.stopRunning()
        tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 0
    }
    
    func setUPCamera() {
        // Add devices
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
            if let audioInput = audioInput {
                // Check that we don't have both camera (front/near) connected together
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                }
            }
        }
        
        if let videoDevice = AVCaptureDevice.default(for: .video) {
            if let videoInput = try? AVCaptureDeviceInput(device: videoDevice) {
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
            }
        }
        
        // Update session
        captureSession.sessionPreset = .hd1280x720
        if captureSession.canAddOutput(captureOutput) {

            captureSession.addOutput(captureOutput)
        }
        
        // Configure preview
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds
        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }
        
        // Enable camera start
        captureSession.startRunning()
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        guard error == nil else {
            return
        }
        
        print("Finished recording to url: \(outputFileURL.absoluteString)")
    }
}
