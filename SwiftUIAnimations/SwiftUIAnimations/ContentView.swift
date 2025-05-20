//
//  ContentView.swift
//  SwiftUIAnimations
//
//  Created by Mehrooz on 20/05/2025.
//

import SwiftUI

// Breathing Circle
struct BreathingCircle: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Circle()
            .frame(width: 80, height: 80)
            .foregroundColor(.blue)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    scale = 1.2
                }
            }
    }
}

// Ripple Button
struct RippleButton: View {
    @State private var isTapped = false
    @State private var rippleScale: CGFloat = 0.0
    @State private var rippleOpacity: Double = 1.0
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue.opacity(0.2))
                .scaleEffect(rippleScale)
                .opacity(rippleOpacity)
            
            Text("Tap")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(Circle().foregroundColor(.blue))
                .scaleEffect(isTapped ? 0.9 : 1.0)
        }
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.4)) {
                isTapped = true
            }
            withAnimation(.easeOut(duration: 0.6)) {
                rippleScale = 2.0
                rippleOpacity = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation {
                    isTapped = false
                    rippleScale = 0.0
                    rippleOpacity = 1.0
                }
            }
        }
    }
}

// Flip Card
struct FlipCard: View {
    @State private var isFlipped = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 120, height: 180)
                .foregroundColor(.blue)
                .overlay(
                    Text("Front")
                        .font(.title2)
                        .foregroundColor(.white)
                )
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
                .opacity(isFlipped ? 0 : 1)
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 120, height: 180)
                .foregroundColor(.red)
                .overlay(
                    Text("Back")
                        .font(.title2)
                        .foregroundColor(.white)
                )
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -180),
                    axis: (x: 0, y: 1, z: 0)
                )
                .opacity(isFlipped ? 1 : 0)
        }
        .onTapGesture {
            withAnimation(.spring()) {
                isFlipped.toggle()
            }
        }
    }
}

// Wave Animation
struct Wave: Shape {
    var offset: CGFloat
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let waveHeight: CGFloat = 20
        let frequency: CGFloat = 0.02
        
        path.move(to: CGPoint(x: 0, y: rect.midY))
        
        for x in stride(from: 0, to: rect.width, by: 1) {
            let y = rect.midY + sin(CGFloat(x) * frequency + offset) * waveHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

struct WaveAnimation: View {
    @State private var offset: CGFloat = 0
    
    var body: some View {
        Wave(offset: offset)
            .fill(.blue)
            .frame(height: 100)
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    offset = 2 * .pi
                }
            }
    }
}

// Combined Animation View
struct CombinedAnimationsView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("SwiftUI Animation Showcase")
                .font(.title)
                .fontWeight(.bold)
            
            HStack(spacing: 20) {
                VStack {
                    Text("Breathing Circle")
                        .font(.headline)
                    BreathingCircle()
                }
                
                VStack {
                    Text("Ripple Button")
                        .font(.headline)
                    RippleButton()
                }
            }
            
            HStack(spacing: 20) {
                VStack {
                    Text("Flip Card")
                        .font(.headline)
                    FlipCard()
                }
                
                VStack {
                    Text("Wave Animation")
                        .font(.headline)
                    WaveAnimation()
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct CombinedAnimationsView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedAnimationsView()
    }
}
