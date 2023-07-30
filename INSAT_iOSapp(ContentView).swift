import SwiftUI
import Combine
import UIKit
import SDWebImageSwiftUI
import CoreLocation
import WebKit

struct SatelliteImage: Identifiable {
    let id: UUID = UUID()
    let url: String
    let title: String
    let description: String
}

class ImageRepository: ObservableObject {
    
    @Published var satelliteImages: [String: [SatelliteImage]] = [:] // Dictionary for different sections
    
    init() {
        fetchImages()
    }
        
    func fetchImages() {
        Task.init {
            do {
                try await self.fetchImagesAsync()
            } catch {
                print(error)
            }
        }
    }
    
    func asyncRemoveImage(forKey key: String) async {
        await withCheckedContinuation { continuation in
            SDImageCache.shared.removeImage(forKey: key) {
                continuation.resume(returning: ())
            }
        }
    }
    
    func fetchImagesAsync() async throws {
        // URLs of the images
        let urls1 = [
            "https://mausam.imd.gov.in/Satellite/rs_olr.jpg",
            "https://mausam.imd.gov.in/Satellite/rswmo_ir1.jpg",
            "https://mausam.imd.gov.in/Satellite/rswmo_mp.jpg",
            "https://mausam.imd.gov.in/Radar/caz_delhi.gif",
            "https://mausam.imd.gov.in/Radar/ppi_delhi.gif",
            "https://mausam.imd.gov.in/Radar/sri_delhi.gif",
            "https://mausam.imd.gov.in/Radar/pac_delhi.gif",
            "https://nwp.imd.gov.in/wrf/WRF3km-03-RAIN_24.png",
            "https://img.nsmc.org.cn/CLOUDIMAGE/FY2H/GLL/FY2H_ETV_SEC_GLB.jpg"
        ]
        
        let urls2 = [
            "http://satellite.imd.gov.in/imgr/nesec_vis.jpg",
            "http://satellite.imd.gov.in/imgr/nesec_ir1.jpg",
            "http://satellite.imd.gov.in/imgr/nesec_mp.jpg"
        ]
        
        let urls3 = [
            "http://satellite.imd.gov.in/imgr/nwsec_vis.jpg",
            "http://satellite.imd.gov.in/imgr/nwsec_swir.jpg",
            "http://satellite.imd.gov.in/imgr/nwsec_mp.jpg"
        ]
        
        let urls4 = [
            "http://satellite.imd.gov.in/imgr/sesec_vis.jpg",
            "http://satellite.imd.gov.in/imgr/sesec_ir1.jpg",
            "http://satellite.imd.gov.in/imgr/sesec_mp.jpg"
        ]
        
        let urls5 = [
            "http://satellite.imd.gov.in/imgr/swsec_vis.jpg",
            "http://satellite.imd.gov.in/imgr/swsec_ir1.jpg",
            "http://satellite.imd.gov.in/imgr/swsec_mp.jpg"
        ]
        
        
        // Remove images from the cache asynchronously
        for url in urls1 + urls2 {
                    await asyncRemoveImage(forKey: url)
                }
        
        let previousImages = [
            SatelliteImage(url: urls1[0], title: "Outgoing Longwave Radiation (OLR)", description: "Outgoing Longwave Radiation (OLR) maps depict the top-of-atmosphere energy emitted by the Earth system in the 4-50 µm band."),
            SatelliteImage(url: urls1[1], title: "Infrared Channel 10.8µm", description: "These images display cloud-top temperatures or equivalent blackbody brightness temperature in Kelvin."),
            SatelliteImage(url: urls1[2], title: "Day Microphysics", description: "Day Microphysics RGB combines the data of 3 channels or channel differences into one image, helpful for cloud detection."),
            SatelliteImage(url: urls1[3], title: "Constant Altitude Plan Position Indicator (Delhi Radar)", description: "This radar image captures the precipitation at a fixed altitude. It helps to analyze the spatial distribution of precipitation at that altitude."),
            SatelliteImage(url: urls1[4], title: "Plan Position Indicator (Delhi Radar)", description: "Plan Position Indicator is the most common type of radar display. The radar antenna rotates 360 degrees around a fixed point, mapping the surrounding area."),
            SatelliteImage(url: urls1[5], title: "Storm Relative Intensity (Delhi Radar)", description: "The Storm Relative Intensity Map shows the intensity of precipitation relative to a moving storm."),
            SatelliteImage(url: urls1[6], title: "Precipitation Accumulation (Delhi Radar)", description: "Precipitation Accumulation maps display the cumulative rainfall over a certain period."),
            SatelliteImage(url: urls1[7], title: "Mesoscale Model (03KM,03HR)", description: "Mesoscale models are weather prediction models that can predict highly detailed weather phenomena. This specific image shows precipitation forecast for the next 3 hours."),
            SatelliteImage(url: urls1[8], title: "Indian Sub-Continent", description: "This specific image shows precipitation forecast for the next 3 hours.")
        ]
        
        let nwsecImages = [
            SatelliteImage(url: urls3[0], title: "NWSEC Visual Image", description: "This is a visual image captured by the NWSEC satellite."),
            SatelliteImage(url: urls3[1], title: "NWSEC Shortwave Infrared Image", description: "This is a shortwave infrared image captured by the NWSEC satellite."),
            SatelliteImage(url: urls3[2], title: "NWSEC fMicrophysics", description: "This image displays some kind of microphysical data from the NWSEC satellite.")
        ]
        
        let nesacImages = [
            SatelliteImage(url: urls2[0], title: "NESAC Visual Image 1", description: "This is a visual image captured by the NESAC satellite."),
            SatelliteImage(url: urls2[1], title: "NESAC Visual Image 2", description: "This is another visual image captured by the NESAC satellite."),
            SatelliteImage(url: urls2[2], title: "NESAC Microphysics", description: "This image displays some kind of microphysical data from the NESAC satellite.")
        ]
        
        
        let sesecImages = [
            SatelliteImage(url: urls4[0], title: "SESEC Visual Image", description: "This is a visual image captured by the SESEC satellite."),
            SatelliteImage(url: urls4[1], title: "SESEC Infrared Image", description: "This is an infrared image captured by the SESEC satellite."),
            SatelliteImage(url: urls4[2], title: "SESEC Microphysics", description: "This image displays some kind of microphysical data from the SESEC satellite.")
        ]
        
        let swsecImages = [
            SatelliteImage(url: urls5[0], title: "SWSEC Visual Image", description: "This is a visual image captured by the SWSEC satellite."),
            SatelliteImage(url: urls5[1], title: "SWSEC Infrared Image", description: "This is an infrared image captured by the SWSEC satellite."),
            SatelliteImage(url: urls5[2], title: "SWSEC Microphysics", description: "This image displays some kind of microphysical data from the SWSEC satellite.")
        ]
        
        DispatchQueue.main.async {
            self.satelliteImages = [
                "Indian Sub-Continent Images": previousImages,
                "North West India Images": nwsecImages,
                "South East India Images": sesecImages,
                "South West India Images": swsecImages,
                "North East India Images": nesacImages
            ]
        }

    }
}
    
