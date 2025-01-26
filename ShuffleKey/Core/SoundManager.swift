import AudioToolbox
import SwiftUI

class SoundManager {
    static let shared = SoundManager()
    
    private init() {}
    
    // 播放系统声音
    private func playSystemSound(_ soundID: SystemSoundID) {
        AudioServicesPlaySystemSound(soundID)
    }
    
    // 便捷方法
    func playShuffleSound() {
        // 1124: 页面翻动声
        playSystemSound(1124)
    }
    
    func playDeleteSound() {
        // 1155: 删除声
        playSystemSound(1155)
    }
    
    func playClearSound() {
        // 1521: 更清脆的删除声
        playSystemSound(1521)
    }
    
    func playThemeSound() {
        // 1123: 轻点声
        playSystemSound(1123)
    }
} 