import Foundation
import SwiftUI

class KeyboardSettings: ObservableObject {
    @Published var buttonTapAreaSize: CGFloat = 100.0 // 默认值改为中等大小
    
    // 扩大调节范围
    let minTapAreaSize: CGFloat = 20.0  // 最小值改小
    let maxTapAreaSize: CGFloat = 100.0 // 最大值改大
    
    static let shared = KeyboardSettings()
    
    private init() {}
} 