struct ContentView: View {
    
    @StateObject private var weatherManager = WeatherManager()
    
    @StateObject private var imageRepository = ImageRepository()
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var cancellables = Set<AnyCancellable>()
    
    let colors: [Color] = [.white, .green, .blue, .yellow, .pink, .red, .orange, .mint]
    
    @State private var showWeatherView: Bool = false
    @State private var userLocation: CLLocationCoordinate2D?
    
    var gifUrls: [String] = [
            "https://mausam.imd.gov.in/Satellite/Converted/IR1.gif",
            "https://mausam.imd.gov.in/Satellite/Converted/VIS.gif",
            "https://mausam.imd.gov.in/Satellite/Converted/WV.gif"
        ]
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    Button(action: {
                        Task.init {
                            locationManager.requestLocation()
                            if let unwrappedLocation = locationManager.location {
                                userLocation = unwrappedLocation
                                weatherManager.fetchWeather(lat: unwrappedLocation.latitude, lon: unwrappedLocation.longitude)
                                showWeatherView = true
                            } else {
                                print("Failed to get location")
                            }
                        }
                    }) {
                        Image(systemName: "location.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                    .cornerRadius(30)
                    .foregroundColor(.white)
                    .preferredColorScheme(.dark)
                    .padding(.all)
                    
                    if showWeatherView {
                        VStack {
                            Text("Weather: \(weatherManager.weatherDescription)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.leading, 15)
                                .padding(.top, 5)
                            Text("Temperature: \(weatherManager.temperature, specifier: "%.1f")°C")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.leading, 15)
                                .padding(.top, 5)
                            Text("Feels Like: \(weatherManager.feelsLike, specifier: "%.1f")°C")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.leading, 15)
                                .padding(.top, 5)
                            Text("High Temp: \(weatherManager.tempMax, specifier: "%.1f")°C")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.leading, 15)
                                .padding(.top, 5)
                            Text("Low Temp: \(weatherManager.tempMin, specifier: "%.1f")°C")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.leading, 15)
                                .padding(.top, 5)
                            Text("Pressure: \(weatherManager.pressure) hPa")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.leading, 15)
                                .padding(.top, 5)
                            Text("Humidity: \(weatherManager.humidity)%")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.leading, 15)
                                .padding(.top, 5)
                            Text("Sunrise: \(Date(timeIntervalSince1970: TimeInterval(weatherManager.sunrise)))")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.leading, 15)
                                .padding(.top, 5)
                            Text("Sunset: \(Date(timeIntervalSince1970: TimeInterval(weatherManager.sunset)))")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.leading, 15)
                                .padding(.top, 5)
                            Text("Wind Speed: \(weatherManager.windSpeed, specifier: "%.1f") m/s")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.leading, 15)
                                .padding(.top, 5)
                            
                        }
                    } else {
                        Text("Fetching Weather Data...")
                            .onAppear {
                                Task {
                                    locationManager.requestLocation()
                                    if let location = await locationManager.$location.values.first(where: { $0 != nil }),
                                    let unwrappedLocation = location {
                                        userLocation = unwrappedLocation
                                        weatherManager.fetchWeather(lat: unwrappedLocation.latitude, lon: unwrappedLocation.longitude)
                                        showWeatherView = true
                                    } else {
                                        print("Failed to get location")
                                    }
                                }
                            }
                    }
                }
            }
            .tabItem {
                Image(systemName: "cloud.sun.fill")
                Text("Weather")
            }
            
            NavigationView {
                ScrollView {
                    VStack {
                        ForEach(imageRepository.satelliteImages.keys.sorted(), id: \.self) { key in
                            VStack(alignment: .leading) {
                                Text(key)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.leading, 15)
                                    .padding(.top, 5)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(alignment: .top, spacing: 10) {
                                        ForEach(imageRepository.satelliteImages[key]!, id: \.url) { image in
                                            NavigationLink(destination: DetailView(imageUrl: image.url, imageDescription: image.description)) {
                                                SatelliteRow(image: image, colors: colors)
                                            }
                                        }
                                    }
                                    .frame(height: 450)
                                }
                            }
                        }
                    }
                }
            }
            .tabItem {
                Image(systemName: "network")
                Text("Satellite View")
            }
            
            
            NavigationView {
                            ScrollView {
                                VStack(spacing: 20) {
                                    ForEach(gifUrls, id: \.self) { gifUrl in
                                        WebView(url: URL(string: gifUrl)!)
                                            .frame(height: 200)
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.gray, lineWidth: 1)
                                            )
                                    }
                                }
                                .padding(.all)
                            }
                            .navigationTitle("Animations")
                        }
                        .tabItem {
                            Image(systemName: "waveform.path.ecg")
                            Text("Animations")
                        }
                    }
                    .padding([.leading, .bottom, .trailing, .horizontal], 0.8)
                    .navigationViewStyle(.stack)
                }
            }
       

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No update code needed.
    }
}

  





