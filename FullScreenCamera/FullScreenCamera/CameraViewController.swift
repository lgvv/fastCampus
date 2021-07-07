//
//  ViewController.swift
//  FullScreenCamera
//
//  Created by Hamlit Jason on 2021/07/05.
//


import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {
    // TODO: 초기 설정 1
    /*
     captureSession
     AVCaptureDeviceInput
     AVCapturePhotoOutput
     Queue
     AVCaptureDeviceDiscoverySession
     */
    
    let captureSession = AVCaptureSession()
    var videoDeviceInput : AVCaptureDeviceInput! // 후면, 전면으로 카메라 전환할수도 있으니까
    let photoOutput = AVCapturePhotoOutput()
    
    let sessionQueue = DispatchQueue(label: "session Queue")
    let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified) // 디바이스 타입에는 아이폰이 카메라 갯수가 여러개가 되면서 이걸 사용하는게 조금씩 달라졌다.

    @IBOutlet weak var photoLibraryButton: UIButton!
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var blurBGView: UIVisualEffectView!
    @IBOutlet weak var switchButton: UIButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: 초기 설정 2
        previewView.session = captureSession // 전체화면은 세션을 어떤걸로 할건지 보여준다. 그니까 카메라 어떤걸 보여줄건지 보여주는거
        sessionQueue.async {
            self.setupSession()
            self.startSession()
        }
        setupUI()
        
    }
    
    func setupUI() {
        photoLibraryButton.layer.cornerRadius = 10
        photoLibraryButton.layer.masksToBounds = true // 둥근 모양으로 만들겠다
        photoLibraryButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        photoLibraryButton.layer.borderWidth = 1
        
        captureButton.layer.cornerRadius = captureButton.bounds.height / 2 // 동그랗게 만드는 법
        captureButton.layer.masksToBounds = true
        
        blurBGView.layer.cornerRadius = captureButton.bounds.height / 2 // 동그랗게 만드는 법
        blurBGView.layer.masksToBounds = true
        
    }
    
    
    @IBAction func switchCamera(sender: Any) {
        // TODO: 카메라는 1개 이상이어야함
        guard videoDeviceDiscoverySession.devices.count > 1 else {
            return
        }
        
        // TODO: 반대 카메라 찾아서 재설정
        // - 반대 카메라 찾고
        // - 새로운 디바이스 가지고 세션 업데이트
        // - 카메라 토글 버튼 업데이트
        
        sessionQueue.async {
            let currentvideoDevice = self.videoDeviceInput.device // 현재 카메라가 뭔지 알아야지
            let currentPosition = currentvideoDevice.position // 카메라가 앞인지 뒤인지도 알아야지
            let isFornt = currentPosition == .front // 전면 카메라 인가요?
            let preferredPosition : AVCaptureDevice.Position = isFornt ? .back : .front
            
            let devices = self.videoDeviceDiscoverySession.devices
            var newVideoDevice : AVCaptureDevice?
            
            newVideoDevice = devices.first(where: { device in
                return preferredPosition == device.position
            })
            
            // update capture session
            
            if let newDevice = newVideoDevice {
                do {
                    
                    let videoDeviceInput = try AVCaptureDeviceInput(device: newDevice)
                    self.captureSession.beginConfiguration()
                    self.captureSession.removeInput(self.videoDeviceInput)
                    
                    // add new device input
                    if self.captureSession.canAddInput(videoDeviceInput) {
                        self.captureSession.addInput(videoDeviceInput)
                        self.videoDeviceInput = videoDeviceInput
                    } else {
                        self.captureSession.addInput(videoDeviceInput)
                    }
                    self.captureSession.commitConfiguration()
                    
                    DispatchQueue.main.async {
                        self.updateSwitchCameraIcon(position: preferredPosition) // 이 포지션에 따라서 아이콘을 업데이트 시킨다는 이야기
                    }
                    
                } catch let error{
                    print(" error occured while creating device input : \(error.localizedDescription)")
                }
                
            }
        }
    }
    
    func updateSwitchCameraIcon(position: AVCaptureDevice.Position) {
        // TODO: Update ICON
        switch position {
        case .front:
            let image = #imageLiteral(resourceName: "ic_camera_front")
            switchButton.setImage(image, for: .normal)
        case .back:
            let image = #imageLiteral(resourceName: "ic_camera_rear")
            switchButton.setImage(image, for: .normal)
        default:
            break
        }
        
        
    }
    
    @IBAction func capturePhoto(_ sender: UIButton) {
        // TODO: photoOutput의 capturePhoto 메소드
        // orientation
        // photooutput
        
        let videoPreviewLayerOrientation = self.previewView.videoPreviewLayer.connection?.videoOrientation // 사진을 뒤집어서 찍을 수도 있는데, 현재 프리뷰레이어가 갖고 있는걸 그대로 적용한다.
        sessionQueue.async {
            // 미디어에서 들어온 데이터가 사진이 되어서 바깥으로 나가야하는데
            let connection = self.photoOutput.connection(with: .video) // 아웃풋 결과를 커넥션을 통해 연결
            connection?.videoOrientation = videoPreviewLayerOrientation! // 사진에 대한 오리엔테이션을 설정
            
            let setting = AVCapturePhotoSettings() // 캡쳐포토 세팅.
            self.photoOutput.capturePhoto(with: setting, delegate: self) // 사진찍자고 포토 아웃풋에 알려주는거
            // 사진 찍을때, 후처리를 해줄 수 있는데 델리게이트 셀프로 해서 여러가지 메소드가 있는데 그걸로 해결해주기
        }
        

    }
    
    
    func savePhotoLibrary(image: UIImage) {
        // TODO: capture한 이미지 포토라이브러리에 저장
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                // 저장
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: image) // 이미지를 포토 라이브러리에 생성하겠다
                } completionHandler: { (success, error) in
                    print("이미지 저장 완료 --> \(success)")
                }

            } else {
                // 다시 요청
                print("--> 권한을 얻지 못함")
            }
        }
    }
}


