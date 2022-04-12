int dispSize = 800;
int NumOfPso = 100;
int NumOfCluster = int(NumOfPso / 10);
ArrayList<Pso> psoList = new ArrayList<Pso>();
ArrayList<Global> clusterBestList = new ArrayList<Global>();
Global globalBest;

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
	// size(600, 600);
	frameRate(10);

	surface.setTitle("Umidori Intelligence");

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

    // 現在のクラスタベストの初期化
	for (Pso pso : psoList) {
		int idx = int(psoList.indexOf(pso) % NumOfCluster);
		clusterBestList.add(idx, new Global(pso.x(), pso.y()));
		clusterBestList.get(idx).update(pso);
	}
	
	// 現在のグローバルベストの初期化
	float min = clusterBestList.get(0).score();
	globalBest = new Global();
	for (Global cb : clusterBestList) {
		if(min > cb.score()) {
			globalBest = cb;
		}
	}

	background(0);
	noLoop();
}



void draw(){
	background(120);

	// sstMapの生成&描画
	for (int i = 0; i < 80; i++) {
        for (int j = 0; j < 80; j++) {
            float v = ( sin( radians((frameCount / frameRate) % 10 * 18) ) + 1 ) * 20 - random(0.25 * (80 - i), 0.5 * (80 - i));
            colorMode(HSB, 360, 100, 100);
			if (v < 1) v = 1;
			if (v > 30) v = 30;

			// 2色グラデーション
			float hue = 0;
			float sat = 50;
			float bri = 100;		
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
			
			stroke(hue, sat, bri);
			fill(hue, sat, bri);
			rect(j * 10, i * 10, 10, 10);
			Map[j][i] = v;
        }
    }

	// PSOの処理
	for (Pso pso : psoList) {
		int idx = int(psoList.indexOf(pso) % NumOfCluster);
		Global cb = clusterBestList.get(idx);

		pso.draw();						// 描画
		pso.updatePosition();			// 座標の更新
		pso.updateBest();				// パーソナルベストの更新	
		cb.update( pso );				// グローバルベストの更新
		if (pso.bestScore() < 5) {
			pso.updateVelocity(cb);			// 速度の更新
		} else {
			pso.updateVelocity(globalBest);	
		}
	}

	// グローバルベスト更新
	for (Global cb : clusterBestList) {
		if(globalBest.score() > cb.score()) {
			globalBest = cb;
		}
	}


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
			h = 190;
			s = float(15 - v) / 15 * 100;
		} else if (v == 15) {
			h = 0;
			s = 0;
		} else if (15 < v) {
			h = 150;
			s = float(v - 15) / 15  * 100;
		}
		fill(h, s, 100); noStroke();
		rect(10 + v * 5, height-56, 5, 10);
	}
	noFill(); stroke(0, 0, 0);
	rect(10, height-56, 150, 10);
	
	fill(0,0,0); noStroke();
	text("0", 10, height-46);
	text("15", 80, height-46);
	text("30", 150, height-46);

	// for (Global cb : clusterBestList) {
	// 	println("(x, y) = (" + cb.x() + ", " + cb.y() + "), score = " + evaluation(cb.x(), cb.y()));
	// }
}

void keyPressed() {
	if(key == 's') loop();
}