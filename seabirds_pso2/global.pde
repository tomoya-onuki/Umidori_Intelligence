class Global{
	private float x, y;

	public Global(float _x, float _y){
		x = _x;
		y = _y;
	}
	
	public Global(){
	}

	public float x() {
		return x;
	}

	public float y() {
		return y;
	}

	public void update(Pso pso){
		if ( this.score() > pso.score() ){
			x = pso.x();
			y = pso.y();
		}
	}

	public float score() {
		return evaluation(x, y);
	}
}