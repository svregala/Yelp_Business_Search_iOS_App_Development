//
//  BookingsAppStorage.swift
//  Yelp Review App
//
//  Created by Steve Regala on 12/8/22.
//

import SwiftUI
import SwiftyJSON

// CITATION: https://stackoverflow.com/questions/63090325/how-to-execute-non-view-code-inside-a-swiftui-view
struct ExecuteCodeReserve : View {
    init( _ codeToExec: () -> () ) {
        codeToExec()
    }
    
    var body: some View {
        return EmptyView()
    }
}

struct BookingsAppStorage: View {
    
    @AppStorage("Reservation") var reserve: Data = Data()
    
    @State private var isLoaded: Bool = false
    @State private var dynamicArr: [[String]] = []
    
    /*
     - This will be an array of dictionaries, i.e. a map (key as id and value as array of strings
        e.g. ["0fvsF6mV5DqyQJb_cc6V3Q": ["Dulce", "12/14/2022", "10:00", "Donuts@gmail.com"]]
     - If the array is empty, display no reservations found
     - Otherwise, if it isn't, loop through the whole array and display each dictionary in the View
     - In views like BusinessDetail (where we have to check if the current business is inside the storage),
        we will loop through the array and check if a dictionary with that particular key (id) exists
        - if it does, turn the reserve button blue, otherwise red
     - swap to delete an entry; on swap, have a variable that holds the id and make it disappear from the array that exists in the local storage
     */
    
    var body: some View {
        VStack{
            if !isLoaded{
                //Text("No Bookings Found").foregroundColor(.red)
                ProgressView("Please wait...")
                ExecuteCode{
                    guard let decodedReserve = try? JSONDecoder().decode([String:[String]].self, from: reserve) else { return }
                    print(type(of: decodedReserve))
                    print("Count of reserve is: \(decodedReserve.count)")
                    DispatchQueue.main.async {
                        for (key, value) in decodedReserve{
                            var tempArr = value
                            tempArr.append(key)
                            dynamicArr.append(tempArr)
                        }
                        //dynamicArr = Array(decodedReserve.values)
                        isLoaded = true
                    }
                }
                Spacer()
            }else{
                if dynamicArr.isEmpty{
                    VStack{
                        Spacer()
                        Text("No Bookings Found").foregroundColor(.red)
                        Spacer()
                    }
                }else{
                    List{
                        ForEach(dynamicArr, id: \.self){ res in
                            HStack{
                                Spacer()
                                Text(res[0]).frame(width: 85, alignment:.leading).font(.system(size:12))
                                Spacer()
                                Text(res[1]).frame(width: 70, alignment:.center).font(.system(size:12))
                                Spacer()
                                Text(res[2]).frame(width: 40, alignment:.center).font(.system(size:12))
                                Spacer()
                                Text(res[3]).frame(width: 120, alignment:.leading).font(.system(size:12))
                                Spacer()
                            }
                        }.onDelete(perform: deleteUpdate)
                    }
                }
                Spacer()
            }
        }.navigationTitle("Your Reservations")
    } // Body
    
    func deleteUpdate(at offsets: IndexSet) {
        let indexToBeDeleted = offsets[offsets.startIndex]
        let keyToBeDeleted = dynamicArr[indexToBeDeleted][4]
        print("Deleting...")
        print(keyToBeDeleted)
        guard var decodedReserve = try? JSONDecoder().decode([String:[String]].self, from: reserve) else { return }
        decodedReserve.removeValue(forKey: keyToBeDeleted)
        print(decodedReserve)
        guard let reserve = try? JSONEncoder().encode(decodedReserve) else { return }
        self.reserve = reserve
        dynamicArr.remove(atOffsets: offsets)
    }
}


struct BookingsAppStorage_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello world bye now")
        //BookingsAppStorage(decodedRes: [:])
    }
}
