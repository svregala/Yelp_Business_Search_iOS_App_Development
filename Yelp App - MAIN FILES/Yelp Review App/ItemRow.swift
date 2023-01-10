//
//  ItemRow.swift
//  Yelp Review App
//
//  Created by Steve Regala on 12/5/22.
//

import SwiftUI
import Kingfisher

struct ItemRow: View {
    
    var tableItem: TableItems
    
    var body: some View {
        HStack{
            Text(String(tableItem.position))
            Spacer()
            KFImage(URL(string:tableItem.imageURL)!).resizable().frame(width: 60, height: 60).cornerRadius(10)
            Spacer()
            Text(tableItem.name).foregroundColor(.gray).frame(width: 70, alignment:.leading).font(.system(size:13))
            Spacer()
            Text(String(tableItem.rating)).bold()
            Spacer()
            Text(String(tableItem.miles)).bold()
            Spacer()
        }
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemRow(tableItem: all_items[0])
    }
}
