import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        Group {
            if isLoggedIn {
                HomeView()
            } else {
                loginContent
            }
        }
    }
    
    private var loginContent: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.yellow)
                    
                    Text("Iniciar Sesión")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 20) {
                        TextField("Correo electrónico", text: $email)
                            .modifier(LoginTextFieldModifier())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Contraseña", text: $password)
                            .modifier(LoginTextFieldModifier())
                    }
                    .padding(.horizontal, 30)
                    
                    Button(action: handleLogin) {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Ingresar")
                                .font(.headline)
                        }
                    }
                    .buttonStyle(LoginButtonStyle())
                    .padding(.horizontal, 30)
                    
                    HStack {
                        Button("¿Olvidaste tu contraseña?") {
                            // Acción para recuperar contraseña
                        }
                        .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button("Crear cuenta") {
                            // Acción para registrar nuevo usuario
                        }
                        .foregroundColor(.blue)
                    }
                    .font(.caption)
                    .padding(.horizontal, 30)
                }
                .padding(.vertical, 50)
            }
        }
        .preferredColorScheme(.dark)
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Por favor ingresa un email válido y contraseña")
        }
    }
    
    private func handleLogin() {
        guard !email.isEmpty, !password.isEmpty else {
            showAlert = true
            return
        }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            isLoggedIn = true
        }
    }
}

// Añade estas estructuras al mismo archivo o en un archivo aparte
struct LoginTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .foregroundColor(.primary)
    }
}

struct LoginButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(configuration.isPressed ? Color.blue.opacity(0.8) : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

// Vista de previsualización
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
