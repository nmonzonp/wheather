//
//  AnimatedBackground.swift
//  NicolasCast
//

import SwiftUI

struct BreathingBackground: View {
    
    @State private var animate = false
    
    let weatherConditionId: Int
    let isDaytime: Bool
    
    var body: some View {
        ZStack {
            baseGradient
            
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(primaryColor.opacity(0.6))
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                        .blur(radius: 80)
                        .offset(
                            x: animate ? -geometry.size.width * 0.2 : geometry.size.width * 0.2,
                            y: animate ? -geometry.size.height * 0.15 : geometry.size.height * 0.15
                        )
                    
                    Circle()
                        .fill(secondaryColor.opacity(0.5))
                        .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.6)
                        .blur(radius: 100)
                        .offset(
                            x: animate ? geometry.size.width * 0.15 : -geometry.size.width * 0.15,
                            y: animate ? geometry.size.height * 0.2 : -geometry.size.height * 0.1
                        )
                    
                    Circle()
                        .fill(accentColor.opacity(0.4))
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5)
                        .blur(radius: 120)
                        .offset(
                            x: animate ? -geometry.size.width * 0.1 : geometry.size.width * 0.1,
                            y: animate ? geometry.size.height * 0.25 : -geometry.size.height * 0.05
                        )
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
    
    private var baseGradient: LinearGradient {
        LinearGradient(
            colors: gradientColors,
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var gradientColors: [Color] {
        switch weatherConditionId {
        case 200...299:
            return [Color(hex: "1a1a2e"), Color(hex: "4a4e69")]
        case 300...399, 500...599:
            return isDaytime
                ? [Color(hex: "4a5568"), Color(hex: "718096")]
                : [Color(hex: "2d3748"), Color(hex: "4a5568")]
        case 600...699:
            return [Color(hex: "e2e8f0"), Color(hex: "a0aec0")]
        case 700...799:
            return [Color(hex: "9ca3af"), Color(hex: "d1d5db")]
        case 800:
            return isDaytime
                ? [Color(hex: "0369a1"), Color(hex: "7dd3fc")]
                : [Color(hex: "1e3a5f"), Color(hex: "312e81")]
        case 801...804:
            return isDaytime
                ? [Color(hex: "475569"), Color(hex: "94a3b8")]
                : [Color(hex: "374151"), Color(hex: "4b5563")]
        default:
            return [Color(hex: "3b82f6"), Color(hex: "60a5fa")]
        }
    }
    
    private var primaryColor: Color {
        switch weatherConditionId {
        case 200...299: return Color(hex: "6366f1")
        case 300...599: return Color(hex: "3b82f6")
        case 600...699: return Color(hex: "e0f2fe")
        case 800: return isDaytime ? Color(hex: "fbbf24") : Color(hex: "6366f1")
        default: return Color(hex: "60a5fa")
        }
    }
    
    private var secondaryColor: Color {
        switch weatherConditionId {
        case 200...299: return Color(hex: "8b5cf6")
        case 300...599: return Color(hex: "6366f1")
        case 600...699: return Color(hex: "c7d2fe")
        case 800: return isDaytime ? Color(hex: "fb923c") : Color(hex: "8b5cf6")
        default: return Color(hex: "818cf8")
        }
    }
    
    private var accentColor: Color {
        switch weatherConditionId {
        case 200...299: return Color(hex: "ec4899")
        case 300...599: return Color(hex: "06b6d4")
        case 600...699: return Color(hex: "a5b4fc")
        case 800: return isDaytime ? Color(hex: "fef08a") : Color(hex: "c084fc")
        default: return Color(hex: "a78bfa")
        }
    }
}

struct DefaultBreathingBackground: View {
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "0369a1"), Color(hex: "7dd3fc")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.width * 0.7)
                        .blur(radius: 80)
                        .offset(
                            x: animate ? -geometry.size.width * 0.15 : geometry.size.width * 0.15,
                            y: animate ? -geometry.size.height * 0.1 : geometry.size.height * 0.1
                        )
                    
                    Circle()
                        .fill(Color(hex: "60a5fa").opacity(0.3))
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5)
                        .blur(radius: 100)
                        .offset(
                            x: animate ? geometry.size.width * 0.1 : -geometry.size.width * 0.1,
                            y: animate ? geometry.size.height * 0.15 : -geometry.size.height * 0.05
                        )
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

#if DEBUG
struct AnimatedBackground_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BreathingBackground(weatherConditionId: 800, isDaytime: true)
                .previewDisplayName("Clear Day")
            
            BreathingBackground(weatherConditionId: 500, isDaytime: true)
                .previewDisplayName("Rain")
            
            BreathingBackground(weatherConditionId: 800, isDaytime: false)
                .previewDisplayName("Clear Night")
        }
    }
}
#endif
