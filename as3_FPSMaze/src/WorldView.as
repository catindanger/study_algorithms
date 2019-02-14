package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import vo.PlayerVO;
	
	public class WorldView extends Sprite
	{
		[Embed(source="bricks.png")]
		private var WallTexture:Class;
		
		private var _wallTexture:BitmapData;
		
		private var _model:AppModel;
		
		private var _canvasScale:Number = 2;
		private var _fr:Rectangle;
		private var _viewWidth:int;
		private var _viewHeight:int;
		private var _canvas:Bitmap;
		
		private var MAX_RAY_LENGTH:int;
		
		public function WorldView(model:AppModel)
		{
			_model = model;
			
			MAX_RAY_LENGTH = _model.worldMap.length;
			
			_viewWidth = 640;
			_viewHeight = 480;
			
			_fr = new Rectangle(0,0,_viewWidth, _viewHeight);
			
			_wallTexture = (new WallTexture() as Bitmap).bitmapData;
			
			
			var bmpd:BitmapData = new BitmapData(_viewWidth, _viewHeight, false, 0x000000);
			_canvas = new Bitmap(bmpd, PixelSnapping.ALWAYS, false);
			_canvas.scaleX = _canvas.scaleY = _canvasScale;
			addChild(_canvas);
			
			this.mouseEnabled = false;
		}
		
		private function abs(v:*):*
		{
			return v > 0 ? v : -v;
		}
		
		public function update():void
		{
			
			var debugR2G:Number = 180/Math.PI;
			
			var i:int, j:int;
			
			var map:Array = _model.worldMap;
			var mapHeight:int = map.length;
			var mapWidth:int = map[0].length;
			
			var player:PlayerVO = _model.player;
			
			var bmpd:BitmapData = _canvas.bitmapData;
			bmpd.lock();
			bmpd.fillRect(_fr, 0x000011);
			
			var checkmateCounter:int = 0;
			// scanning screen by vertical lines
			var prevHitTestX:Number = 0;
			var prevHitTestY:Number = 0;
			var hitTestX:int;
			var hitTestY:int;
			var hitTestPX:Number;
			var hitTestPY:Number;

			var deltaX:Number; 
			var deltaY:Number;
			var finalDelta:Number;

			
			var isHitWall:Boolean = false;
			var rayLength:Number = 0;
			var scanRayAngle:Number;
			var scanStepX:Number;
			var scanStepY:Number;

			var ceiling:int;
			var floor:int;
			var wallHeight:int; 
			
			var shading:Number;
			var component:uint;
			var texel:uint;
			
			var step:Number = 1;
			
			for(i = 0; i < _viewWidth; i++)
			{
				isHitWall = false;
				rayLength = 0;
				// - Math.PI because of opposite looking angle
				scanRayAngle = (player.lookDirection - Math.PI) + player.FOV/2 - i /_viewWidth * player.FOV;
				scanStepX = Math.sin(scanRayAngle);
				scanStepY = Math.cos(scanRayAngle);
				
				
				while(!isHitWall && rayLength < MAX_RAY_LENGTH)
				{
					rayLength += 0.05;
					hitTestPX = player.x + rayLength * scanStepX;
					hitTestPY = player.y + rayLength * scanStepY;
					hitTestX = hitTestPX;
					hitTestY = hitTestPY;
					if(hitTestX < 0 || hitTestX > mapWidth || hitTestY < 0 || hitTestY > mapHeight)
					{
						// in case when casting ray is out of map
						isHitWall = true;
						rayLength = MAX_RAY_LENGTH;
					}
					else
					{
						// hit the wall
						if(map[hitTestY][hitTestX] == 1)
						{
							isHitWall = true;
						}
					}
				}
				
				// calculating ceiling and floor
				ceiling= _viewHeight/2 - _viewHeight/rayLength;
				floor= _viewHeight - ceiling;
				wallHeight= floor - ceiling; 
				
				// between earth and heavens
				shading  = (1 - rayLength/MAX_RAY_LENGTH) * 0.99;
				deltaX= hitTestPX - hitTestX; 
				deltaY= hitTestPY - hitTestY;
				finalDelta= 0;

				if( abs(hitTestPX - prevHitTestX) > abs(hitTestPY - prevHitTestY))
					finalDelta = deltaX;
				else
					finalDelta = deltaY;
				
				for(j = 0; j < _viewHeight; j++)
				{
					if(j < _viewHeight/2)
					{
						component = 80 * (1 - j/(_viewHeight/2));
						bmpd.setPixel(i, j, component << 16 | 0 << 8 | 0 );
					}
					else
					{
						component = 80 * (j/(_viewHeight/2) - 1);
						bmpd.setPixel(i, j, 0 << 16 | component << 8 | 0 );
					}
					if(shading < 0.13) continue;
					if(j > ceiling && j < floor)
					{
						
						texel = _wallTexture.getPixel( finalDelta * _wallTexture.width, (j - ceiling) / wallHeight * _wallTexture.height);
						texel = ((texel >> 16) * shading) << 16 | (((texel >> 8) & 0xff) * shading) << 8 | (texel & 0xff) * shading;
						bmpd.setPixel(i, j, texel);
					}
				}
				
				prevHitTestX = hitTestPX;
				prevHitTestY = hitTestPY;
			}
			bmpd.unlock();
		}
	}
}