//
//  AnimatedWeatherIcon.swift
//  NicolasCast
//

import SwiftUI

struct AnimatedWeatherIcon: View {
    
    let sfSymbolName: String
    let weatherConditionId: Int
    let size: CGFloat
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Image(systemName: sfSymbolName)
                .font(.system(size: size, weight: .medium))
                .foregroundStyle(glowColor)
                .blur(radius: 20)
                .opacity(0.5)
                .scaleEffect(isAnimating ? 1.1 : 0.9)
            
            mainIcon
        }
        .onAppear {
            startAnimation()
        }
    }
    
    @ViewBuilder
    private var mainIcon: some View {
        let baseIcon = Image(systemName: sfSymbolName)
            .font(.system(size: size, weight: .medium))
            .symbolRenderingMode(renderingMode)
            .foregroundStyle(iconColor)
        
        switch weatherConditionId {
        case 800:
            baseIcon
                .scaleEffect(isAnimating ? 1.08 : 0.95)
                .rotationEffect(.degrees(isAnimating ? 5 : -5))
            
        case 801...804:
            baseIcon
                .offset(x: isAnimating ? 8 : -8, y: isAnimating ? 2 : -2)
                .scaleEffect(isAnimating ? 1.02 : 0.98)
            
        case 500...599, 300...399:
            baseIcon
                .offset(y: isAnimating ? -3 : 3)
            
        case 200...299:
            baseIcon
                .opacity(isAnimating ? 1.0 : 0.7)
                .scaleEffect(isAnimating ? 1.05 : 1.0)
            
        case 600...699:
            baseIcon
                .rotationEffect(.degrees(isAnimating ? 10 : -10))
                .scaleEffect(isAnimating ? 1.03 : 0.97)
            
        default:
            baseIcon
                .scaleEffect(isAnimating ? 1.05 : 0.95)
        }
    }
    
    private var renderingMode: SymbolRenderingMode {
        switch sfSymbolName {
        case "sun.max.fill", "cloud.sun.fill", "cloud.sun.rain.fill":
            return .multicolor
        default:
            return .hierarchical
        }
    }
    
    private var iconColor: Color {
        .white
    }
    
    private var glowColor: Color {
        switch weatherConditionId {
        case 800: return .yellow
        case 500...599: return .blue
        case 200...299: return .purple
        case 600...699: return .cyan
        default: return .white
        }
    }
    
    private func startAnimation() {
        withAnimation(.easeInOut(duration: animationDuration).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
    }
    
    private var animationDuration: Double {
        switch weatherConditionId {
        case 800: return 2.0
        case 801...804: return 4.0
        case 500...599: return 1.0
        case 200...299: return 0.5
        default: return 2.5
        }
    }
}

struct FloatingClouds: View {
    
    @State private var offset1: CGFloat = -200
    @State private var offset2: CGFloat = 300
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(systemName: "cloud.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.15))
                    .offset(x: offset1, y: geometry.size.height * 0.15)
                
                Image(systemName: "cloud.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white.opacity(0.1))
                    .offset(x: offset2, y: geometry.size.height * 0.25)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                offset1 = 400
            }
            withAnimation(.linear(duration: 25).repeatForever(autoreverses: false)) {
                offset2 = -300
            }
        }
    }
}

#if DEBUG
struct AnimatedWeatherIcon_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.opacity(0.8).ignoresSafeArea()
            
            VStack(spacing: 40) {
                AnimatedWeatherIcon(sfSymbolName: "sun.max.fill", weatherConditionId: 800, size: 80)
                AnimatedWeatherIcon(sfSymbolName: "cloud.fill", weatherConditionId: 803, size: 80)
                AnimatedWeatherIcon(sfSymbolName: "cloud.rain.fill", weatherConditionId: 500, size: 80)
            }
        }
    }
}
#endif
