//
//  MainView.swift
//  Yelp Review App
//
//  Created by Steve Regala on 12/6/22.
//

import SwiftUI

struct MainView: View {
    
    var id: String
    var name: String
    
    init(id:String, name:String){
        self.id = id
        self.name = name
    }
    
    var body: some View {
        
        VStack{
            TabView{
                BusinessDetail(id: id, name: name)
                    .tabItem{
                        Label("Business Detail", systemImage: "text.bubble.fill")
                    }
                
                MapView(name:all_details[id]!.name, lat:all_details[id]!.latLoc, long:all_details[id]!.longLoc).tabItem{
                    Label("Map Location", systemImage: "location.fill")
                }
                
                ReviewsView(id: id, name: name).tabItem{
                        Label("Reviews", systemImage: "message.fill")
                    }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(id: "IxuAHGu-eQ4fZJZTdzGTYQ", name: "Test Restaurant")//, business_detail: BusinessDetail(id: "IxuAHGu-eQ4fZJZTdzGTYQ", name: "Test Restaurant"))
    }
}
