import chroma = require('chroma-js');
import $ = require('jquery');
declare var require: any;
import { Global } from './Global';
import { Pso } from './Pso'

$(function () {
    new main().init()
})

export class main {
    private psoList: Pso[] = []
    private globaBest: Global = new Global()
    private clusterBestList: Global[] = []
    private psoNum = 100
    private clusterNum = 10
    private map: number[][] = []

    private width: number
    private height: number

    private frameRate: number = 10
    private frameCount: number = 0

    constructor() {
        this.width = Number($('#main').width()) * devicePixelRatio
        this.height = Number($('#main').height()) * devicePixelRatio

    }

    public init() {
        const cvs: HTMLCanvasElement = <HTMLCanvasElement>$('#main')[0]
        const ctx: CanvasRenderingContext2D = <CanvasRenderingContext2D>cvs.getContext('2d')

        cvs.width = this.width
        cvs.height = this.height
        cvs.style.width = String(this.width / devicePixelRatio) + 'px'
        cvs.style.height = String(this.height / devicePixelRatio) + 'px'

        //psoを初期化
        for (let i = 0; i < this.psoNum; i++) {
            this.psoList.push(new Pso(this.width, this.height))
        }

        // Mapの初期化
        this.map = new Array(this.width)
        for (let i = 0; i < this.map.length; i++) {
            this.map[i] = new Array(this.height)
            for (let j = 0; j < this.map[i].length; j++) {
                let v: number = Math.sin(0) * 20 - (Math.random() * (0.5 - 0.25) + 0.25) * i

                if (v < 1) v = 1
                if (v > 30) v = 30
                this.map[i][j] = v
            }
        }

        // 現在のクラスタベストの初期化
        this.psoList.forEach(pso => {
            const idx: number = Math.round(this.psoList.indexOf(pso) % this.clusterNum)
            this.clusterBestList[idx] = new Global(pso.x, pso.y)
            this.clusterBestList[idx].score = this.evaluation(this.clusterBestList[idx].x, this.clusterBestList[idx].y)
            this.clusterBestList[idx].update(pso)
        })



        this.render(ctx)
    }

    private render(ctx: CanvasRenderingContext2D) {
        const me: main = this
        setInterval(function () {
            me.draw(ctx)
        }, 1000 / this.frameRate)
    }


    public draw(ctx: CanvasRenderingContext2D) {
        // sstMapの生成&描画
        for (let i = 0; i < this.map.length; i++) {
            for (let j = 0; j < this.map[i].length; j++) {
                let v: number = (Math.sin((this.frameCount / this.frameRate) % 10 * 18 * Math.PI / 180) + 1) * 20 - Math.random() * (0.5 - 0.25) * (80 - i) + 0.25 * (80 - i)
                if (v < 1) v = 1
                if (v > 30) v = 30

                // 2色グラデーション
                let hue = 0;
                let sat = 50;
                let bri = 100;
                if (0 < v && v < 15) {
                    hue = 150;
                    sat = (15 - v) / 15 * 100;
                } else if (v == 15) {
                    hue = 0;
                    sat = 0;
                } else if (15 < v && v <= 30) {
                    hue = 190;
                    sat = (v - 15) / 15 * 100;
                }

                let color = chroma.hsv(hue, sat, bri).css()
                ctx.strokeStyle = color
                ctx.fillStyle = color
                ctx.fillRect(j * 10, i * 10, 10, 10)

                this.map[i][j] = v
            }


            // PSOの処理
            this.psoList.forEach(pso => {
                let idx = Math.round(this.psoList.indexOf(pso) % this.clusterNum)
                let cb: Global = this.clusterBestList[idx]

                pso.draw(ctx)
                pso.updatePosition(this.width, this.height)
                pso.bestScore = this.evaluation(pso.best_x, pso.best_y)
                pso.score = this.evaluation(pso.x, pso.y)
                pso.updateBest()
                cb.score = this.evaluation(cb.x, cb.y)
                cb.update(pso)
                if (pso.bestScore < 5) {
                    pso.updateVelocity(cb, this.width, this.height)
                } else {
                    pso.updateVelocity(this.globaBest, this.width, this.height)
                }
            })

            this.clusterBestList.forEach(cb => {
                if (this.globaBest.score > cb.score) {
                    this.globaBest = cb
                }
            })
        }
    }
    private evaluation(x: number, y: number) {
        return Math.abs(this.map[Math.round(x / 10)][Math.round(y / 10)] - 15)
    }
}
