import {Injectable} from '@angular/core';
import {BehaviorSubject} from 'rxjs';
import {take, map} from 'rxjs/operators';

import {Place} from './place.model';
import {AuthService} from '../auth/auth.service';

@Injectable({
    providedIn: 'root'
})
export class PlacesService {
    // tslint:disable-next-line:variable-name
    private _places = new BehaviorSubject<Place[]>([
        new Place(
            'p1',
            'title 1',
            'Depresion 1',
            'https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no',
            149.99, new Date('2019-01-01'),
            new Date('2019-12-31'),
            'abc'
        ),
        new Place('12',
            'title 2',
            'Depresion 2',
            'https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no',
            99.99,
            new Date('2019-01-01'),
            new Date('2019-12-31'),
            'abc'
        ),
        new Place('p3',
            'title 3',
            'Depresion 3',
            'https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no',
            129.99,
            new Date('2019-01-01'),
            new Date('2019-12-31'),
            'abc'
        ),
        new Place('p4',
            'title 4',
            'Depresion 4',
            'https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no',
            159.99,
            new Date('2019-01-01'),
            new Date('2019-12-31'),
            'abc'
        ),
    ]);

    get places() {
        return this._places.asObservable();
    }

    constructor(private authService: AuthService) {
    }

    getPlace(id: string) {
        return this.places.pipe(take(1),
            map(places => {
                return {...places.find(p => p.id === id)};
            })
        );
    }

    addPlace(title: string,
             description: string,
             price: number,
             dateFrom: Date,
             dateTo: Date) {
        const newPlace = new Place(
            Math.random().toString(),
            title,
            description,
            'https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no',
            price,
            dateFrom,
            dateTo,
            this.authService.userID);
        this.places.pipe(take(1)).subscribe(places => {
            this._places.next(places.concat(newPlace));
        });

    }
}
