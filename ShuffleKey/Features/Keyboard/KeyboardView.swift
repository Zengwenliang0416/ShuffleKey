import SwiftUI

struct KeyboardView: View {
    @StateObject private var viewModel: KeyboardViewModel
    @Environment(\.colorScheme) var colorScheme
    
    init(config: KeyboardConfig = KeyboardConfig()) {
        _viewModel = StateObject(wrappedValue: KeyboardViewModel(config: config))
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // 输入框
            TextField("", text: $viewModel.inputText)
                .font(.system(size: 24))
                .multilineTextAlignment(.leading)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // 数字网格
            VStack(spacing: 20) {
                // 7-8-9
                HStack(spacing: 20) {
                    ForEach(viewModel.keys.prefix(3)) { key in
                        NumberButton(key: key) {
                            viewModel.appendCharacter(key.value)
                        }
                    }
                }
                
                // 4-5-6
                HStack(spacing: 20) {
                    ForEach(viewModel.keys.dropFirst(3).prefix(3)) { key in
                        NumberButton(key: key) {
                            viewModel.appendCharacter(key.value)
                        }
                    }
                }
                
                // 1-2-3
                HStack(spacing: 20) {
                    ForEach(viewModel.keys.dropFirst(6).prefix(3)) { key in
                        NumberButton(key: key) {
                            viewModel.appendCharacter(key.value)
                        }
                    }
                }
                
                // 0 和 .
                HStack(spacing: 20) {
                    // 获取最后两个按钮
                    ForEach(viewModel.keys.dropFirst(9)) { key in
                        NumberButton(key: key) {
                            viewModel.appendCharacter(key.value)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // 功能按钮
            HStack(spacing: 40) {
                // 打乱按钮
                Button(action: viewModel.shuffleKeys) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .disabled(viewModel.isShuffling)
                
                // 删除按钮
                Button(action: viewModel.deleteCharacter) {
                    Image(systemName: "xmark")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.red)
                        .clipShape(Circle())
                }
                
                // 清空按钮
                Button(action: viewModel.clearText) {
                    Image(systemName: "xmark")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.gray)
                        .clipShape(Circle())
                }
            }
            .padding(.bottom, 30)
        }
    }
}

// MARK: - NumberButton
struct NumberButton: View {
    let key: Key
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(key.value)
                .font(.system(size: 32, weight: .regular))
                .foregroundColor(.black)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(Circle())
        }
    }
}

#Preview {
    KeyboardView()
        .preferredColorScheme(.light)
} 