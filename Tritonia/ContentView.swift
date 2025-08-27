//
//  ContentView.swift
//  Tritonia
//
//  Created by Jani Päivärinta by using AI-Assisted Programming (ChatGPT and Microsoft Copilot) on 21.3.2025-25.3.2025.
//

import SwiftUI
import Code39

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoginPressed: Bool = false
    @State private var loginMessage: String = ""
    @State private var isLoggedIn: Bool = false

    init() {
        if let savedUsername = UserDefaults.standard.string(forKey: "username"),
           let savedPassword = UserDefaults.standard.string(forKey: "password") {
            _username = State(initialValue: savedUsername)
            _password = State(initialValue: savedPassword)
            _isLoggedIn = State(initialValue: true)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Image("Tritonia-App-Background-Accessibility")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Color("tritoniablue")
                        .frame(height: 60)
                        .ignoresSafeArea(edges: .top)
                    Spacer()
                    VStack {
                        //loginLabel.text = "login".translated()
                        Text("login".translated())
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(Color("tritoniablue"))
                            .padding(.bottom, 40)

                        TextField("username".translated(), text: $username)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                            .padding(.horizontal)

                        SecureField("password".translated(), text: $password)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                            .padding(.horizontal)
                            .padding(.top, 20)

                        Button(action: {
                            if username.isEmpty || password.isEmpty {
                                loginMessage = "loginwasunsuccessful".translated()
                                isLoginPressed = true
                            } else {
                                UserDefaults.standard.set(username, forKey: "username")
                                UserDefaults.standard.set(password, forKey: "password")
                                isLoggedIn = true
                            }
                        }) {
                            Text("loginbutton".translated())
                                .font(.system(size: 18))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("tritoniablue"))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        .padding(.top, 30)
                        .padding(.horizontal)

                        if isLoginPressed {
                            Text(loginMessage)
                                .foregroundColor(.red)
                                .padding(.top, 10)
                        }
                    }
                    .padding(24)
                    .background(RoundedRectangle(cornerRadius: 30).fill(Color("cardBackground")).shadow(radius: 20))
                    .padding(.horizontal, 30)
                    Link(destination: URL(string: "https://www.tritonia.fi/en/librarycard")!) {
                        Text("apply".translated())
                            .font(.system(size: 14))
                            .foregroundColor(Color("tritoniablue"))
                            .underline()
                    }
                    .padding(.top, 36)
                    .padding(8)
                    Spacer()
                }
                .navigationDestination(isPresented: $isLoggedIn) {
                    LoggedInView(isLoggedIn: $isLoggedIn, password: $password, username: $username)
                }
            }
        }
    }
}

struct LoggedInView: View {
    @Binding var isLoggedIn: Bool
    @Binding var password: String
    @Binding var username: String
    @State private var isShowingPassword: Bool = false

    var body: some View {
        VStack {
            Spacer()
            Code39View(username)
                .frame(width: 296, height: 96)
            Text(username)
                .font(.headline)
                .padding(.top, 10)
            Spacer()
            Button(action: { isShowingPassword.toggle() }) {
                Text(isShowingPassword ? "hidepincode".translated() : "showpincode".translated())
                    .font(.system(size: 18))
                    .padding()
                    .background(Color("tritoniablue"))
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            if isShowingPassword {
                Text(password)
                    .padding(.top, 10)
            }
            Button(action: {
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.removeObject(forKey: "password")
                isLoggedIn = false
                username = ""
                password = ""
            }) {
                Text("logout".translated())
                    .font(.system(size: 18))
                    .padding()
                    .background(Color("tritoniablue"))
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .padding(.top, 20)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: ContentView {
        ContentView()
    }
}

extension String {
  func translated() -> String {
      return NSLocalizedString(self, comment: "")
  }

}