struct SatelliteRow: View {
    var image: SatelliteImage
    @State private var color: Color
    let colors: [Color]
    
    let timer = Timer.publish(every: 1.9, on: .main, in: .common).autoconnect()
    
    init(image: SatelliteImage, colors: [Color]) {
        self.image = image
        self._color = State(initialValue: colors.randomElement()!)
        self.colors = colors
    }
    
    var body: some View {
        VStack {
            WebImage(url: URL(string: image.url))
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .background(Color.black.opacity(0.9))
                .cornerRadius(10)
                .padding([.top, .bottom, .horizontal])
            
            Text(image.title)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding([.leading, .bottom, .trailing])
            
        }
        .background(color.opacity(0.6))
        .cornerRadius(30)
        .padding([.top, .horizontal, .bottom])
        .onReceive(timer) { _ in
            withAnimation {
                var newColor: Color
                repeat {
                    newColor = colors.randomElement()!
                } while newColor == color
                self.color = newColor
            }
        }
    }
}



    
struct DetailView: View {
    var imageUrl: String
    var imageDescription: String // Description of the image

    @State private var cumulativeScale: CGFloat = 1.0
    @State private var cumulativeDrag: CGSize = CGSize.zero
    @GestureState private var magnificationState = CGFloat(1.0) // scale state using GestureState
    @GestureState private var translationState = CGSize.zero // offset state using GestureState
    @State private var showInfo = false // State variable to control the info view visibility

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            WebImage(url: URL(string: imageUrl))
                .resizable()
                .indicator(.activity) // Show activity indicator while loading
                .scaledToFit()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
                .padding()
                .scaleEffect(cumulativeScale * magnificationState) // Apply the scale effect
                .offset(x: cumulativeDrag.width + translationState.width, y: cumulativeDrag.height + translationState.height) // Apply the offset for panning
                .gesture(
                    // Add the MagnificationGesture for pinch-to-zoom
                    MagnificationGesture()
                        .updating($magnificationState) { currentState, gestureState, _ in
                            gestureState = currentState
                        }
                        .onEnded { value in
                            self.cumulativeScale *= value
                        }
                        .simultaneously(with: // Add the DragGesture for panning
                            DragGesture()
                                .updating($translationState) { value, state, _ in
                                    state = value.translation
                                }
                                .onEnded { value in
                                    self.cumulativeDrag = CGSize(width: self.cumulativeDrag.width + value.translation.width, height: self.cumulativeDrag.height + value.translation.height)
                                }
                        )
                )
                .overlay( // Add the overlay
                    Button(action: { showInfo.toggle() }) {
                        Image(systemName: "info.square.fill")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .padding()
                    },
                    alignment: .topTrailing
                )
                .alert(isPresented: $showInfo) {
                    Alert(title: Text("Image Information"), message: Text(imageDescription))
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
