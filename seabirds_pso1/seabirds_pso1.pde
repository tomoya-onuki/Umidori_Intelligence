int dispSize = 800;
int NumOfPso = 100;
ArrayList<Pso> psoList = new ArrayList<Pso>();
Global globalBest;
float targetX, targetY;

// ArrayList<Sst> sstList = new ArrayList<Sst>();
float[][] Map = new float[80][80];


//評価関数:良い値は0
float evaluation(float x, float y){
	return abs(Map[int(x/10)][int(y/10)] - 15);
}


void settings() {
    size(dispSize, dispSize);
}

void setup() {
	frameRate(10);

	//psoを初期化
	for (int i = 0; i < NumOfPso; i++) {
		Pso pso = new Pso();
		psoList.add(pso);
	}

	// Mapの初期化
	for (int i = 0; i < 80; i++) {
        for (int j = 0; j < 80; j++) {
            float v = sin(0) * 20 - random(0.25 * i, 0.5 * i);
			if (v < 1) v = 1;
			if (v > 30) v = 30;
			Map[j][i] = v;
        }
    }

    // 現在のグローバルベストの初期化
	globalBest = new Global(psoList.get(0).x(), psoList.get(0).y());
	for (Pso pso : psoList) {
		globalBest.update(pso);
	}

	background(0);
	noLoop();
}



void draw(){
	background(120);

	// sstMapの生成&描画
	for (int i = 0; i < 80; i++) {
        for (int j = 0; j < 80; j++) {
            float v = ( sin( radians((frameCount / 10) % 10 * 18) ) + 1 ) * 20 - random(0.25 * (80-i), 0.5 * (80-i));
            colorMode(HSB, 360, 100, 100);
			if (v < 1) v = 1;
			if (v > 30) v = 30;
            // fill(v * 4 + 120, 100, 100);
            // stroke(v * 4 + 120, 100, 100);
            // rect(j * 10, i * 10, 10, 10);
			// 2色グラデーション
			float hue = 0;
			float sat = 50;
			float bri = 80;		
			if (0 < v && v < 15) {
				hue = 200;
				sat = (15 - v) / 15 * 100;
			} else if (v == 15) {
				hue = 0;
				sat = 0;
			} else if (15 < v && v <= 30) {
				hue = 10;
				sat = (v - 15) / 15 * 100;
			}
			
			stroke(hue, sat, bri);
			fill(hue, sat, bri);
			rect(j * 10, i * 10, 10, 10);
			Map[j][i] = v;
        }
    }

	// PSOの処理
	for (Pso pso : psoList) {
		pso.draw();						// 描画
		pso.updatePosition();			// 座標の更新
		pso.updateBest();				// パーソナルベストの更新	
		globalBest.update( pso );		// グローバルベストの更新
		pso.updateVelocity(globalBest);	// 速度の更新
	}

	// println("(x, y) = (" + globalBest.x() + ", " + globalBest.y() + "), score = " + evaluation(globalBest.x(), globalBest.y()));

	// 適温のマーカー
	PFont font = createFont("SourceCodePro-Regular", 10);
	textAlign(LEFT, TOP);
    textFont(font);

	String str0 = "Suitable temperature: 15℃";
	fill(0,0,0); noStroke();
	text(str0, 10, height-30);

	fill(0,0,100); stroke(0,0,0);
	rect(textWidth(str0)+20, height-29, 10, 10);

	fill(0,0,0); noStroke();
	text("SST (℃)", 10, height-70);

	for (int v = 0; v < 30; v++) {
		float h = 0;
		float s = 0;		
		if (v < 15) {
			h = 200;
			s = float(15 - v) / 15 * 100;
		} else if (v == 15) {
			h = 0;
			s = 0;
		} else if (15 < v) {
			h = 10;
			s = float(v - 15) / 15  * 100;
		}
		fill(h, s, 80); noStroke();
		rect(10 + v * 5, height-56, 5, 10);
	}
	noFill(); stroke(0, 0, 0);
	rect(10, height-56, 150, 10);
	
	fill(0,0,0); noStroke();
	text("0", 10, height-46);
	text("15", 80, height-46);
	text("30", 150, height-46);
}



void keyPressed() {
	if(key == 's') loop();
}