import Foundation

struct KeyboardConfig {
    enum LayoutMode {
        case grid3x3
        case grid4x4
        case grid5x5
        
        var columns: Int {
            switch self {
            case .grid3x3: return 3
            case .grid4x4: return 4
            case .grid5x5: return 5
            }
        }
    }
    
    enum CharacterSet {
        case letters
        case numbers
        case symbols
        case custom(Set<String>)
        
        var characters: [String] {
            switch self {
            case .letters:
                return Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map(String.init)
            case .numbers:
                return ["7", "8", "9", "4", "5", "6", "1", "2", "3", "0", "."]  // 标准数字键盘布局
            case .symbols:
                return ["@", "#", "$", "%", "&", "*", "(", ")", "-", "+", "=", "?"]
            case .custom(let chars):
                return Array(chars)
            }
        }
    }
    
    enum InputMode {
        case normal
        case password
        
        var maskCharacter: String {
            switch self {
            case .normal: return ""
            case .password: return "•"
            }
        }
    }
    
    var layoutMode: LayoutMode = .grid3x3
    var characterSet: CharacterSet = .numbers
    var inputMode: InputMode = .normal
    var animationEnabled: Bool = true
    var hapticEnabled: Bool = true
    var soundEnabled: Bool = true
    var minimumShufflePercentage: Double = 0.3
    
    // 新增：密码相关配置
    var maxPasswordLength: Int = 20  // 最大密码长度
    var shouldClearAfterSubmit: Bool = false  // 输入完成后是否自动清空
} 