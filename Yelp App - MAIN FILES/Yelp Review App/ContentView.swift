//
//  ContentView.swift
//  Yelp Review App
//
//  Created by Steve Regala on 12/2/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import Kingfisher

struct ContentView: View {
    
    @AppStorage("Reservation") var reserve: Data = Data()
    
    @State private var keyword = ""
    @State private var distance = 10
    var categories = ["Default", "Arts and Entertainment", "Health and Medical", "Hotels and Travel", "Food", "Professional Services"]
    @State private var category = "Default"
    @State private var location = ""
    @State private var auto_detect = false
    @State private var received_auto_detect = false
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var showsPopover = false // For auto-complete feature on keyword text
    @State private var autoCompArr: [String] = []
    @State private var displayResults = false
    @State private var progView = false
    @State private var countForDetails = 0
    
    @State private var searchResult: [TableItems] = []
    
    var formValid: Bool{
        if !keyword.isEmpty && (received_auto_detect || !location.isEmpty) {
            return true
        }
        return false
    }
    
    var buttonColor: Color{
        return formValid ? .red : .gray
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section{ // FORM
                    HStack{
                        Text("Keyword: ").foregroundColor(.gray)
                        TextField("Keyword Input", text: $keyword, prompt: Text("Required"))
                            .onChange(of: keyword, perform: { newTag in
                                autoCompArr.removeAll()
                                autoComplete(key_part: keyword){ _ in
                                    showsPopover = true
                                }
                            })
                            .alwaysPopover(isPresented: $showsPopover) {
                                // Array of words
                                VStack(alignment: .leading, spacing: 4){
                                    if autoCompArr.count == 0 {
                                        ProgressView("...loading")
                                    }
                                    ForEach(autoCompArr, id: \.self) {suggestion in
                                        Button(action: {
                                            //print("Clicked an Item")
                                            keyword = suggestion
                                            showsPopover = false
                                        }, label: {
                                            Label(suggestion, systemImage: "")
                                        }).buttonStyle(.borderless).foregroundColor(.gray)
                                    }
                                }.padding(10)
                            }
                    }
                    HStack{
                        Text("Distance: ").foregroundColor(.gray)
                        TextField("", value: $distance, format: .number)
                    }
                    HStack{
                        Text("Category: ").foregroundColor(.gray)
                        Picker("", selection: $category){
                            ForEach(categories, id: \.self){
                                Text($0)
                            }
                        }.pickerStyle(.menu).labelsHidden().padding(.horizontal,-15.0)
                    }
                    if !auto_detect {
                        HStack{
                            Text("Location: ").foregroundColor(.gray)
                            TextField("Location Input", text: $location, prompt: Text("Required"))
                        }
                    } else {
                        /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                    }
                    HStack{
                        Text("Auto-detect my location").foregroundColor(.gray)
                        Spacer()
                        Toggle("", isOn: $auto_detect).onChange(of: auto_detect){ value in
                            if auto_detect{
                                location = ""
                                getAutoLocation()
                            }else{
                                received_auto_detect = false
                            }
                            print(value)
                        }.labelsHidden()
                    }
                    HStack{
                        Spacer()
                        Button(action:{
                            // Input location is provided, call
                            progView = true
                            if location != "" {
                                getInputLocation(given_loc: location) { _ in
                                    print("Hooray")
                                }
                            }else{
                                onSubmit()
                            }
                        }){
                            Text("Submit")
                                .padding()
                                .padding(.horizontal, 15)
                        }
                        .foregroundColor(.white)
                        .background(buttonColor)
                        .cornerRadius(20)
                        .buttonStyle(BorderlessButtonStyle())
                        .disabled(!formValid)
                        Spacer()
                        Button(action:{
                            print("CLEAR CLEAR CLEAR CLEAR")
                            onClear()
                        }){
                            Text("Clear")
                                .padding()
                                .padding(.horizontal, 20)
                        }
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(20)
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                    }.padding(.vertical)
                }

                Section{
                    Text("Results").font(.system(size: 28, weight: .bold))
                    if progView {
                        ProgressView("Please wait...").id(UUID()).padding(.horizontal, 105)
                    }
                    if displayResults {
                        if searchResult.count == 0 {
                            Text("No results available").foregroundColor(.red)
                        }else{
                            ForEach(all_items) { result in
                                NavigationLink{
                                    //BusinessDetail(id: result.id, name: result.name)
                                    MainView(id: result.id, name: result.name)//, business_detail: BusinessDetail(id: result.id, name: result.name))
                                }label: {
                                    ItemRow(tableItem: result)
                                }
                            }
                        }
                    }
                }// Section
            }.navigationTitle("Business Search")
            .toolbar{
                ToolbarItemGroup(placement: .primaryAction){
                    NavigationLink{
                        BookingsAppStorage()
                    }label:{
                        Image(systemName: "calendar.badge.clock")
                    }
                }
            }
        } // NAVIGATION STACK
        
    }
    
    func autoComplete(key_part: String, completion: @escaping (JSON) -> Void) {
        let url_loc = "https://csci-homework-8.wl.r.appspot.com/api/autocomplete?text=\(keyword)"
        if let encoded = url_loc.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string:encoded){
            AF.request(url).responseData { response in
                switch response.result {
                case .success(let value):
                    let result = JSON(value as Any)
                    print(result)
                    completion(result)
                    autoCompArr = result.rawValue as? [String] ?? []
                    print(autoCompArr)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // Function to auto detect location
    func getAutoLocation(){
        let url_ipInfo = "https://ipinfo.io/json?token=1bb416f5a67c3e"
        AF.request(url_ipInfo).response { response in
            switch response.result {
            case .success(let value):
                let result = JSON(value as Any)
                let json_string_loc = result["loc"].string
                let loc_arr = json_string_loc?.split(separator: ",")
                received_auto_detect = true
                latitude = String(loc_arr![0])
                longitude = String(loc_arr![1])
                print("Coordinates: \(latitude) and \(longitude)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getInputLocation(given_loc: String, completion: @escaping (NSArray) -> Void) {
    //func getInputLocation(given_loc: String) async -> NSArray{
        let url_loc = "https://csci-homework-8.wl.r.appspot.com/api/googlelocation?address=\(given_loc)"
        //var ret_val = [] as NSArray
        if let encoded = url_loc.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded){
            AF.request(url).response { response in
                switch response.result {
                case .success(let value):
                    let result = JSON(value as Any)
                    let JSON_array = result.rawValue as! NSArray
                    completion(JSON_array)
                    print("The count is: \(JSON_array.count)")
                    if JSON_array.count != 0{
                        latitude = String(describing: JSON_array[0] as! NSNumber)
                        longitude = String(describing: JSON_array[1] as! NSNumber)
                        print("Coordinates: \(latitude) and \(longitude)")
                        onSubmit()
                    }else{
                        // INVALID LOCATION
                        searchResult.removeAll()
                        progView = false
                        displayResults = true
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func onSubmit() {
        searchResult.removeAll()
        displayResults = false
        countForDetails = 0
        
        let temp_radius = Double(distance)*1609.344
        var radius = String(Int(temp_radius))    // Inside URL
        if temp_radius > 40000 {
            radius = String(40000)
        }
        
        let url_loc = "https://csci-homework-8.wl.r.appspot.com/api/searchBusiness?term=\(keyword)&latitude=\(latitude)&longitude=\(longitude)&category=\(category)&radius=\(radius)"
        print("OUR CURRENT URL \(url_loc)")
        
        if let encoded = url_loc.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded){
            AF.request(url).response { response in
                switch response.result {
                case .success(let value):
                    let res = JSON(value as Any)
                    for i in 0..<res.count{//2
                        if i < 10 {
                            let position_temp = i+1
                            let id_temp = res[i]["id"].stringValue
                            let name_temp = res[i]["name"].stringValue
                            let rating_temp = res[i]["rating"].doubleValue
                            let temp_miles_temp = res[i]["distance"].doubleValue
                            let miles_temp = Int(temp_miles_temp/1609.344)
                            var imageURL_temp = res[i]["image_url"].stringValue
                            // check if image URL is empty string
                            if imageURL_temp.isEmpty{
                                imageURL_temp = "https://www.scoopearth.com/wp-content/uploads/2022/08/Slide-16_9-6-1200x630-1.png"
                            }
                            let item = TableItems(position:position_temp, id:id_temp, name:name_temp, rating:rating_temp, miles:miles_temp, imageURL: imageURL_temp)
                            searchResult.append(item)
                        }
                        if i == 10 { break }
                        
                    }
                    all_items.removeAll()
                    all_details.removeAll()
                    all_items = searchResult
                    // Call getDetails function
                    // New Code - calling getDetails for each Business
                    if !searchResult.isEmpty{
                        initializeDetails()
                    }
                    
                    // Called for loop for details here previously
                    progView = false
                    displayResults = true // to display results
                    print("searchResult count is: \(searchResult.count)")
                    //print(all_items)
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    } // End of submit function
    
    func onClear(){
        searchResult.removeAll()
        all_items.removeAll()
        countForDetails = 0
        displayResults = false
        progView = false
        keyword = ""
        distance = 10
        category = "Default"
        location = ""
        auto_detect = false
    }
    
    
    func initializeDetails(){
        //print("all_items has this many ELEMENTS: \(all_items.count)")
        let url_detail = "https://csci-homework-8.wl.r.appspot.com/api/details?id=\(all_items[countForDetails].id)"
        AF.request(url_detail).response{ response in
            switch response.result{
            case .success(let value):
                let result = JSON(value as Any)
                // SEPARATION
                // DISPLAY ADDRESS ---------------
                var final_address = ""
                if result["location"]["display_address"].exists(){
                    if result["location"]["display_address"].isEmpty{
                        final_address = "N/A"
                    }else{
                        var temp_string = ""
                        let temp_arr = result["location"]["display_address"]
                        let temp_len = temp_arr.count
                        for i in 0..<temp_len {
                            if i==temp_len-1 {
                                temp_string += temp_arr[i].stringValue
                            }else{
                                temp_string += temp_arr[i].stringValue + " "
                            }
                        }
                        final_address = temp_string
                    }
                }else{
                    final_address = "N/A"
                }

                // CATEGORIES ---------------
                var final_cat = ""
                if result["categories"].exists(){
                    if result["categories"].isEmpty{
                        final_cat = "N/A"
                    }else{
                        var temp_string = ""
                        let temp_arr = result["categories"]
                        let temp_len = temp_arr.count
                        for i in 0..<temp_len {
                            if i==temp_len-1 {
                                temp_string += temp_arr[i]["title"].stringValue
                            }else{
                                temp_string += temp_arr[i]["title"].stringValue + " | "
                            }
                        }
                        final_cat = temp_string
                    }
                }else{
                    final_cat = "N/A"
                }
                
                // PHONE ---------------
                var final_phone = ""
                if result["display_phone"].exists(){
                    if result["display_phone"].stringValue.isEmpty{
                        final_phone = "N/A"
                    }else{
                        final_phone = result["display_phone"].stringValue
                    }
                }else{
                    final_phone = "N/A"
                }
                
                // PRICE RANGE ---------------
                var final_price = ""
                if !result["price"].exists(){
                    final_price = "N/A"
                }else{
                    if result["price"].stringValue.isEmpty{
                        final_price = "N/A"
                    }else{
                        final_price = result["price"].stringValue
                    }
                }
                
                // STATUS ---------------
                var final_status = true
                if result["hours"][0]["is_open_now"].exists(){
                    if !(result["hours"][0]["is_open_now"].boolValue){
                        final_status = false
                    }else{
                        final_status = true
                    }
                }else{
                    final_status = false // doesn't really matter if status always exists
                }
            
                // URL ---------------
                var final_URL = ""
                if result["url"].exists(){
                    if result["url"].stringValue.isEmpty{
                        final_URL = ""
                    }else{
                        final_URL = result["url"].stringValue
                    }
                }
                
                // PHOTOS 1 2 3 ---------------
                var pic_1: String = "https://www.scoopearth.com/wp-content/uploads/2022/08/Slide-16_9-6-1200x630-1.png"
                var pic_2: String = "https://www.scoopearth.com/wp-content/uploads/2022/08/Slide-16_9-6-1200x630-1.png"
                var pic_3: String = "https://www.scoopearth.com/wp-content/uploads/2022/08/Slide-16_9-6-1200x630-1.png"
                for i in 0..<result["photos"].count{
                    if i==0 {
                        pic_1 = result["photos"][i].stringValue
                    }else if i==1 {
                        pic_2 = result["photos"][i].stringValue
                    }else{
                        pic_3 = result["photos"][i].stringValue
                    }
                }
                
                // COORDINATES ---------------
                var latLoc: String = ""
                var longLoc: String = ""
                if result["coordinates"]["latitude"].exists(){
                    if !result["coordinates"]["latitude"].stringValue.isEmpty{
                        latLoc = result["coordinates"]["latitude"].stringValue
                    }
                }
                if result["coordinates"]["longitude"].exists(){
                    if !result["coordinates"]["longitude"].stringValue.isEmpty{
                        longLoc = result["coordinates"]["longitude"].stringValue
                    }
                }
                
                //print("isDetailReady is detailReadyWasHere, culprit is: \(all_items[countForDetails].name)")
                
                let detailItem = DetailsItem(id: all_items[countForDetails].id, name: all_items[countForDetails].name, address: final_address, typeCat: final_cat, phoneNum: final_phone, price: final_price, status: final_status, yelpLink: final_URL, pic_1: pic_1, pic_2: pic_2, pic_3: pic_3, latLoc: latLoc, longLoc: longLoc)
                
                all_details[all_items[countForDetails].id] = detailItem
                
                countForDetails += 1
                // recursive call
                if countForDetails < all_items.count{
                    initializeDetails()
                }
                // SEPARATION
                
            case .failure(let error):
                print(error)
            }
        }
        
        progView = false
        displayResults = true // to display results
        //print("searchResult count is: \(searchResult.count)")
        //print(all_details)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
