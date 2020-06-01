import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { NavController, ModalController, ActionSheetController } from '@ionic/angular';
import { Place } from '../../place.model';
import { PlacesService } from '../../places.service';
import { CreateBookingComponent } from '../../../bookings/create-booking/create-booking.component';

@Component({
  selector: 'app-place-detail',
  templateUrl: './place-detail.page.html',
  styleUrls: ['./place-detail.page.scss'],
})
export class PlaceDetailPage implements OnInit {
  place: Place;

  constructor(
    private router: ActivatedRoute,
    private navCtrl: NavController,
    private placeService: PlacesService,
    private modalCtrl: ModalController,
    private actionSheetCtrl: ActionSheetController,
  ) { }

  ngOnInit() {
    this.router.paramMap.subscribe(paramMap => {
      if (!paramMap.has('placeId')) {
        this.navCtrl.navigateBack('/places/tabs/discover');
        return
      }
      this.place = this.placeService.getPlace(paramMap.get('placeId'));
    })
  }

  onBookPlace() {
    // this.router.navigateByUrl('/places/tabs/discover');
    // this.navCtrl.navigateBack('/places/tabs/discover');

    this.actionSheetCtrl.create({
      header: "Choose an Action",
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
    this.modalCtrl.create({ component: CreateBookingComponent, componentProps: { selectedPlace: this.place } })
      .then(modalEl => {
        modalEl.present();
        return modalEl.onDidDismiss();
      })
      .then(resultData => {
        console.log(resultData.data, resultData.role);
        if (resultData.role === 'confirm') {
          console.log('BOOKED!');
        }
      });
  }
}
