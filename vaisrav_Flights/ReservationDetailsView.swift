//
//  ReservationDetailsView.swift
//  vaisrav_Flights
//
//  Created by Graphic on 2023-06-13.
//

import SwiftUI

struct ReservationDetailsView: View {
    @EnvironmentObject var reservationData: ReservationData
    let reservation: Reservation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Customer: \(reservation.customerName)")
            Text("Passport: \(reservation.passport)")
            Text("Departure Date: \(formattedDate(from: reservation.departureDate))")
            Text("Flight Number: \(reservation.flight.flightNumber)")
            Text("Departure City: \(reservation.flight.departureCity)")
            Text("Arrival City: \(reservation.flight.arrivalCity)")
            Text("Price: $\(String(format: "%.2f", reservation.flight.price))")
            Text("Booking Number: \(reservation.bookingNumber)")
            
            Spacer()
        }
        .padding()
        .navigationTitle("Reservation Details")
    }
    private func formattedDate(from date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            return dateFormatter.string(from: date)
        }
}

struct ReservationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let reservation = Reservation(customerName: "", passport: "", flight: Flight(flightNumber: "", departureCity: "", arrivalCity: "", distance: 0.0, airlineCarrier: ""), departureDate: Date())
        ReservationDetailsView(reservation: reservation)
    }
}
