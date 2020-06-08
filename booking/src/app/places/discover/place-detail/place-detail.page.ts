import {Component, OnDestroy, OnInit} from '@angular/core';
import {Router, ActivatedRoute} from '@angular/router';
import {NavController, ModalController, ActionSheetController, LoadingController} from '@ionic/angular';
import {Place} from '../../place.model';
import {PlacesService} from '../../places.service';
import {CreateBookingComponent} from '../../../bookings/create-booking/create-booking.component';
import {Subscription} from 'rxjs';
import {BookingService} from '../../../bookings/booking.service';
import {AuthService} from '../../../auth/auth.service';

@Component({
    selector: 'app-place-detail',
    templateUrl: './place-detail.page.html',
    styleUrls: ['./place-detail.page.scss'],
})
export class PlaceDetailPage implements OnInit, OnDestroy {
    place: Place;
    isBookable = false;
    private placeSub: Subscription;

    constructor(
        private router: ActivatedRoute,
        private navCtrl: NavController,
        private placeService: PlacesService,
        private modalCtrl: ModalController,
        private actionSheetCtrl: ActionSheetController,
        private bookingService: BookingService,
        private loadingCtrl: LoadingController,
        private authService: AuthService,
    ) {
    }

    ngOnInit() {
        this.router.paramMap.subscribe(paramMap => {
            if (!paramMap.has('placeId')) {
                this.navCtrl.navigateBack('/places/tabs/discover');
                return;
            }
            this.placeSub = this.placeService.getPlace(paramMap.get('placeId')).subscribe(place => {
                this.place = place;
                this.isBookable = place.userId !== this.authService.userID;
            });
        });
    }

    onBookPlace() {
        // this.router.navigateByUrl('/places/tabs/discover');
        // this.navCtrl.navigateBack('/places/tabs/discover');

        this.actionSheetCtrl.create({
            header: 'Choose an Action',
            buttons: [
                {
                    text: 'Select Date ',
                    handler: () => {
                        this.openBookingModal('select');
                    }
                },
                {
                    text: 'Random date',
                    handler: () => {
                        this.openBookingModal('random');
                    }
                },
                {
                    text: 'Cancel',
                    role: 'cancel'
                }
            ]
        }).then(acctionSheetEl => {
            acctionSheetEl.present();
        });
    }


    openBookingModal(mode: 'select' | 'random') {
        console.log(mode);
        this.modalCtrl
            .create({
                component: CreateBookingComponent,
                componentProps: {selectedPlace: this.place, selectedMode: mode}
            })
            .then(modalEl => {
                modalEl.present();
                return modalEl.onDidDismiss();
            })
            .then(resultData => {
                console.log(resultData.data, resultData.role);
                if (resultData.role === 'confirm') {
                    this.loadingCtrl.create({
                        message: 'Booking place...'
                    }).then(loadingEl => {
                        loadingEl.present();
                        const data = resultData.data.bookingData;
                        this.bookingService.addBooking(
                            this.place.id,
                            this.place.id,
                            this.place.id,
                            data.firstName,
                            data.lastName,
                            data.guestName,
                            data.startDate,
                            data.endDate,
                        ).subscribe(() => {
                            loadingEl.dismiss();
                        });
                    });

                }
            });
    }

    ngOnDestroy() {
        if (this.placeSub) {
            this.placeSub.unsubscribe();
        }
    }
}
