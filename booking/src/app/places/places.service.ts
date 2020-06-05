import { Injectable } from '@angular/core';
import { Place } from './place.model';
@Injectable({
  providedIn: 'root'
})
export class PlacesService {
  private _places: Place[] = [
    new Place("p1", "title 1", "Depresion 1", "https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no", 149.99, new Date('2019-01-01'), new Date('2019-12-31')),
    new Place("12", "title 2", "Depresion 2", "https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no", 99.99, new Date('2019-01-01'), new Date('2019-12-31')),
    new Place("p3", "title 3", "Depresion 3", "https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no", 129.99, new Date('2019-01-01'), new Date('2019-12-31')),
    new Place("p4", "title 4", "Depresion 4", "https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no", 159.99, new Date('2019-01-01'), new Date('2019-12-31')),
  ];

  get places() {
    return [...this._places];
  }

  constructor() { }

  getPlace(id: string) {
    return { ...this._places.find(p => p.id == id) };
  }
}
