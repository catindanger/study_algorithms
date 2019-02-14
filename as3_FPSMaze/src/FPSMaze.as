package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF (width="1200", height="800", frameRate="60", backgroundColor="#2f2f2f")]
	public class FPSMaze extends Sprite
	{
		private var _appModel:AppModel;
		private var _appView:AppView;
		
		public function FPSMaze()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:*= null):void
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_appModel = new AppModel;
			_appModel.initializeWorld();
			
			_appView = new AppView(_appModel);
			this.addChild(_appView);
		}
	}
}