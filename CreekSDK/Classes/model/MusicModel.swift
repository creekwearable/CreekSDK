//
//  MusicModel.swift
//  CreekSDK_Example
//
//  Created by bean on 2025/4/14.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation

public enum AudioType: Int, Codable {
    case aac = 0
    case m4a
    case wav
    case mp1
    case mp2
    case mp3
    case ape
    case wma
    case flac
}

public class CreekMusicModel: Codable {
   public var songName: String?
   public var singer: String?
   public var audioType: AudioType?

   public init(songName: String? = nil, singer: String? = nil, audioType: AudioType? = nil) {
      self.songName = songName
      self.singer = singer
      self.audioType = audioType
   }
   
}

