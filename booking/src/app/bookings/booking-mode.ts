export class Booking {
    constructor(
        public id: string,
        public placeId: string,
        public userid: string,
        public placeTitle: string,
        public guesNumber: number
    ) { }
}