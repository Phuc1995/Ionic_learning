import {Injectable} from '@angular/core';
import {BehaviorSubject} from 'rxjs';
import {take, map, tap, delay, switchMap} from 'rxjs/operators';

import {Place} from './place.model';
import {AuthService} from '../auth/auth.service';
import {HttpClient} from '@angular/common/http';

interface PlaceData {
    availableFrom: string;
    availableTo: string;
    description: string;
    imageUrl: string;
    price: number;
    title: string;
    userId: string;
}

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
            'xyz'
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

    constructor(
        private authService: AuthService,
        private http: HttpClient,
    ) {
    }

    getPlace(id: string) {
        return this.places.pipe(take(1),
            map(places => {
                return {...places.find(p => p.id === id)};
            })
        );
    }

    fetchPlaces() {
        return this.http
            .get<{ [key: string]: PlaceData }>('https://ionic-angular-e49a4.firebaseio.com/offered-places.json')
            .pipe(map(resData => {
                    const place = [];
                    for (const key in resData) {
                        if (resData.hasOwnProperty(key)) {
                            place.push(
                                new Place(
                                    key,
                                    resData[key].title,
                                    resData[key].description,
                                    resData[key].imageUrl,
                                    resData[key].price,
                                    new Date(resData[key].availableFrom),
                                    new Date(resData[key].availableTo),
                                    resData[key].userId,
                                )
                            );
                        }
                    }
                    return place;
                }),
                tap(places => {
                    this._places.next(places);
                }));
    }

    addPlace(title: string,
             description: string,
             price: number,
             dateFrom: Date,
             dateTo: Date) {
        let generatedId: string;
        const newPlace = new Place(
            Math.random().toString(),
            title,
            description,
            'https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no',
            price,
            dateFrom,
            dateTo,
            this.authService.userID);
        return this.http.post<{ name: string }>('https://ionic-angular-e49a4.firebaseio.com/offered-places.json', {...newPlace, id: null})
            .pipe(
                switchMap(resData => {
                    generatedId = resData.name;
                    console.log(generatedId);
                    return this.places;
                }),
                take(1),
                tap(places => {
                    newPlace.id = generatedId;
                    this._places.next(places.concat(newPlace));
                })
            );
        // return this.places.pipe(take(1), delay(2000), tap(
        //     places => {
        //         this._places.next(places.concat(newPlace));
        //     }
        // ));
    }

    updatePlace(placeId: string, title: string, description: string) {
        let updatePlaces: Place[];
        return this.places.pipe(
            take(1),
            switchMap(places => {
                const updatedPlaceIndex = places.findIndex(pl => pl.id === placeId);
                console.log('updatedPlaceIndex: ' + updatedPlaceIndex);
                updatePlaces = [...places];
                const oldPlace = updatePlaces[updatedPlaceIndex];
                updatePlaces[updatedPlaceIndex] = new Place(
                    oldPlace.id,
                    title,
                    description,
                    oldPlace.imageUrl,
                    oldPlace.price,
                    oldPlace.availableFrom,
                    oldPlace.availableTo,
                    oldPlace.userId,
                );
                return this.http.put(`https://ionic-angular-e49a4.firebaseio.com/offered-places/${placeId}.json`,
                    {
                        ...updatePlaces[updatedPlaceIndex], id: null
                    });
            }),
            tap(() => {
                this._places.next(updatePlaces);
            })
        );
    }
}
