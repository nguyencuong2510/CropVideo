//
//  ViewController.swift
//  TimerDemo
//
//  Created by nguyencuong on 3/11/18.
//  Copyright © 2018 nguyencuong. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var showVideo: UIView!
    var playerLayer: AVPlayerLayer! = nil
    
    var player: AVPlayer!
    var url: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        url = Bundle.main.url(forResource: "video", withExtension: "mp4")
        cropVideo(sourceURL1: url!, statTime: 0.0, endTime: 5.0)
        playerLayer = AVPlayerLayer()
        
    }
    
    
    @IBAction func playClick(_ sender: UIButton) {
        cropVideo(sourceURL1: url!, statTime: 5.0, endTime: 10.0)
    }
    
    @IBAction func pauseClick(_ sender: UIButton) {
        cropVideo(sourceURL1: url!, statTime: 20.0, endTime: 30.0)
    }
    
    
    func playVideoCut(url: URL, view: UIView) {
        playerLayer.frame = view.bounds
        
        player = AVPlayer(url: url)
        
        player.actionAtItemEnd = .none
        playerLayer.player = player
        view.layer.addSublayer(playerLayer)
        
        player.play()
    }
    
    
    
    func cropVideo(sourceURL1: URL, statTime:Float, endTime:Float)
    {
        let manager = FileManager.default
        
        guard let documentDirectory = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {return}
        
        let asset = AVAsset(url: sourceURL1)
        
        var outputURL = documentDirectory.appendingPathComponent("output")
        do {
            try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("loadVideo.mp4")
        }catch let error {
            print(error)
        }
        
        //Remove existing file
        _ = try? manager.removeItem(at: outputURL)
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        
        let startTime = CMTime(seconds: Double(statTime), preferredTimescale: 1000)
        let endTime = CMTime(seconds: Double(endTime), preferredTimescale: 1000)
        let timeRange = CMTimeRange(start: startTime, end: endTime)
        
        exportSession.timeRange = timeRange
        exportSession.exportAsynchronously{
            switch exportSession.status {
            case .completed:
                DispatchQueue.main.async {
                    self.playVideoCut(url: outputURL,  view: self.showVideo)
                }
            case .failed:
                print("failed \(exportSession.error)")
            case .cancelled:
                print("cancelled \(exportSession.error)")
            default: break
            }
        }
        
    }
    
    
    
}

