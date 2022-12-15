import { Pso } from './Pso'

export class Global {
    private _x: number
    private _y: number
    private _score: number = 100

    constructor();
    constructor(x1: number, y1: number);
    constructor(x1?: number, y1?: number) {
        this._x = x1 != null ? x1 : 0
        this._y = y1 != null ? y1 : 0
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


    public update(pso: Pso) {
        if (this.score > pso.score) {
            this.x = pso.x;
            this.y = pso.y;
        }
    }

    public get score(): number {
        return this._score
    }
    public set score(val: number) {
        this._score = val
    }
}