//
//  ContentView.swift
//  vaisrav_Flights
//
//  Created by Graphic on 2023-06-13.
//

import SwiftUI

struct ContentView: View {
    @State private var arrivalAirport: String = ""
    @State private var selectedDate: Date = Date.now
    @State private var customerName : String = ""
    @State private var passportNumber : String = ""
    
    @State private var selectedFlight: Flight? = nil
    @State private var showReservationPrompt: Bool = false
    
    @ObservedObject var reservationData: ReservationData
    
    let flights = [
        Flight(flightNumber: "AM3116", departureCity: "ATL", arrivalCity: "MAD", distance: 6943.70, airlineCarrier: "Aeromexico"),
        Flight(flightNumber: "WS6463", departureCity: "ATL", arrivalCity: "AUS", distance: 1514.00, airlineCarrier: "Westjet"),
        Flight(flightNumber: "KL662", departureCity: "ATL", arrivalCity: "HKG", distance: 12538.51, airlineCarrier: "KLM")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Vaisrav Flights")
                .font(.title)
            
            Form {
                DatePicker("Travel Date: ", selection: $selectedDate, in: Date.now..., displayedComponents: .date)
                HStack{
                    Picker("Arrival Airport", selection: $selectedFlight) {
                        Text("No Selection").tag(nil as Flight?)
                        ForEach(flights, id: \.flightNumber) { flight in
                            Text("\(flight.arrivalCity)").tag(flight as Flight?)
                        }
                    }
                }
                HStack{
                    Text("Customer Name: ").padding(.trailing, 10)
                    Spacer()
                    TextField("Example: John Doe", text: $customerName)
                        .autocorrectionDisabled()
                }
                
                HStack {
                    Text("Passport Number : ").padding(.trailing, 10)
                    Spacer()
                    TextField("Example: 12345", text: $passportNumber)
                }
                
                if let flight = selectedFlight {
                    Section(header: Text("Flight Information")) {
                        Text("Flight: \(flight.flightNumber)")
                        Text("Operated By: \(flight.airlineCarrier)")
                        Text("Price: $\(String(format: "%.2f", flight.price))")
                    }
                }
                
                Button{
                    if let flight = selectedFlight {
                        
                        let reservation = Reservation(customerName: customerName, passport: passportNumber, flight: flight, departureDate: selectedDate)
                        
                        reservationData.reservations.append(reservation)
                        
                        print("Reservation created: \(reservation)")
                        
                        arrivalAirport = ""
                        selectedDate = Date()
                        customerName = ""
                        passportNumber = ""
                        
                        selectedFlight = nil
                        showReservationPrompt = true
                    }
                } label: {
                    Text("Book Flight")
                }
                .buttonStyle(.borderedProminent)
                .disabled(customerName.isEmpty || passportNumber.isEmpty)
            }
            
        }
        .alert(isPresented: $showReservationPrompt) {
            Alert(
                title: Text("Reservation Successful"),
                message: Text("Your flight reservation has been successfully booked."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct Flight: Hashable {
    var flightNumber : String
    var departureCity : String
    var arrivalCity : String
    var distance : Double
    var airlineCarrier : String
    
    var price: Double {
        return 100 + (distance * 0.12)
    }
}

struct Reservation : Identifiable {
    var id = UUID()
    var customerName : String
    var passport : String
    var flight : Flight
    var departureDate : Date
    var bookingNumber: String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<5).map { _ in letters.randomElement()! })
    }
}

class ReservationData: ObservableObject {
    @Published var reservations: [Reservation] = []
}

struct TabbedView: View {
    @StateObject var reservationData = ReservationData()
    var body: some View {
        TabView {
            ContentView(reservationData: reservationData)
                        .environmentObject(reservationData)
                        .tabItem {
                            Label("Reservation", systemImage: "airplane")
                        }

                    ReservationHistoryView()
                        .environmentObject(reservationData)
                        .tabItem {
                            Label("History", systemImage: "clock")
                        }
                }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(reservationData: ReservationData())
    }
}


