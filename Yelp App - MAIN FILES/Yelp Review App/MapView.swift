//
//  MapView.swift
//  Yelp Review App
//
//  Created by Steve Regala on 12/8/22.
//

import SwiftUI
import MapKit

struct AnnotatedItem: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    
    var name: String
    var lat: String
    var long: String
    @State private var region: MKCoordinateRegion
    private var pointOfInterest: [AnnotatedItem] = []
    
    /*@State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.75773, longitude: -73.985708), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )*/

    init(name:String, lat:String, long:String){
        self.name = name
        self.lat = lat
        self.long = long
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.pointOfInterest = [AnnotatedItem(name:name, coordinate: .init(latitude: Double(lat)!, longitude: Double(long)!))]
    }
    
    //@State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(long)), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: pointOfInterest){ item in
            MapMarker(coordinate: item.coordinate)
        }.frame(height: 670).padding(.bottom, 50)
        //.edgesIgnoringSafeArea(.top)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(name: "Steve", lat: "Steve", long: "Cool")
    }
}
