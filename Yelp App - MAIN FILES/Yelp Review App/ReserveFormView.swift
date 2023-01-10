//
//  ReserveFormView.swift
//  Yelp Review App
//
//  Created by Steve Regala on 12/8/22.
//

import SwiftUI

extension View {
    func emailValidToast<Content>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View where Content: View {
        EmailValidToast(
            isPresented: isPresented,
            presenter: { self },
            content: content
        )
    }
}


// CITATION on email validation: https://stackoverflow.com/questions/59988892/swiftui-email-validation
struct ReserveFormView: View {
    
    @AppStorage("Reservation") var reserve: Data = Data()
    
    @Environment(\.dismiss) var dismiss
    
    var id: String
    @State private var hour = "10"
    @State private var min = "00"
    var hourSelect = ["10", "11", "12", "13", "14", "15", "16", "17"]
    var minSelect = ["00", "15", "30", "45",]
    @State private var date = Date()
    
    @State private var email = ""
    @State private var emailString  : String = ""
    @State private var isValidEmail : Bool = false
    @State private var showEmailError : Bool = false
    @State private var showSuccess : Bool = false
    
    
    init(id:String){
        self.id = id
    }
    
    var body: some View {
        
        VStack{
            if !showSuccess{
                List{
                    Section{
                        HStack{
                            Spacer()
                            Text("Reservation Form").font(.title).bold()
                            Spacer()
                        }
                    }
                    Section{
                        HStack{
                            Spacer()
                            Text(all_details[id]!.name).font(.system(size: 25)).bold()
                            //Text("SpudNuts Donuts").font(.system(size: 25)).bold()
                            Spacer()
                        }
                    }
                    Section{
                        VStack{
                            HStack{
                                // CITATION for email validation: https://stackoverflow.com/questions/59988892/swiftui-email-validation
                                Text("Email: ").foregroundColor(.gray).font(.system(size: 15))
                                TextField("", text:$email)
                            }
                        }.padding(.top, 8).padding(.bottom, 8)
                        VStack{
                            HStack{
                                Text("Date/Time: ").foregroundColor(.gray).font(.system(size: 15))
                                Spacer()
                                DatePicker(
                                    "",
                                    selection: $date,
                                    in: Date.now...,
                                    displayedComponents: [.date]
                                ).labelsHidden()
                                Spacer()
                                Picker("", selection: $hour){
                                    ForEach(hourSelect, id: \.self){
                                        Text($0)
                                    }
                                }.pickerStyle(.menu).labelsHidden().buttonStyle(.bordered).accentColor(.black).frame(width:40).clipped().cornerRadius(2).opacity(0.50)
                                Text(":")
                                Picker("", selection: $min){
                                    ForEach(minSelect, id: \.self){
                                        Text($0)
                                    }
                                }.pickerStyle(.menu).labelsHidden().buttonStyle(.bordered).accentColor(.black).frame(width:40).clipped().cornerRadius(2).opacity(0.50)
                            }
                        }.padding(.top, 8).padding(.bottom, 8)
                        VStack{
                            HStack{
                                Spacer()
                                Button(action:{
                                    print("Submit Reserve")
                                    if textFieldValidatorEmail(email){
                                        isValidEmail = true
                                        showSuccess.toggle()
                                        
                                        // Store in local storage: Name, Date, Time, Email
                                        // check if local storage variable is empty, otherwise fill it up with new one
                                        if self.reserve.isEmpty{
                                            let resDate = date.formatted(date: .numeric, time: .omitted)
                                            let resTime = "\(hour):\(min)"
                                            let resArray = [all_details[id]?.name, resDate, resTime, email]
                                            let final_data = [id: resArray]
                                            guard let reserve = try? JSONEncoder().encode(final_data) else { return }
                                            self.reserve = reserve
                                        }else{
                                            let resDate = date.formatted(date: .numeric, time: .omitted)
                                            let resTime = "\(hour):\(min)"
                                            let resArray = [all_details[id]!.name, resDate, resTime, email]
                                            guard var decodedReserve = try? JSONDecoder().decode([String:[String]].self, from: reserve) else { print("RETURNED"); return }
                                            decodedReserve[id] = resArray
                                            guard let reserve = try? JSONEncoder().encode(decodedReserve) else { return }
                                            self.reserve = reserve
                                        }
                                        
                                    }else {
                                        isValidEmail = false
                                        showEmailError.toggle()
                                        email = ""
                                    }
                                }){
                                    Text("Reserve Now")
                                        .padding()
                                        .padding(.horizontal, 12)
                                }
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(15)
                                .buttonStyle(BorderlessButtonStyle())
                                Spacer()
                            }
                        }.padding()
                    }
                }.emailValidToast(isPresented: $showEmailError){
                    Text("Please enter a valid email.")
                }// List
                
            }else{
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Text("Congratulations!").foregroundColor(.white).font(.system(size: 20)).bold()
                        Spacer()
                    }.padding(.bottom)
                    HStack{
                        Spacer()
                        Text("You have successfully made a reservation at \(all_details[id]!.name)").foregroundColor(.white).multilineTextAlignment(.center).font(.system(size: 18))
                        //Text("You have successfully made a reservation at Spudnuts Donuts").foregroundColor(.white).multilineTextAlignment(.center).font(.system(size: 18))
                        Spacer()
                    }
                    Spacer()
                    Button(action:{
                        print("Done")
                        // Toggle reservation form
                        dismiss()
                    }){
                        Text("Done")
                            .padding()
                            .padding(.horizontal, 70)
                    }
                    .foregroundColor(.green)
                    .background(.white)
                    .cornerRadius(30)
                    .buttonStyle(BorderlessButtonStyle())
                    
                }.background(.green)
                    
            }
            
        }
    }
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
}

struct ReserveFormView_Previews: PreviewProvider {
    static var previews: some View {
        ReserveFormView(id:"asdklfjasdklfjklasd")
    }
}
