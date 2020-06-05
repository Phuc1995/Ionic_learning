import {Component, OnInit} from '@angular/core';
import {FormGroup, FormControl, Validators} from '@angular/forms';
import {PlacesService} from '../../places.service';
import {Router} from '@angular/router';

@Component({
    selector: 'app-new-offer',
    templateUrl: './new-offer.page.html',
    styleUrls: ['./new-offer.page.scss'],
})
export class NewOfferPage implements OnInit {
    form: FormGroup;

    constructor(private placesService: PlacesService, private router: Router) {
    }

    ngOnInit() {
        this.form = new FormGroup({
            title: new FormControl(null, {
                updateOn: 'blur',
                validators: [Validators.required]
            }),
            description: new FormControl(null, {
                updateOn: 'blur',
                validators: [Validators.required, Validators.maxLength(180)]
            }),
            price: new FormControl(null, {
                updateOn: 'blur',
                validators: [Validators.required]
            }),
            dateFrom: new FormControl(null, {
                updateOn: 'blur',
                validators: [Validators.required]
            }),
            dateTo: new FormControl(null, {
                updateOn: 'blur',
                validators: [Validators.required]
            }),
        });
    }

    onCreateOffer() {
        if (!this.form.valid) {
            return;
        }
        console.log(this.form);
        this.placesService.addPlace(
            this.form.value.title,
            this.form.value.description,
            +this.form.value.price,
            this.form.value.dateFrom,
            this.form.value.dateTo,
        );
        this.form.reset();
        this.router.navigate(['/places/tabs/offers']);
    }

}
