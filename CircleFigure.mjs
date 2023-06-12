const normalize = angle => (angle % (2 * Math.PI) + 2 * Math.PI) % (2 * Math.PI);

class CircleFigureEdge {
    /**
     * @param {number} xa
     * @param {number} ya
     * @param {number} xb
     * @param {number} yb
     */
    constructor(xa, ya, xb, yb) {
        this.position(xa, ya, xb, yb);
    }

    /**
     * @param {number} xa
     * @param {number} ya
     * @param {number} xb
     * @param {number} yb
     */
    position(xa, ya, xb, yb) {
        this.xa = xa;
        this.ya = ya;
        this.xb = xb;
        this.yb = yb;
    }

    destroy() {
        console.log('☢️ Edge destroed!');
        return this;
    }
}

export class CircleFigure {

    /**
     * @param {number} x
     * @param {number} y
     * @param {number} count
     * @param {number} radius
     * @param {number} angle
     */
    constructor(x, y, radius, angle, count) {
        this.x = x;
        this.y = y;
        this.radius = radius;
        this.angle = angle;
        this.count = count;
        this.update();
    }

    /** @type {number} */ #x;
    /** @param {number} x */set x(x) {
        if (this.#x === x) return;
        this.#x = x;
        this.update();
    }

    /** @return {number} */get x() {
        return this.#x
    }

    /** @type {number} */ #y;
    /** @param {number} y */set y(y) {
        if (this.#y === y) return;
        this.#y = y;
        this.update();
    }

    /** @return {number} */get y() {
        return this.#y
    }

    /** @type {number} */ #radius;
    /** @param {number} radius */set radius(radius) {
        if (this.#radius === radius) return;
        this.#radius = Math.max(0, radius);
        this.update();
    }

    /** @return {number} */get radius() {
        return this.#radius
    }

    /** @type {number} */ #angle;
    /** @param {number} angle */set angle(angle) {
        if (this.#angle === angle) return;
        this.#angle = normalize(angle);
        this.update();
    }

    /** @return {number} */get angle() {
        return this.#angle
    }

    /** @type {number} */ #count;
    /** @param {number} count */set count(count) {
        if (this.#count === count) return;
        this.#count = Math.max(3, count);
        this.update()
    }

    /** @return {number} */get count() {
        return this.#count
    }

    /** @type {CircleFigureEdge[]} */edges = [];

    update() {
        if (this.#x === undefined || this.#y === undefined || this.#angle === undefined || this.#radius === undefined || this.#count === undefined) return;

        while (this.edges.length > 0 && this.edges.length > this.#count) {
            this.edges.pop().destroy();
        }
        const ad = 2 * Math.PI / this.count;
        let a = this.#angle;
        let xa = this.#x + this.#radius * Math.cos(a);
        let ya = this.#y + this.#radius * Math.sin(a);
        let xb, yb;
        for (let i = 0; i < this.count; i++) {
            a += ad;
            xb = this.#x + this.#radius * Math.cos(a);
            yb = this.#y + this.#radius * Math.sin(a);
            if (this.edges.length < i + 1) this.edges.push(new CircleFigureEdge(xa, ya, xb, yb));
            else this.edges[i].position(xa, ya, xb, yb);
            xa = xb;
            ya = yb;
        }
    }
}