extension CameraViewController {
    // MARK: - Setup session and preview
    func setupSession() {
        // TODO: captureSession 구성하기
        // - presetSetting 하기 : 미디어 캡쳐를 할때, 사진을 찍을수도 있고, 영상을 찍을수도 있고 해상도를 정할수도 있고 등등 하니까 그에 대한 것을 먼저 설정해줘야 한다.
        // - beginConfiguration
        // - Add Video Input
        // - Add Photo Output
        // - commitConfiguration
        
        captureSession.sessionPreset = .photo // 사진을 찍을거니까 포토로!
        captureSession.beginConfiguration() // 나 이제 구성 시작할거라고 피시에게 알림
        
        
        // - Add Video Input
        
        do {
            var defaultVideoDevice : AVCaptureDevice?
            if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                defaultVideoDevice = dualCameraDevice
            } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                defaultVideoDevice = frontCameraDevice
            }
            
            guard let camera = videoDeviceDiscoverySession.devices.first else {// 여기에서 찾은게 있으면 첫번째꺼 가져옴 - 핸드폰에서 카메라를 찾을떄, videoDeviceDiscoverySession 중 제일 마지막 파라미터에 명시된 부분을 찾으라는 의미
                captureSession.commitConfiguration() // 못찾았으면 그냥 종료하게끔
                return
            }
            let videoDeviceInput = try AVCaptureDeviceInput(device: camera)
            
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            } else {
                captureSession.commitConfiguration()
                return
            }
        } catch let error{
            captureSession.commitConfiguration()
            return
        }
        
        // -Add photo Output
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil) // 사진을 어떤 형식으로 저장할지 미리 세팅해두기
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            captureSession.commitConfiguration()
            return
        }
        
        captureSession.commitConfiguration() // 구성 완료했다고 알림
    }
    
    
    
    func startSession() {
        // TODO: session Start
        
        sessionQueue.async { // 메인 큐가 아닌 세션쪽 큐에서 동작하게끔 설계
            if !self.captureSession.isRunning { // 세션이 실행중이 아닐때
                self.captureSession.startRunning()
            }
        }
        

    }
    
    func stopSession() {
        // TODO: session Stop
        
        sessionQueue.async {
            if self.captureSession.isRunning { // 지금 진행 중이면
                self.captureSession.stopRunning()
            }
        }
        
        
        
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) { // 사진이 다 찍혔을때, 후처리
        // TODO: capturePhoto delegate method 구현
        
        guard error == nil else { return }
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: imageData) else { return }
        self.savePhotoLibrary(image: image)
        
        
    }
}
