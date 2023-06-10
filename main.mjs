import {CircleFigure} from "./CircleFigure.mjs";

const canvas = document.createElement("canvas");
document.body.appendChild(canvas);

const ctx = canvas.getContext('2d');

const cf = new CircleFigure(3, 150, Math.PI * -0.5);

let mx = window.innerWidth * .5,
    my = window.innerHeight * .5;

addEventListener('click', e => {
    if (e.button === 0) cf.addCount(1);
});
addEventListener('contextmenu', e => {
    e.preventDefault();
    cf.addCount(-1);
});

addEventListener('mousemove', e => {
    mx = e.clientX;
    my = e.clientY;
});

addEventListener('wheel', e => {
    e.preventDefault();
    if (e.ctrlKey) cf.addAngle(.1 * Math.sign(e.deltaY));
    else cf.addRadius(10 * Math.sign(e.deltaY));
});


const animate = time => {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    // circle
    ctx.beginPath();
    ctx.strokeStyle = '#626262';
    ctx.arc(mx, my, cf.radius, 0, 2 * Math.PI);
    ctx.stroke();

    // radius
    ctx.beginPath();
    ctx.strokeStyle = '#910000';
    ctx.moveTo(mx, my);
    ctx.lineTo(mx + cf.radius * Math.cos(cf.angle), my + cf.radius * Math.sin(cf.angle));
    ctx.stroke();

    // edges
    ctx.beginPath();
    ctx.lineWidth = 2;
    ctx.strokeStyle = '#0bf122';
    for (let i = 1; i <= cf.list.length; i++) {
        const [px, py] = cf.list[i - 1];
        const [nx, ny] = cf.list[i % cf.list.length];
        ctx.moveTo(mx + px, my + py);
        ctx.lineTo(mx + nx, my + ny);
    }

    ctx.stroke();

    requestAnimationFrame(animate);
};

requestAnimationFrame(animate);
