import UIKit
import AudioToolbox

class FeedbackGenerator {
    static let shared = FeedbackGenerator()
    
    private init() {}
    
    func generateFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func playKeySound() {
        // 使用系统按键音效 1104
        AudioServicesPlaySystemSound(1104)
    }
} 