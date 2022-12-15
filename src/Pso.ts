import { Global } from './Global';

export class Pso {
    private _x: number = 0
    private _y: number = 0
    private vx: number = 0.01
    private vy: number = 0.01
    private r1: number
    private r2: number	//[0,0.14] の範囲の値をとる乱数
    private _best_x: number	//その粒子がこれまでに発見したベストな位置
    private _best_y: number	//その粒子がこれまでに発見したベストな位置
    private w: number = 0.5//慣性定数
    private old_best_x: number[] = new Array(10)
    private old_best_y: number[] = new Array(10)

    private _bestScore: number = 100
    private _score: number = 100

    constructor(w: number, h: number) {
        this._x = Math.random() * w
        this._y = Math.random() * h
        this._best_x = this._x
        this._best_y = this._y
        this.r1 = Math.random() * 0.14
        this.r2 = Math.random() * 0.14
    }

    public set x(v: number) {
        this._x = v
    }
    public get x(): number {
        return this._x
    }
    public set y(v: number) {
        this._y = v
    }
    public get y(): number {
        return this._y
    }
    public set best_x(v: number) {
        this._best_x = v
    }
    public get best_x(): number {
        return this._best_x
    }
    public set best_y(v: number) {
        this._best_y = v
    }
    public get best_y(): number {
        return this._best_y
    }


    public draw(ctx: CanvasRenderingContext2D) {
        ctx.fillStyle = '#00ff00'
        ctx.beginPath()
        ctx.arc(100, 100, 50, 0 * Math.PI / 180, 360 * Math.PI / 180, false)
        ctx.fill()
    }

    public updatePosition(w: number, h: number) {
        this.x += this.vx
        this.y += this.vy

        if (this.x > w) {
            this.x = 0
        } else if (this.x < 0) {
            this.x = w
        }
        if (this.y > h) {
            this.y = 0
        } else if (this.y < 0) {
            this.y = h
        }
    }

    public updateBest() {
        if(this.bestScore > this.score) {
            this.best_x = this.x
            this.best_y = this.y
        }
    }

    public updateVelocity(gb: Global, w: number, h: number) {
        this.r1 = Math.random() * 0.14
        this.r2 = Math.random() * 0.14

        this.vx = w * this.vx + this.r1 * (this.best_x - this.x) + this.r2 * (gb.x - this.x)
        this.vy = h * this.vx + this.r1 * (this.best_y - this.y) + this.r2 * (gb.y - this.y)
    }

    public get bestScore(): number {
        return this._bestScore
    }
    public set bestScore(val: number) {
        this._bestScore = val
    }

    public get score(): number {
        return this._score
    }
    public set score(val: number) {
        this._score = val
    }

}