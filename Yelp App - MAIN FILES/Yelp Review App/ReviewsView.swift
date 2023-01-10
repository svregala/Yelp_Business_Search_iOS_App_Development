//
//  ReviewsView.swift
//  Yelp Review App
//
//  Created by Steve Regala on 12/8/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON

// CITATION: https://stackoverflow.com/questions/63090325/how-to-execute-non-view-code-inside-a-swiftui-view
struct ExecuteCode : View {
    init( _ codeToExec: () -> () ) {
        codeToExec()
    }
    
    var body: some View {
        return EmptyView()
    }
}

struct ReviewsView: Identifiable, View {
    
    var id: String
    var name: String
    @State private var reviews: [[String:String]] = []
    @State private var isReadyToView: Bool = false
    
    init(id:String, name:String){
        self.id = id
        self.name = name
    }
    
    var body: some View {
        
        if !isReadyToView{
            ProgressView("Please wait...")
            ExecuteCode {
                getReviews(){_ in
                    isReadyToView = true
                }
            }
        }else{
            VStack{
                List(reviews, id:\.self){ res in
                    VStack{
                        HStack(spacing: 0){
                            Text(res["name"]!).bold()
                            //Text("Steve").bold()
                            Spacer()
                            Text("\(res["rating"]!)/5").bold()
                            //Text("4/5").bold()
                        }.padding(.bottom, 5)
                        HStack{
                            Text(res["text"]!).foregroundColor(.gray)
                            //Text("This is place is oklau sdfsdfdasklfj asdkflj laskfj sadflk jasldkfj asldkfj laksdfj alsdkfj asldkfj asdlkfj sdklfjasdkf jasdklfj asldkfj alsdkfj laskdfj asldkfj asdklfj lasdkfjasdklf jasldkfj alskdfj aslkdfj alsdkfj alskdfj alsdkjf laksdjf kf adsj  sdlkfjklfjasd;klfj a;lweijrio;qwuiojv j lskdfj a;kf jads;klfj").foregroundColor(.gray)
                        }.padding(.bottom, 5)
                        HStack{
                            Spacer()
                            Text(res["date"]!)
                            //Text("2022-10-20")
                            Spacer()
                        }.padding(.bottom, 5)
                    }.padding(.top, 8)
                }
            }
        }
        
    }
    
    func getReviews(completion: @escaping (JSON) -> Void){
        // call API
        let url_review = "https://csci-homework-8.wl.r.appspot.com/api/reviews?id=\(id)"
        AF.request(url_review).response { res in
            switch res.result {
            case .success(let value):
                let result = JSON(value as Any)
                for i in 0..<result.count{
                    //print("Entered For loop")
                    //print("string value is \(result[i]["user"]["name"].stringValue)")
                    var temp_review: [String:String] = [:]
                    temp_review["name"] = result[i]["user"]["name"].stringValue
                    temp_review["rating"] = result[i]["rating"].stringValue
                    temp_review["text"] = result[i]["text"].stringValue
                    let date_created = result[i]["time_created"].stringValue.split(separator:" ")
                    temp_review["date"] = String(date_created[0])
                    reviews.append(temp_review)
                }
                completion(result)
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct ReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewsView(id:"Test", name: "Test")
    }
}
