//
//  LoadingView.swift
//  NicolasCast
//

import SwiftUI

struct LoadingView: View {
    
    @State private var isPulsing = false
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isPulsing ? 1.2 : 0.9)
                    .opacity(isPulsing ? 0 : 0.5)
                
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 60, weight: .medium))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
                    .scaleEffect(isPulsing ? 1.05 : 0.95)
            }
            .animation(
                .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                value: isPulsing
            )
            
            VStack(spacing: 8) {
                Text("Loading Weather")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
            }
        }
        .onAppear {
            isPulsing = true
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Loading weather data")
    }
}

#if DEBUG
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .blue.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            LoadingView()
        }
    }
}
#endif
