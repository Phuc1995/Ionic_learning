export class Booking {
    constructor(
        public id: string,
        public placeId: string,
        public userid: string,
        public placeTitle: string,
        public placeImage: string,
        public firtName: string,
        public lastName: string,
        public guesNumber: number,
        public bookedFrom: Date,
        public bookedTo: Date,
    ) {
    }
}
