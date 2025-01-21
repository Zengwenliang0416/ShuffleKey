import SwiftUI
import Combine

class KeyboardViewModel: ObservableObject {
    // MARK: - Published properties
    @Published private(set) var keys: [Key] = []
    @Published var inputText: String = ""
    @Published var isShuffling: Bool = false
    @Published var displayText: String = ""  // 用于显示的文本（可能包含掩码）
    @Published var isPasswordMode: Bool = false  // 添加密码模式状态
    
    // MARK: - Properties
    var config: KeyboardConfig  // 改为可变
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(config: KeyboardConfig = KeyboardConfig()) {
        self.config = config
        setupKeys()
        setupBindings()
    }
    
    // MARK: - Public methods
    func togglePasswordMode() {
        isPasswordMode.toggle()
        config.inputMode = isPasswordMode ? .password : .normal
        updateDisplayText()
    }
    
    func shuffleKeys() {
        guard !isShuffling else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isShuffling = true
            
            let currentValues = Set(keys.map { $0.value })
            var newKeys = keys
            repeat {
                newKeys.shuffle()
            } while !isValidShuffle(newKeys) || Set(newKeys.map { $0.value }) != currentValues
            
            keys = newKeys
            
            if config.hapticEnabled {
                FeedbackGenerator.shared.generateFeedback(style: .rigid)
            }
            
            isShuffling = false
        }
    }
    
    func appendCharacter(_ char: String) {
        guard inputText.count < config.maxPasswordLength else { return }
        
        inputText.append(char)
        updateDisplayText()
        
        if config.hapticEnabled {
            FeedbackGenerator.shared.generateFeedback(style: .light)
        }
        if config.soundEnabled {
            FeedbackGenerator.shared.playKeySound()
        }
    }
    
    func deleteCharacter() {
        guard !inputText.isEmpty else { return }
        inputText.removeLast()
        updateDisplayText()
        
        if config.hapticEnabled {
            FeedbackGenerator.shared.generateFeedback(style: .medium)
        }
    }
    
    func clearText() {
        inputText = ""
        updateDisplayText()
        
        if config.hapticEnabled {
            FeedbackGenerator.shared.generateFeedback(style: .heavy)
        }
    }
    
    // MARK: - Private methods
    private func setupKeys() {
        let characters = config.characterSet.characters
        keys = characters.enumerated().map { Key(id: $0, value: $1) }
    }
    
    private func setupBindings() {
        // 监听输入文本变化，更新显示文本
        $inputText
            .sink { [weak self] _ in
                self?.updateDisplayText()
            }
            .store(in: &cancellables)
    }
    
    private func updateDisplayText() {
        switch config.inputMode {
        case .normal:
            displayText = inputText
        case .password:
            displayText = String(repeating: config.inputMode.maskCharacter, count: inputText.count)
        }
    }
    
    private func isValidShuffle(_ newKeys: [Key]) -> Bool {
        let changedCount = zip(keys, newKeys)
            .filter { $0.0.value != $0.1.value }
            .count
        return Double(changedCount) / Double(keys.count) >= config.minimumShufflePercentage
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