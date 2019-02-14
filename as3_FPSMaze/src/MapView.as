package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class MapView extends Sprite
	{
		private var _model:AppModel;
		
		private var _canvasScale:Number = 10;
		private var _fr:Rectangle;
		private var _canvasCols:int;
		private var _canvasRows:int;
		private var _canvas:Bitmap;
		
		
		public function MapView(model:AppModel)
		{
			_model = model;
			_canvasRows = _model.worldMap.length;
			_canvasCols = _model.worldMap[0].length;
			
			_fr = new Rectangle(0,0,_canvasCols, _canvasRows);
			
			var bmpd:BitmapData = new BitmapData(_canvasCols, _canvasRows, false, 0x000000);
			_canvas = new Bitmap(bmpd, PixelSnapping.ALWAYS, false);
			_canvas.scaleX = _canvas.scaleY = _canvasScale;
			addChild(_canvas);
		}
		
		public function update():void
		{
			var i:int, j:int;
			var map:Array = _model.worldMap;
			var bmpd:BitmapData = _canvas.bitmapData;
			bmpd.lock();
			bmpd.fillRect(_fr, 0x000022);
			for(i = 0; i < _canvasRows; i++)
			{
				for(j = 0; j < _canvasCols; j++)
				{
					if(map[i][j] == 1) bmpd.setPixel(j,i, 0x550000);
				}
			}
			bmpd.setPixel(_model.player.x,_model.player.y, 0x00ff00);
			bmpd.unlock();
			
		}
	}
}