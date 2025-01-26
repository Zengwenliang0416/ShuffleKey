import SwiftUI

struct KeyboardSettingsView: View {
    @StateObject private var settings = KeyboardSettings.shared
    
    var body: some View {
        Form {
            Section(header: Text("按钮设置")) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("按钮点击区域大小")
                        Spacer()
                        Text("\(Int(settings.buttonTapAreaSize))")
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(
                        value: $settings.buttonTapAreaSize,
                        in: settings.minTapAreaSize...settings.maxTapAreaSize,
                        step: 1.0
                    )
                    
                    // 预览示例按钮
                    Button(action: {}) {
                        Text("示例按钮")
                            .frame(width: settings.buttonTapAreaSize, height: settings.buttonTapAreaSize)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)
                }
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("键盘设置")
    }
} 