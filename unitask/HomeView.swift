import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black // Fondo negro
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        headerSection
                        buttonsSection
                        calendarSection
                        Spacer()
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Inicio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        // Botón de notificaciones
                        Button(action: {}) {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.white)
                        }
                        
                        // Botón de configuración
                        Button(action: {}) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Componentes
    
    private var headerSection: some View {
        HStack {
            NavigationLink(destination: ProfileView()) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Buscar...", text: .constant(""))
                    .foregroundColor(.white) // Texto blanco para contraste con fondo negro
            }
            .padding(10)
            .background(Color(.systemGray))
            .cornerRadius(10)
            .padding(.horizontal, 10)
        }
        .padding(.horizontal)
    }
    
    private var buttonsSection: some View {
        HStack(spacing: 20) {
            NavigationLink(destination: SleepTrackerView()) {
                VStack {
                    Image(systemName: "moon.zzz.fill")
                        .font(.system(size: 28))
                        .padding(15)
                        .background(Color.blue.opacity(0.2))
                        .clipShape(Circle())
                    Text("Sueño")
                        .font(.caption)
                }
                .foregroundColor(.white) // Texto blanco para contraste
            }
            
            NavigationLink(destination: ScheduleView()) {
                VStack {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 28))
                        .padding(15)
                        .background(Color.orange.opacity(0.2))
                        .clipShape(Circle())
                    Text("Horario")
                        .font(.caption)
                }
                .foregroundColor(.white) // Texto blanco para contraste
            }
        }
        .padding(.vertical)
    }
    
    private var calendarSection: some View {
        VStack {
            Text("CALENDARIO")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white) // Texto blanco para contraste
                .padding(.top, 10)
            
            calendarHeader
            
            HStack(spacing: 0) {
                ForEach(["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"], id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.purple.opacity(0.7)) // Cambié el color a un púrpura más oscuro
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .cornerRadius(8)
            .padding(.horizontal, 16)
            
            // Calendario dinámico con eventos
            calendarDays
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.purple.opacity(0.3)) // Cambié el fondo del calendario a un púrpura oscuro
        )
        .padding(.horizontal)
    }
    
    private var calendarHeader: some View {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let currentMonth = dateFormatter.string(from: Date())
        
        return Text(currentMonth.capitalized)
            .font(.headline)
            .foregroundColor(.white) // Texto blanco para contraste
            .padding(.bottom, 10)
    }
    
    // Vista para los días del calendario con eventos
    private var calendarDays: some View {
        let daysInMonth = getDaysInMonth(for: selectedDate)
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
            ForEach(daysInMonth, id: \.self) { day in
                VStack {
                    Text("\(day)")
                        .font(.title2)
                        .padding(10)
                        .background(Circle().fill(Color.purple.opacity(0.2))) // Cambié el color a púrpura claro
                        .foregroundColor(.white) // Texto blanco para contraste
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            // Acción al seleccionar un día
                            selectedDate = getDate(for: day)
                        }
                    
                    // Aquí podrías agregar actividades o eventos relacionados con el día
                    Text("Actividad")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(5)
                        .transition(.opacity) // Animación suave de la actividad
                }
                .padding(.vertical, 5)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: selectedDate) // Animación suave al cambiar la fecha
    }
    
    private func getDaysInMonth(for date: Date) -> [Int] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.compactMap { $0 } ?? []
    }
    
    private func getDate(for day: Int) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: Date())
        return calendar.date(bySetting: .day, value: day, of: calendar.date(from: components)!) ?? Date()
    }
}

// Vistas placeholder para las pantallas de destino
struct ProfileView: View {
    var body: some View {
        Text("Pantalla de Perfil")
            .navigationTitle("Mi Perfil")
    }
}

struct ScheduleView: View {
    var body: some View {
        Text("Pantalla de Horario")
            .navigationTitle("Horario")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
