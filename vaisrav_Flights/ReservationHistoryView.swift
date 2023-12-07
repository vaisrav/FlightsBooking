//
//  ReservationHistoryView.swift
//  vaisrav_Flights
//
//  Created by Graphic on 2023-06-13.
//

import SwiftUI

struct ReservationHistoryView: View {
    @EnvironmentObject var reservationData: ReservationData
    var body: some View {
        NavigationView {
            List {
                ForEach(reservationData.reservations) { reservation in
                    NavigationLink(destination: ReservationDetailsView(reservation: reservation)){
                        VStack() {
                            Text("Booking Number: \(reservation.bookingNumber)")
                            Text("Customer Name: \(reservation.customerName)")
                        }
                    }
                }
                .onDelete(perform: deleteReservation)
            }
        }
        .navigationTitle("Booking History")
    }
    private func deleteReservation(at offsets: IndexSet) {
        reservationData.reservations.remove(atOffsets: offsets)
    }

}


struct ReservationHistoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        ReservationHistoryView().environmentObject(ReservationData())
    }
}
