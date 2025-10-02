import SwiftUI
import MapKit

struct LocationPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        Map(position: .constant(.region(locationManager.region))) {
            Annotation("Você", coordinate: locationManager.region.center) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: 30, height: 30)
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 12, height: 12)
                }
            }
        }
        .ignoresSafeArea()
    }
}
