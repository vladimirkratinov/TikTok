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

    private let recordButton = RecordButton()
    private var previewLayer: AVPlayerLayer?
    var recordedVideoURL: URL?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(cameraView)
        view.addSubview(recordButton)

        setUPCamera()

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )

        recordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        let size: CGFloat = 70
        recordButton.frame = CGRect(x: (view.width - size)/2, y: view.height - view.safeAreaInsets.bottom - size - 5, width: size, height: size)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    @objc func didTapRecord() {
        if captureOutput.isRecording {
            // stop recording
            recordButton.toggle(for: .notRecording)
            captureOutput.stopRecording()
            HapticsManager.shared.vibrateForSelection()
        } else {
            guard var url = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first else {
                return
            }

            HapticsManager.shared.vibrateForSelection()

            if #available(iOS 14.0, *) {
                url.appendPathComponent("video.mp4", conformingTo: .url)
                try? FileManager.default.removeItem(at: url)
                recordButton.toggle(for: .recording)
            } else {
                // Fallback on earlier versions
            }

            captureOutput.startRecording(to: url,
                                         recordingDelegate: self)
        }
    }

    @objc func didTapClose() {
        navigationItem.rightBarButtonItem = nil
        recordButton.isHidden = false
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        } else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false
            tabBarController?.selectedIndex = 0
        }

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

        // [AVCaptureSession startRunning] should be called from background thread.

        DispatchQueue.global(qos: .background).async {
            // Enable camera start
            self.captureSession.startRunning()
        }
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {

        guard error == nil else {
            let alert = UIAlertController(title: "Whoops",
                                          message: "Something went wrong when recording video.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }

        print("Finished recording to url: \(outputFileURL.absoluteString)")

        recordedVideoURL = outputFileURL

        if UserDefaults.standard.bool(forKey: "save_video") {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))

        let player = AVPlayer(url: outputFileURL)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        guard let previewLayer = previewLayer else {
            return
        }

        recordButton.isHidden = true
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.player?.play()
    }

    @objc func didTapNext() {
        // Push caption controller
        guard let url = recordedVideoURL else { return }
        HapticsManager.shared.vibrateForSelection()
        let vc = CaptionViewController(videoURL: url)
        navigationController?.pushViewController(vc, animated: true)
    }
}
