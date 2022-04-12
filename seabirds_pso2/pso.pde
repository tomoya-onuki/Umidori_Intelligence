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
	
	public float bestScore() {
		return evaluation(best_x, best_y);
	}

	public void draw() {
		noStroke();
		// fill(140, 50, 90);
		fill(20, 53, 100);
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
		if ( bestScore() > score()){
			best_x = x;
			best_y = y;
		} 
	}

	//速度の更新
	public void updateVelocity(Global cb) {
		r1 = random(0, 0.14);
		r2 = random(0, 0.14);
		
		vx = w * vx + r1 * (best_x - x) + r2 * (cb.x() - x);
		vy = w * vy + r1 * (best_y - y) + r2 * (cb.y() - y);
	}


}