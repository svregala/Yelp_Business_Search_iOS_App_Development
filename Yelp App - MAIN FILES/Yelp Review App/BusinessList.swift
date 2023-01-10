//
//  BusinessList.swift
//  Yelp Review App
//
//  Created by Steve Regala on 12/6/22.
//

import SwiftUI

struct BusinessList: View {
    
    //@State var on: Boofalse
    
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        /*NavigationStack{
            List(all_items, id:\.self) { result in
                Button(role: result as? ButtonRole){
                    selectedFavorite = result
                } label: {
                    ItemRow(tableItem: result)
                }
                .navigationDestination(for: $selectedFavorite){ fav in
                    BusinessDetail(id: fav.id, name:fav.name)
                }
            }
        }*/
        
        NavigationStack{
            ForEach(all_items) { result in
                NavigationLink{
                    BusinessDetail(id: result.id, name:result.name) // pass in ID
                } label: {
                    ItemRow(tableItem: result)
                }
            }.navigationDestination(for: TableItems.self){ fav in
                BusinessDetail(id: fav.id, name:fav.name)
            }
        }
        
        /*NavigationStack{
            ForEach(all_items) { result in
                NavigationLink(isActive:$on){
                    BusinessDetail(id: result.id, name:result.name) // pass in ID'
                } label: {
                    ItemRow(tableItem: result)
                }
            }
        }*/
        /*List(all_items){ result in
            ItemRow(tableItem: result)
        }*/
        /*NavigationStack{
            List(all_items){ result in
                NavigationLink{
                    
                }label: {
                    ItemRow(tableItem: result)
            }
            .navigationDestination(for: TableItems.self){ result in
                BusinessDetail(id: result.id, name:result.name)
            }
        }*/
        /*List(all_items) { result in
            NavigationLink{
                BusinessDetail()
            } label: {
                ItemRow(tableItem: result)
            }
        }*/
        /*
        NavigationStack {
            List(parks) { park in
                NavigationLink(park.name, value: park)
            }
            .navigationDestination(for: Park.self) { park in
                ParkDetails(park: park)
            }
        }
        */
    }
}



struct BusinessList_Previews: PreviewProvider {
    static var previews: some View {
        BusinessList()
    }
}
