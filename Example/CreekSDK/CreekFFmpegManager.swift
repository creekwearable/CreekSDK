//
//  CreekFFmpegManager.swift
//  CreekFFmpeg_Example
//
//  Created by bean on 2025/11/28.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import ffmpegkit



public class CreekFFmpegManager {
    

    public func convertVideoToGif(_ videoURL: URL,
                                  startTime: Int,
                                  endTime: Int,width: Int,height:Int) -> URL? {
        
        guard let gifDir = getGifDirectoryURL() else {
            return nil
        }
        
        let fileName = UUID().uuidString + ".gif"
        let outputURL = gifDir.appendingPathComponent(fileName)
        
        let duration = endTime - startTime
        let fps = 12
        
        let width = width
        let height = height
        
       // Use more appropriate parameters (GIF does not support video parameters such as b:v / g:v)
       // flags=lanczos improves clarity
        let cmd = """
        -y -ss \(startTime) -t \(duration) -i "\(videoURL.path)" \
        -vf "fps=\(fps),scale=\(width):\(height):flags=lanczos" \
        "\(outputURL.path)"
        """
        
        print("🎬 FFmpeg command:\n\(cmd)")
        
        FFmpegKit.executeAsync(cmd) { session in
            let returnCode = session?.getReturnCode()
            if ReturnCode.isSuccess(returnCode) {
                print("🎉 GIF created at: \(outputURL.path)")
            } else {
                print("❌ GIF generate failed: \(session?.getAllLogsAsString() ?? "")")
            }
        }
        
        return outputURL
    }
    
    private func getGifDirectoryURL() -> URL? {
        let docURL = FileManager.default.urls(for: .documentDirectory,
                                              in: .userDomainMask).first!
        
        let gifDir = docURL.appendingPathComponent("gifwatchfaces")
        
        if !FileManager.default.fileExists(atPath: gifDir.path) {
            do {
                try FileManager.default.createDirectory(at: gifDir,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch {
                print("❌ Create gif directory failed: \(error)")
                return nil
            }
        }
        
        return gifDir
    }
}


