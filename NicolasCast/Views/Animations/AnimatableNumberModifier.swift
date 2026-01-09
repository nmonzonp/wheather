//
//  AnimatableNumberModifier.swift
//  NicolasCast
//

import SwiftUI

struct AnimatableNumberModifier: AnimatableModifier {
    
    var value: Double
    let fontSize: CGFloat
    let fontWeight: Font.Weight
    let suffix: String
    
    var animatableData: Double {
        get { value }
        set { value = newValue }
    }
    
    func body(content: Content) -> some View {
        content.overlay(
            Text("\(Int(value))\(suffix)")
                .font(.system(size: fontSize, weight: fontWeight, design: .rounded))
                .foregroundColor(.white)
        )
    }
}

extension View {
    func animatingNumber(
        _ value: Double,
        fontSize: CGFloat = 72,
        fontWeight: Font.Weight = .thin,
        suffix: String = "°"
    ) -> some View {
        self.modifier(
            AnimatableNumberModifier(
                value: value,
                fontSize: fontSize,
                fontWeight: fontWeight,
                suffix: suffix
            )
        )
    }
}

struct AnimatedTemperatureView: View {
    
    let temperature: Double
    let fontSize: CGFloat
    let fontWeight: Font.Weight
    
    @State private var displayedValue: Double = 0
    
    var body: some View {
        Color.clear
            .frame(height: fontSize * 1.2)
            .animatingNumber(displayedValue, fontSize: fontSize, fontWeight: fontWeight, suffix: "°")
            .onAppear {
                withAnimation(.easeOut(duration: 1.2)) {
                    displayedValue = temperature
                }
            }
            .onChange(of: temperature) { newValue in
                withAnimation(.easeOut(duration: 0.8)) {
                    displayedValue = newValue
                }
            }
    }
}

struct AnimatedMinMaxView: View {
    
    let minTemp: Double
    let maxTemp: Double
    
    @State private var displayedMin: Double = 0
    @State private var displayedMax: Double = 0
    
    var body: some View {
        HStack(spacing: 24) {
            HStack(spacing: 4) {
                Image(systemName: "arrow.down")
                    .font(.system(size: 14, weight: .semibold))
                Text("L:")
                Color.clear
                    .frame(width: 40, height: 20)
                    .animatingNumber(displayedMin, fontSize: 18, fontWeight: .semibold, suffix: "°")
            }
            
            HStack(spacing: 4) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 14, weight: .semibold))
                Text("H:")
                Color.clear
                    .frame(width: 40, height: 20)
                    .animatingNumber(displayedMax, fontSize: 18, fontWeight: .semibold, suffix: "°")
            }
        }
        .font(.system(size: 18, weight: .medium))
        .foregroundColor(.white.opacity(0.8))
        .onAppear {
            withAnimation(.easeOut(duration: 1.0).delay(0.3)) {
                displayedMin = minTemp
                displayedMax = maxTemp
            }
        }
        .onChange(of: minTemp) { newValue in
            withAnimation(.easeOut(duration: 0.6)) {
                displayedMin = newValue
            }
        }
        .onChange(of: maxTemp) { newValue in
            withAnimation(.easeOut(duration: 0.6)) {
                displayedMax = newValue
            }
        }
    }
}

#if DEBUG
struct AnimatableNumber_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            
            VStack(spacing: 32) {
                AnimatedTemperatureView(temperature: 25, fontSize: 72, fontWeight: .thin)
                AnimatedMinMaxView(minTemp: 18, maxTemp: 28)
            }
        }
    }
}
#endif
