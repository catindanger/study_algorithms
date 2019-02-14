package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class AppView extends Sprite
	{
		private var _model:AppModel;
		
		private var _mapView:MapView;
		private var _worldView:WorldView;
		
		public function AppView(model:AppModel)
		{
			_model = model;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init(e:*= null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_mapView = new MapView(_model);
			addChild(_mapView);
			
			_worldView = new WorldView(_model);
			addChild(_worldView);
			_worldView.x = _mapView.x + _mapView.width;
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKD);
			
			update();
		}
		
		private function onKD(event:KeyboardEvent):void
		{
			_model.movePlayerByArrow(event.keyCode);
			update();
		}
		
		private function update():void
		{
			_mapView.update();
			_worldView.update();
		}
	}
}