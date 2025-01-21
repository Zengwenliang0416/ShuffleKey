import SwiftUI
import Combine

class KeyboardViewModel: ObservableObject {
    // MARK: - Published properties
    @Published private(set) var keys: [Key] = []
    @Published var inputText: String = ""
    @Published var isShuffling: Bool = false
    
    // MARK: - Properties
    let config: KeyboardConfig
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(config: KeyboardConfig = KeyboardConfig()) {
        self.config = config
        setupKeys()
    }
    
    // MARK: - Public methods
    func shuffleKeys() {
        guard !isShuffling else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isShuffling = true
            
            // 获取当前所有数字值
            let currentValues = Set(keys.map { $0.value })
            
            // 创建新的随机排列，确保使用相同的数字
            var newKeys = keys
            repeat {
                newKeys.shuffle()
                // 检查是否有足够的变化且没有重复数字
            } while !isValidShuffle(newKeys) || Set(newKeys.map { $0.value }) != currentValues
            
            keys = newKeys
            
            if config.hapticEnabled {
                generateHapticFeedback()
            }
            
            isShuffling = false
        }
    }
    
    func appendCharacter(_ char: String) {
        inputText.append(char)
        if config.hapticEnabled {
            generateHapticFeedback()
        }
    }
    
    func deleteCharacter() {
        guard !inputText.isEmpty else { return }
        inputText.removeLast()
    }
    
    func clearText() {
        inputText = ""
    }
    
    // MARK: - Private methods
    private func setupKeys() {
        let characters = config.characterSet.characters
        keys = characters.enumerated().map { Key(id: $0, value: $1) }
    }
    
    private func isValidShuffle(_ newKeys: [Key]) -> Bool {
        let changedCount = zip(keys, newKeys)
            .filter { $0.0.value != $0.1.value }
            .count
        return Double(changedCount) / Double(keys.count) >= config.minimumShufflePercentage
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

// MARK: - Key Model
struct Key: Identifiable, Equatable {
    let id: Int
    let value: String
    
    static func == (lhs: Key, rhs: Key) -> Bool {
        lhs.id == rhs.id && lhs.value == rhs.value
    }
} 