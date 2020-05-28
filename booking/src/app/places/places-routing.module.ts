import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { PlacesPage } from './places.page';

const routes: Routes = [
  {
    path: 'tabs',
    component: PlacesPage,
    children: [
      {
        path: 'discover',
        children: [
        {
          path: '',
          loadChildren: './discover/discover.module#DiscoverPageModule'
        },
        {
          path: ':placeId',
          loadChildren: './discover/place-deatail/place-deatail.module#PlaceDetailPageModule'
        },
      ]},
      {
        path: 'offers',
        children: [
          {
            path: '', 
            loadChildren: './offers/offers.module#OffersPageModule'
          },
          {
            path: 'new', 
            loadChildren: './offers/new-offers.module#NewOfferPageModule'
          },
          {
            path: 'edit/:placeId',
            loadChildren: './offers/edit-offer/edit-offer.module#EditOfferPageModule'
          },
          {
            path: ':placeId',
            loadChildren: './offers/offer-bookings/offer-bookings.module#OfferBookingsPageModule'
          },

        ]
      },
      {
        path: '',
        redirectTo: '/places/tabs/discover',
        pathMatch: 'full'
      }
    ]
  },
  {
    path: '',
    redirectTo: '/places/tabs/discover',
    pathMatch: 'full'
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class PlacesPageRoutingModule {}
