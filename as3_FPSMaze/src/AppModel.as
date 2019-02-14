package
{
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import vo.PlayerVO;

	public class AppModel
	{
		private var _player:PlayerVO;
		private var _worldMap:Array;
		
		
		public function AppModel()
		{
		}
		
		public function initializeWorld():void
		{
			_worldMap = [
				[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
				[1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
				[1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1],
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
				[1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
				[1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
				[1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
				[1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
				[1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
				[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]];

/*			_worldMap = [
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]];
*/			
			_player = new PlayerVO;
			_player.x = 7.5;
			_player.y = 14.5;

//			_player.x = 9.5;
//			_player.y = 10.5;
			
			_player.FOV = 45/180 * Math.PI;
			_player.lookDirection = 0;
//			_player.lookDirection = 45/180* Math.PI;
		}

		//---------------------------------------------------------------------
		
		public function movePlayerByArrow(keyCode:uint):void
		{
			var dx:int = 0;
			var dy:int = 0;
			var ax:int = 0;
			switch(keyCode)
			{
				case Keyboard.UP:
					dy = -1;
					break;
				case Keyboard.DOWN:
					dy = 1;
					break;
				case Keyboard.Q:
					dx = -1;				
					break;
				case Keyboard.E:
					dx = 1;
					break;
				case Keyboard.LEFT:
					ax = 1;
					break;
				case Keyboard.RIGHT:
					ax = -1;
					break;
			}
			_player.lookDirection += ax/10;
			var px:int = _player.x + (dy * Math.sin(_player.lookDirection) +  dx * Math.sin(_player.lookDirection + Math.PI/2))/2;
			var py:int = _player.y + (dy * Math.cos(_player.lookDirection) +  dx * Math.cos(_player.lookDirection + Math.PI/2))/2;
			if(_worldMap[py][px] == 0)
			{
				_player.x += (dy * Math.sin(_player.lookDirection) +  dx * Math.sin(_player.lookDirection + Math.PI/2))/2;
				_player.y += (dy * Math.cos(_player.lookDirection) +  dx * Math.cos(_player.lookDirection + Math.PI/2))/2;
			}
			
		}
		
		//---------------------------------------------------------------------
		public function get worldMap():Array
		{
			return _worldMap;
		}
		
		public function get player():PlayerVO
		{
			return _player;
		}
		
	}
}
