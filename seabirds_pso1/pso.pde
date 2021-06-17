class Pso {
	private float x, y;
	private float vx, vy;
	private float r1, r2;	//[0,0.14] の範囲の値をとる乱数
	private float best_x;	//その粒子がこれまでに発見したベストな位置
	private float best_y;	//その粒子がこれまでに発見したベストな位置
	private float w = 0.5;//慣性定数
	private float[] old_best_x = new float[10];
	private float[] old_best_y = new float[10];

	public Pso() {
		x = random(dispSize);
		y = random(dispSize);
		vx = 0.01;
		vy = 0.01;
		best_x = x;
		best_y = y;
	}

	public float x() {
		return x;
	}

	public float y() {
		return y;
	}

	public float score() {
		return evaluation(x, y);
	}

	public void draw() {
		noStroke();
		fill(140, 50, 90);
		ellipse(x, y, 10, 10);
	}

	//座標の更新
	public void updatePosition() {
		x += vx;
		y += vy;
		
		if (x > dispSize) {
			x = 0;
		} else if (x < 0) {
			x = dispSize;
		}
		if (y > dispSize) {
			y = 0;
		} else if (y < 0) {
			y = dispSize;
		}
	}

	//ベストな座標の更新
	public void updateBest() {
		if ( evaluation( best_x, best_y ) > evaluation( x, y )){
			best_x = x;
			best_y = y;
		} 
	}

	//速度の更新
	public void updateVelocity(Global gb) {
		r1 = random(0, 0.14);
		r2 = random(0, 0.14);
		
		// 目的関数が変化するのでパーソナルベストが必ずしも最適とは限らない
		// 目的関数の結果が閾値より悪い時はパーソナルベストを無視して速度を更新する
		// if ( evaluation(best_x, best_y) > 5) {
		// 	float dummy_x = random(dispSize);
		// 	float dummy_y = random(dispSize);
		// 	vx = w * vx + r1 * (dummy_x - x) + r2 * (dummy_x - x);
		// 	vy = w * vy + r1 * (dummy_y - y) + r2 * (dummy_y - y);
		// } 
		
		// // 従来のPSOの速度の更新式
		// else {
			vx = w * vx + r1 * (best_x - x) + r2 * (gb.x() - x);
			vy = w * vy + r1 * (best_y - y) + r2 * (gb.y() - y);
		// }
	}


}