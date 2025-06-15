import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 1.0
    @State private var bgOpacity: Double = 1.0
    @State private var showMain = false

    var body: some View {
        ZStack {
            if showMain {
                ContentView() // ✅ Replaces TimerView with ContentView
                    .transition(.opacity)
            } else {
                ZStack {
                    Color(red: 1.0, green: 0.85, blue: 0.85) // Pale red
                        .opacity(bgOpacity)
                        .ignoresSafeArea()

                    Text("🍅")
                        .font(.system(size: 100))
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .shadow(color: .red.opacity(0.4), radius: 20, x: 0, y: 10)
                        .onAppear {
                            // Bounce + fade animation
                            withAnimation(.interpolatingSpring(stiffness: 120, damping: 8)) {
                                logoScale = 1.2
                            }

                            withAnimation(.easeOut(duration: 1.2).delay(0.3)) {
                                logoOpacity = 0.0
                                bgOpacity = 0.0
                            }

                            // Switch to main view
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    showMain = true
                                }
                            }
                        }
                }
            }
        }
    }
}

