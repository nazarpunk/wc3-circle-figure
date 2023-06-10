const normalize = angle => (angle % (2 * Math.PI) + 2 * Math.PI) % (2 * Math.PI);

export class CircleFigure {

    /**
     * @param {number} count
     * @param {number} radius
     * @param {number} angle
     */
    constructor(count, radius, angle) {
        this.count = count;
        this.radius = radius;
        this.angle = angle;
        this.rebuild();
    }

    /** @type {number[][]} */
    list = [];

    rebuild() {
        while (this.list.length > 0) this.list.pop();
        const ad = 2 * Math.PI / this.count;
        let a = this.angle;
        for (let i = 0; i < this.count; i++) {
            this.list.push([this.radius * Math.cos(a), this.radius * Math.sin(a)]);
            a += ad;
        }
    }

    /** @param {number} radius */
    addRadius(radius) {
        this.radius = Math.max(0, this.radius + radius);
        this.rebuild();
    }

    addAngle(angle) {
        this.angle = normalize(this.angle + angle);
        this.rebuild();
    }

    addCount(count) {
        this.count = Math.max(3, this.count + count);
        this.rebuild();
    }

}