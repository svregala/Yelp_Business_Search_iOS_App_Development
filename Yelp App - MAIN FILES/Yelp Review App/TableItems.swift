//
//  TableItems.swift
//  Yelp Review App
//
//  Created by Steve Regala on 12/5/22.
//

import Foundation
import SwiftUI

struct TableItems: Hashable, Identifiable, Codable {
    var position: Int
    var id: String
    var name: String
    var rating: Double
    var miles: Int
    var imageURL: String
    
    // Have another class including its details or possibly
    init(position:Int, id:String, name:String, rating:Double, miles:Int, imageURL:String){
        self.position = position
        self.id = id
        self.name = name
        self.rating = rating
        self.miles = miles
        self.imageURL = imageURL
    }
}

// Array of results
var all_items: [TableItems] = []

/*
// Array of results
var all_items: [TableItems] = [
    /*TableItems(position:0, id:"GXu3PHpo011aydg", name:"HI WORLD", rating:4.5, miles:1, imageURL: "https://s3-media4.fl.yelpcdn.com/bphoto/F_-ehvcQYFVM0TZTi3mb-A/o.jpg"),
    TableItems(position:1, id:"GXuIHpo011aydg", name:"NOVAS CRIB", rating:4.5, miles:1, imageURL: "https://s3-media4.fl.yelpcdn.com/bphoto/F_-ehvcQYFVM0TZTi3mb-A/o.jpg"),
    TableItems(position:2, id:"GXu011aydg", name:"3rd ONE OK", rating:4.5, miles:1, imageURL: "https://s3-media4.fl.yelpcdn.com/bphoto/F_-ehvcQYFVM0TZTi3mb-A/o.jpg"),
    TableItems(position:3, id:"po011aydg", name:"FOUR FOUR FOUR", rating:4.5, miles:1, imageURL: "https://s3-media4.fl.yelpcdn.com/bphoto/F_-ehvcQYFVM0TZTi3mb-A/o.jpg")*/
]
*/
