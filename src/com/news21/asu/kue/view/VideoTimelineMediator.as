package com.news21.asu.kue.view
{
	import com.news21.asu.kue.ApplicationFacade;
	import com.news21.asu.kue.model.ProjectProxy;
	import com.news21.asu.kue.view.components.VideoTimeline;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.*;
	
	public class VideoTimelineMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'VideoTimelineMediator';
		public var projectProxy:ProjectProxy;
		
		public function VideoTimelineMediator( viewComponent:Object ) 
		{
			super( NAME, viewComponent );
			
			projectProxy = ProjectProxy( facade.retrieveProxy( ProjectProxy.NAME ) );
			
			//flashCuePointForm.addEventListener(FlashCuePointForm.EVENT_CLOSE_POPUP, closePopup);
		}

		override public function listNotificationInterests():Array 
		{
			return [	ApplicationFacade.PROJECT_INITIALIZED 
					];
		}

		override public function handleNotification( note:INotification ):void 
		{
			switch ( note.getName() ) {
				case ApplicationFacade.PROJECT_INITIALIZED:
					loadSnapshots();
					break;
					
				
			}
		}
		
		public function get videoTimeline():VideoTimeline
		{
			return viewComponent as VideoTimeline;
		}
		
		private function loadSnapshots():void
		{
			videoTimeline.initTimeline( projectProxy.primaryAssetFile.url );
		}
	}
}