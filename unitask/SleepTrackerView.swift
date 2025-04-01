import SwiftUI

struct SleepTrackerView: View {
    @State private var sleepTime: Date = Date()
    @State private var wakeUpTime: Date = Date().addingTimeInterval(8 * 3600) // 8 horas por defecto
    @State private var recommendedWakeTimes: [Date] = []
    @State private var showResults: Bool = false
    @State private var selectedCycle: Int? = nil
    @State private var showInfoSheet: Bool = false
    
    // Configuración de colores para modo oscuro
    private let primaryColor = Color(red: 0.38, green: 0.81, blue: 0.83) // Turquesa
    private let secondaryColor = Color(red: 0.58, green: 0.37, blue: 0.92) // Morado
    private let backgroundColor = Color(red: 0.1, green: 0.1, blue: 0.15) // Fondo oscuro
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 25) {
                    // Header con animación
                    headerSection
                    
                    // Selectores de tiempo
                    timeSelectionSection
                    
                    // Botón de cálculo
                    calculateButton
                    
                    // Resultados
                    resultsSection
                    
                    // Información adicional
                    infoSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
            }
        }
        .sheet(isPresented: $showInfoSheet) {
            infoSheet
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Componentes de la vista
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("CICLO DE SUEÑO")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(primaryColor)
                .shadow(color: primaryColor.opacity(0.3), radius: 10, x: 0, y: 5)
            
            Text("Optimiza tu sueño REM")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var timeSelectionSection: some View {
        VStack(spacing: 20) {
            // Selector de hora para dormir
            timePicker(title: "Hora de dormir", selection: $sleepTime, accentColor: primaryColor)
            
            // Selector de hora para despertar
            timePicker(title: "Hora de despertar", selection: $wakeUpTime, accentColor: secondaryColor)
        }
    }
    
    private func timePicker(title: String, selection: Binding<Date>, accentColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .padding(.leading, 5)
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(white: 0.2))
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                
                DatePicker("", selection: selection, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .accentColor(accentColor)
                    .padding(.horizontal, 10)
            }
            .frame(height: 150)
        }
    }
    
    private var calculateButton: some View {
        Button(action: {
            withAnimation(.spring(dampingFraction: 0.6)) {
                calculateSleepCycles()
                showResults = true
            }
            // Feedback háptico
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }) {
            HStack {
                Image(systemName: "moon.zzz.fill")
                Text("Calcular Ciclos")
            }
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [primaryColor, secondaryColor]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(15)
            .shadow(color: primaryColor.opacity(0.4), radius: 10, x: 0, y: 5)
        }
    }
    
    private var resultsSection: some View {
        Group {
            if showResults && !recommendedWakeTimes.isEmpty {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Horas óptimas para despertar")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                showResults.toggle()
                            }
                        }) {
                            Image(systemName: "chevron.up")
                                .rotationEffect(.degrees(showResults ? 0 : 180))
                        }
                    }
                    
                    ForEach(0..<recommendedWakeTimes.count, id: \.self) { index in
                        let time = recommendedWakeTimes[index]
                        let cycleNumber = index + 1
                        
                        wakeTimeCard(cycleNumber: cycleNumber, time: time, isSelected: selectedCycle == cycleNumber)
                            .onTapGesture {
                                withAnimation {
                                    selectedCycle = selectedCycle == cycleNumber ? nil : cycleNumber
                                }
                            }
                    }
                }
                .padding()
                .background(Color(white: 0.15))
                .cornerRadius(15)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
    }
    
    private func wakeTimeCard(cycleNumber: Int, time: Date, isSelected: Bool) -> some View {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Ciclo \(cycleNumber)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                Text(formatter.string(from: time))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(isSelected ? primaryColor : .white)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(primaryColor)
                    .transition(.scale)
            }
            
            Text("\(cycleNumber * 90) min")
                .font(.caption)
                .padding(6)
                .background(Color(white: 0.3))
                .cornerRadius(5)
        }
        .padding()
        .background(isSelected ? Color(white: 0.25) : Color(white: 0.2))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
    }
    
    private var infoSection: some View {
        Button(action: {
            showInfoSheet = true
        }) {
            HStack {
                Image(systemName: "info.circle")
                Text("¿Cómo funcionan los ciclos de sueño?")
            }
            .font(.caption)
            .foregroundColor(.white.opacity(0.6))
        }
    }
    
    private var infoSheet: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Optimiza tu sueño")
                        .font(.title)
                        .foregroundColor(primaryColor)
                    
                    Text("""
                    Un ciclo de sueño completo dura aproximadamente **90 minutos** y consta de varias etapas, incluyendo el sueño REM (Movimiento Rápido de Ojos), que es crucial para la memoria y el descanso mental.
                    
                    Despertarse al final de un ciclo de sueño, en lugar de en medio de uno, te hará sentir más descansado y alerta.
                    
                    **Recomendaciones:**
                    - Intenta dormir entre **4-6 ciclos** completos (6-9 horas)
                    - Los ciclos 1-3 son los más reparadores
                    - Evita interrumpir el sueño profundo
                    """)
                    .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                }
                .padding()
            }
            .background(backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationTitle("Información")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Listo") {
                        showInfoSheet = false
                    }
                    .foregroundColor(primaryColor)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Lógica
    
    private func calculateSleepCycles() {
        let cycleDuration: TimeInterval = 90 * 60 // 90 minutos en segundos
        let numberOfCycles = 6 // Se recomiendan 4 a 6 ciclos
        var results: [Date] = []
        
        for cycle in 1...numberOfCycles {
            let wakeTime = sleepTime.addingTimeInterval(Double(cycle) * cycleDuration)
            results.append(wakeTime)
        }
        
        recommendedWakeTimes = results
        selectedCycle = nil
    }
}

// MARK: - Previews

struct SleepTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        SleepTrackerView()
    }
}
