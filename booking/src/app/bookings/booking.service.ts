import { Injectable } from '@angular/core';
import { Booking } from './booking-mode';

@Injectable({
  providedIn: 'root'
})
export class BookingService {
  loadedBookings: Booking[];

  private _bookings: Booking[] = [
    {
      id: 'xyz',
      placeId: 'p1',
      placeTitle: "Manhattan Mansion",
      guesNumber: 2,
      userid: 'abc'
    }
  ]

  get bookings() {
    return [...this._bookings];
  }
}
