class Global{
	private float x, y;

	public Global(float _x, float _y){
		x = _x;
		y = _y;
	}

	public float x() {
		return x;
	}

	public float y() {
		return y;
	}

	public void update(Pso pso){
		if ( evaluation(x, y) > pso.score() ){
			x = pso.x();
			y = pso.y();
		}
	}
}