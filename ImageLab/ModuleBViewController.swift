//
//  ModuleBViewController.swift
//  ImageLab
//
//  Created by Xingming on 10/24/19.
//  Copyright © 2019 Eric Larson. All rights reserved.
//

import UIKit

class ModuleBViewController: UIViewController {
    var videoManager:VideoAnalgesic! = nil
    let bridge = OpenCVBridge()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = nil
  

        self.videoManager = VideoAnalgesic.sharedInstance
        self.videoManager.setCameraPosition(position: AVCaptureDevice.Position.back)
        
        self.videoManager.turnOnFlashwithLevel(1.0)
        self.bridge.setTransforms(self.videoManager.transform)
        self.videoManager.setProcessingBlock(newProcessBlock: self.processImage)
        
        if !videoManager.isRunning{
            videoManager.start()
        }

        // Do any additional setup after loading the view.
        
    }
    
    // need to fix turnOnFlashwithLevel bug. It was called once at the first time switched to modual B

    
    override func viewWillAppear(_ animated: Bool) {
        self.videoManager.setCameraPosition(position: AVCaptureDevice.Position.back)
        self.bridge.setTransforms(self.videoManager.transform)
        self.videoManager.setProcessingBlock(newProcessBlock: self.processImage)
        if !videoManager.isRunning{
            videoManager.start()
        }
        self.videoManager.turnOnFlashwithLevel(1.0)
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.videoManager.turnOffFlash()
//        videoManager.stop()
    }

    
    func processImage(inputImage:CIImage) -> CIImage{
        
        self.videoManager.turnOnFlashwithLevel(1.0)
        var retImage = inputImage
        
        // use this code if you are using OpenCV and want to overwrite the displayed image via OpenCv
        // this is a BLOCKING CALL
        self.bridge.setImage(retImage, withBounds: retImage.extent, andContext: self.videoManager.getCIContext())
        self.bridge.processHeartRate()
        retImage = self.bridge.getImage()
        
        return retImage
    }

}
