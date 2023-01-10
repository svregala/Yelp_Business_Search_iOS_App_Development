//
//  BusinessDetail.swift
//  Yelp Review App
//
//  Created by Steve Regala on 12/6/22.
//

import SwiftUI
import Alamofire
import Kingfisher
import SwiftyJSON

extension View {
    func cancelToast<Content>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View where Content: View {
        EmailValidToast(
            isPresented: isPresented,
            presenter: { self },
            content: content
        )
    }
}

// CITATION: https://stackoverflow.com/questions/63090325/how-to-execute-non-view-code-inside-a-swiftui-view
struct ExecuteCodeBusDetail : View {
    init( _ codeToExec: () -> () ) {
        codeToExec()
    }
    
    var body: some View {
        return EmptyView()
    }
}

struct BusinessDetail: View {
    
    @AppStorage("Reservation") var reserve: Data = Data()
    
    var id: String
    var name: String
    var isDetailReady: Bool = true
    @State private var isReserved: Bool = false
    @State private var showResSheet = false
    @State private var showCancel : Bool = false
    
    init(id: String, name:String){
        self.id = id
        self.name = name
        //self.detailInstance = DetailsItem(givenID: id, givenName: name)
        self.isDetailReady = true
    }
    
    var body: some View {
        
        if isDetailReady{
            VStack{
                // NAME
                HStack{
                    Spacer()
                    Text("\(name)").font(.title).bold()
                    //Text("Spud Nuts Donut Factory").font(.title).bold()
                    Spacer()
                }.padding(.bottom, 5).padding(.top, 10)
                
                // ADDRESS and CATEGORY
                HStack{
                    Text("Address").bold()
                    Spacer()
                    Text("Category").bold()
                }.padding(.horizontal)
                
                HStack{
                    Text(all_details[id]!.address).foregroundColor(.gray).fixedSize(horizontal: false, vertical: true).frame(width: 175, alignment: .leading)
                    //Text("123 This is an anddress Los Angeles CA 90007").foregroundColor(.gray).fixedSize(horizontal: false, vertical: true).frame(width: 175, alignment: .leading)
                    Spacer()
                    Text(all_details[id]!.typeCat).foregroundColor(.gray).fixedSize(horizontal: false, vertical: true).frame(width: 175, alignment: .trailing)
                    //Text("Food | Drinks | Food | Drink").foregroundColor(.gray).fixedSize(horizontal: false, vertical: true).frame(width: 175, alignment: .trailing)
                }.padding(.horizontal).padding(.bottom, 5)
                
                // PHONE and PRICE RANGE
                HStack{
                    Text("Phone").bold()
                    Spacer()
                    Text("Price Range").bold()
                }.padding(.horizontal)
                
                HStack{
                    VStack(alignment: .leading){
                        Text(all_details[id]!.phoneNum).foregroundColor(.gray)
                        //Text("(408) 194-2032").foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing){
                        //Text("$$$").bold().foregroundColor(.gray)
                        Text(all_details[id]!.price).foregroundColor(.gray)
                    }
                }.padding(.horizontal).padding(.bottom, 5)
                
                
                // STATUS and YELP URL
                HStack{
                    Text("Status").bold()
                    Spacer()
                    Text("Visit Yelp for more").bold()
                }.padding(.horizontal)
                
                HStack{
                    VStack(alignment: .leading){
                        /*let temp = true
                        if temp{*/
                        if all_details[id]!.status{
                            Text("Open Now").foregroundColor(.green)
                        }else{
                            Text("Closed Now").foregroundColor(.red)
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing){
                        if all_details[id]!.yelpLink.isEmpty{
                        //if true{
                            Text("N/A").foregroundColor(.gray)
                        }else{
                            Button(action: {
                                if let url = URL(string: all_details[id]!.yelpLink){
                                    UIApplication.shared.open(url)
                                }
                            }, label: {
                                Text("Business Link").foregroundColor(.blue)
                            })
                        }
                    }
                }
                .padding(.bottom, 8).padding(.horizontal)
                
                HStack{
                    // business ID exists in the local storage array
                    ExecuteCode{
                        guard let decodedReserve = try? JSONDecoder().decode([String:[String]].self, from: reserve) else { return }
                        DispatchQueue.main.async {
                            isReserved = decodedReserve.keys.contains(id)
                        }
                    }
                    if !isReserved{
                        Button(action:{
                            print("RESERVE NOW")
                            showResSheet.toggle()
                        }){
                            Text("Reserve Now")
                                .padding()
                                .padding(.horizontal, 12)
                        }
                        .foregroundColor(.white)
                        .background(.red)
                        .cornerRadius(15)
                        .buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $showResSheet){
                            ReserveFormView(id: id)
                        }
                    }else{
                        Button(action:{
                            print("CANCEL RESERVATION")
                            // Take out business ID and details out of local storage
                            guard var decodedReserve = try? JSONDecoder().decode([String:[String]].self, from: reserve) else { return }
                            decodedReserve.removeValue(forKey: id)
                            guard let reserve = try? JSONEncoder().encode(decodedReserve) else { return }
                            self.reserve = reserve
                            isReserved = false
                            // Make toast pop up
                            showCancel.toggle()
                        }){
                            Text("Cancel Reservation")
                                .padding()
                                .padding(.horizontal, 12)
                        }
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(15)
                        .buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $showResSheet){
                            ReserveFormView(id: id)
                        }
                    }
                }.padding(.bottom, 8)
                
                HStack{
                    Text("Share on:").bold()
                    Button(action: {
                        print("Share on FaceBook")
                        if let url = URL(string: "https://www.facebook.com/sharer/sharer.php?u=\(all_details[id]!.yelpLink)"){
                            UIApplication.shared.open(url)
                        }
                    })
                    {
                        Image("f_logo_RGB-Blue_144").resizable().frame(width:45, height:45)
                    }
                    Button(action: {
                        print("Twitter")
                        if let url = URL(string: "https://twitter.com/intent/tweet?url=\(all_details[id]!.yelpLink)"){
                            UIApplication.shared.open(url)
                        }
                    })
                    {
                        Image("Twitter social icons - circle - blue").resizable().frame(width:45, height:45)
                    }
                }.padding(.bottom, 8)
                
                HStack{
                    TabView(){
                        KFImage(URL(string:all_details[id]!.pic_1)!).resizable().frame(width: 320, height: 250)
                        //KFImage(URL(string: "https://s3-media1.fl.yelpcdn.com/bphoto/hwmzOIglojtIzvoi3lWEfQ/o.jpg")).resizable().frame(width: 320, height: 250)
                        KFImage(URL(string:all_details[id]!.pic_2)!).resizable().frame(width: 320, height: 250)
                        //KFImage(URL(string: "https://s3-media1.fl.yelpcdn.com/bphoto/hwmzOIglojtIzvoi3lWEfQ/o.jpg")).resizable().frame(width: 320, height: 250)
                        KFImage(URL(string:all_details[id]!.pic_3)!).resizable().frame(width: 320, height: 250)
                        //KFImage(URL(string: "https://s3-media1.fl.yelpcdn.com/bphoto/hwmzOIglojtIzvoi3lWEfQ/o.jpg")).resizable().frame(width: 320, height: 250)
                    }.tabViewStyle(PageTabViewStyle()).frame(width: 320, height:250)
                } // CONTENTS
                
            }.cancelToast(isPresented: $showCancel){
                Text("Your reservation is cancelled.")
            }.padding(.bottom,700) // VStack
            
        } // if statement
        else{
            EmptyView()
        }
        
    } // View
} // Struct

struct BusinessDetail_Previews: PreviewProvider {
    static var previews: some View {
        BusinessDetail(id: "rtwe234", name: "Bob")
            //.environmentObject(Order())
    }
}
