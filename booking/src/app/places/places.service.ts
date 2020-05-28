import { Injectable } from '@angular/core';
import { Place } from './place.model';
@Injectable({
  providedIn: 'root'
})
export class PlacesService {
  private _places: Place[] = [
    new Place("p1", "1", "A", "https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no", 1),
    new Place("p2", "2", "B", "https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no", 2),
  ];

  get places() {
    return [...this._places];
  }

  constructor() { }
}
