//
//  DetailsItem.swift
//  Yelp Review App
//
//  Created by Steve Regala on 12/6/22.
//

import Foundation
import SwiftyJSON
import Alamofire
import SwiftUI

class DetailsItem: Identifiable, Codable {
    var id: String = ""
    var name: String = ""
    var address: String = ""
    var typeCat: String = ""
    var phoneNum: String = ""
    var price: String = ""   // Can NOT exist in returned JSON
    var status: Bool = true
    var yelpLink: String = ""
    var pic_1: String = "https://www.scoopearth.com/wp-content/uploads/2022/08/Slide-16_9-6-1200x630-1.png"
    var pic_2: String = "https://www.scoopearth.com/wp-content/uploads/2022/08/Slide-16_9-6-1200x630-1.png"
    var pic_3: String = "https://www.scoopearth.com/wp-content/uploads/2022/08/Slide-16_9-6-1200x630-1.png"
    
    var latLoc: String = ""
    var longLoc: String = ""
    
    init(id:String, name:String, address:String, typeCat:String, phoneNum:String, price:String, status:Bool, yelpLink:String, pic_1:String, pic_2:String, pic_3:String, latLoc:String, longLoc:String){
        
        self.id = id
        self.name = name
        self.address = address
        self.typeCat = typeCat
        self.phoneNum = phoneNum
        self.price = price
        self.status = status
        self.yelpLink = yelpLink
        self.pic_1 = pic_1
        self.pic_2 = pic_2
        self.pic_3 = pic_3
        self.latLoc = latLoc
        self.longLoc = longLoc
    }

}

// Dictionary to map ID to details
var all_details: [String : DetailsItem] = [:]
