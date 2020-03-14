//
//  GAFilePathManager.swift
//  Need
//
//  Created by houjianan on 2020/3/14.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation

class GAFilePathManager {
    
    public func filePath(name: String = "audio_yy") -> String {
        let path = NSHomeDirectory() + "/Documents/audio_yy"
        
        if !FileManager.default.fileExists(atPath: path) {
            try! FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }

        return path
    }
    
    public func filesCount(fileName: String = "") -> Int {
        let path = filePath()
        do {
            let arr = try FileManager.default.contentsOfDirectory(atPath: path)
            return arr.count
        } catch {
            return 0
        }
    }
    
    public func catchFilePath() -> String {
        return NSTemporaryDirectory()
    }
    
    public func copy(at: URL, to: URL) -> Bool {
        do {
            try FileManager.default.copyItem(at: at, to: to)
            return true
        } catch {
            return false
        }
    }
}
