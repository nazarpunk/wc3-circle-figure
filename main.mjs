import {CircleFigure} from "./CircleFigure.mjs";

const canvas = document.createElement("canvas");
document.body.appendChild(canvas);

const ctx = canvas.getContext('2d');

let mx = window.innerWidth * .5,
    my = window.innerHeight * .5;

const cf = new CircleFigure(mx, my, 150, Math.PI * -0.5, 3);

addEventListener('click', e => {
    if (e.button === 0) cf.count += 1;
});
addEventListener('contextmenu', e => {
    e.preventDefault();
    cf.count -= 1;
});
addEventListener('mousemove', e => {
    mx = e.clientX;
    my = e.clientY;
    cf.x = mx;
    cf.y = my;
});
addEventListener('wheel', e => {
    e.preventDefault();
    if (e.ctrlKey) cf.angle += .1 * Math.sign(e.deltaY);
    else cf.radius += 10 * Math.sign(e.deltaY);
}, {passive: false});

const animate = time => {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    // radius
    ctx.beginPath();
    ctx.strokeStyle = '#626262';
    ctx.arc(cf.x, cf.y, cf.radius, 0, 2 * Math.PI);
    ctx.stroke();

    // angle
    ctx.beginPath();
    const xb = cf.x + cf.radius * Math.cos(cf.angle);
    const yb = cf.y + cf.radius * Math.sin(cf.angle);
    const gradient = ctx.createLinearGradient(cf.x, cf.y, xb, yb);
    gradient.addColorStop(0.00, '#d9069d');
    gradient.addColorStop(1.00, '#29bbbb');
    ctx.strokeStyle = gradient;
    ctx.moveTo(cf.x, cf.y);
    ctx.lineTo(xb, yb);
    ctx.stroke();

    // edges
    ctx.lineWidth = 2;
    for (const edge of cf.edges) {
        ctx.beginPath();
        const gradient = ctx.createLinearGradient(edge.xa, edge.ya, edge.xb, edge.yb);
        gradient.addColorStop(0.00, '#1ec50a');
        gradient.addColorStop(1.00, '#de120c');
        ctx.strokeStyle = gradient;

        ctx.moveTo(edge.xa, edge.ya);
        ctx.lineTo(edge.xb, edge.yb);
        ctx.stroke();
    }

    requestAnimationFrame(animate);
};

requestAnimationFrame(animate);
