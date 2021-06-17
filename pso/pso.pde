int SIZE = 100;
ArrayList<Pso> psoList = new ArrayList<Pso>();
Global globalBest;
Graph graph = new Graph();
float w = 0.5;//慣性定数
// 初期値の範囲
float minX = -10;//1*100
float maxX = 10;//10*100



//評価関数:良い値は小さい値
float evaluation(float x){
	return graph.func(x);
}

void setup() {
	size(800, 800);
	frameRate(60);
	init();
	noLoop();
}

void init() {
	//psoを初期化
	for (int i = 0; i < SIZE ; i++) {
		Pso pso = new Pso();
		pso.score = evaluation(pso.x);
		psoList.add(pso);
	}

	FloatList scoreList = new FloatList();
	for (Pso pso : psoList) {
		scoreList.append(pso.score);
	}
	globalBest = new Global(scoreList.min());
}

void draw(){
	translate(width/2, height-100);

	background(120);
	//グラフの描画
	graph.draw();

	float pre_globalBest_x = globalBest.x;


	for (Pso pso : psoList) {
		//描画
		pso.draw();
		//座標の更新
		pso.maxupdatePosition();
		//新しい位置での評価値を取得
		pso.score = evaluation( pso.x );
		//パーソナルベストの更新
		pso.updateBest();
		//グローバルベストの更新
		globalBest.update( pso.x, pso.score );
		//速度の更新
		pso.updateVelocity();
	}

}



class Global{
	float x, y;
	float score;

	Global(float _x){
		x = _x;
	}

	void update(float new_x, float _score){
		if( evaluation(x) > _score ){
			x = new_x;
		}
	}

	void draw() {
		stroke(255, 0, 0);
		strokeWeight(8);
		point(x*100, -evaluation(x)*100);
	}
}


class Pso {
	float x;
	float vx;
	float r1, r2;//[0,0.14] の範囲の値をとる乱数
	float best_x;//その粒子がこれまでに発見したベストな位置
	float score;

	Pso() {
		x = random(minX, maxX);
		vx = 0.01;
		best_x = x;
	}

	void draw() {
		stroke(0, 0, 255);
		strokeWeight(8);
		point(x*100, -score*100);
	}

	//座標の更新
	void maxupdatePosition() {
		x += vx;
	}

	//ベストな座標の更新
	void updateBest() {
		if ( evaluation( best_x ) > score ){
			best_x = x;
		}
	}

	//速度の更新
	void updateVelocity() {
		r1 = random(0, 0.14); r2 = random(0, 0.14);
		vx = w * vx + r1 * (best_x - x) + r2 * (globalBest.x - x);
	}

	void dump() {
		println("x = " + x + " , score = " + score);
	}
}

//グラフの描画
class Graph {
	int funcType = 2; 
	Graph() {

	}

	void setFuncType(int i) {
		funcType = i;
	}

	float func(float x) {
		switch (funcType) {
			case 0: return pow(x,4)+pow(x,3);
			case 1: return pow(log(x), 2);
			case 2: return pow(x,2);
		}

		return 0;
	}

	void draw() {
		strokeWeight(1); stroke(255);
		line(width/2, 0, -width, 0);
		line(0, height/2, 0, -height);
		//smooth();
		beginShape();
		for(float x = -100; x < 100; x+=0.001){
			point(x*100, -func(x)*100 );
		}
		endShape(CLOSE);
	}
}


//終了時のグローバルベストを出力
void dispose() {
	println(globalBest.x);
}

void mousePressed(){
	noLoop();
	background(0);
	graph.setFuncType(int(random(3)));
	init();
}

void keyPressed() {
	if(key == 's') loop();
}