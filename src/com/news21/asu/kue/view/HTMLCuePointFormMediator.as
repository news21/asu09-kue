package com.news21.asu.kue.view
{
	import com.news21.asu.kue.ApplicationFacade;
	import com.news21.asu.kue.view.components.HTMLCuePointForm;
	import com.news21.asu.util.PopManager;
	import com.news21.asu.kue.model.ProjectProxy;
	import com.news21.asu.kue.model.vo.MinifyVideoEvent;
	import com.news21.asu.kue.model.vo.PauseVideoEvent;
	import com.news21.asu.kue.model.vo.PauseVideoForDurationEvent;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.*;
	
	public class HTMLCuePointFormMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'HTMLCuePointFormMediator';
		public var projectProxy:ProjectProxy;
		
		public function HTMLCuePointFormMediator( viewComponent:Object ) 
		{
			super( NAME, viewComponent );
			
			projectProxy = ProjectProxy( facade.retrieveProxy( ProjectProxy.NAME ) );
			
			htmlCuePointForm.addEventListener(HTMLCuePointForm.EVENT_DELETE_CUEPOINT, deleteCuePoint);
			htmlCuePointForm.addEventListener(HTMLCuePointForm.EVENT_CLOSE_POPUP, closePopup);
			htmlCuePointForm.addEventListener(HTMLCuePointForm.EVENT_SAVE_CUEPOINT, saveCuePoint);
			htmlCuePointForm.addEventListener(HTMLCuePointForm.EVENT_ADJUST_DURATION, adjustDuration);
			htmlCuePointForm.addEventListener(HTMLCuePointForm.EVENT_ADJUST_ENDTIME, adjustEndTime);
		}

		override public function listNotificationInterests():Array 
		{
			return [ ApplicationFacade.CUE_POINT_SAVED ];
		}

		override public function handleNotification( note:INotification ):void 
		{
			switch ( note.getName() ) {
				case ApplicationFacade.CUE_POINT_SAVED:
					closePopup();
					break;
				
			}
		}
		
		public function get htmlCuePointForm():HTMLCuePointForm
		{
			return viewComponent as HTMLCuePointForm;
		}
		
		public function deleteCuePoint(e:Event=null):void
		{
			sendNotification(ApplicationFacade.DELETE_CUEPOINT,htmlCuePointForm.cuepointvo);
		}
		
		public function closePopup(e:Event=null):void {
			PopManager.closePopUpWindow( htmlCuePointForm, NAME );
			sendNotification(ApplicationFacade.PLAY_CURRENT_VIDEO);
		}
		
		public function saveCuePoint(e:Event):void 
		{
			htmlCuePointForm.assetvo.modified_by = projectProxy.currentUser;
			htmlCuePointForm.assetvo.type = ApplicationFacade.ASSETTYPE_HTML;
			htmlCuePointForm.cuepointvo.modified_by = projectProxy.currentUser;
			htmlCuePointForm.cuepointvo.asset = htmlCuePointForm.assetvo;
			htmlCuePointForm.cuepointvo.type = htmlCuePointForm.ctype.selectedLabel;
			htmlCuePointForm.cuepointvo.name = htmlCuePointForm.assetvo.type+'_'+htmlCuePointForm.cuepointvo.time;
			
			if(htmlCuePointForm.ceminify.selected)
				htmlCuePointForm.cuepointvo.player_events.push(new MinifyVideoEvent());
				
			if(htmlCuePointForm.cepauseduration.selected)			
				htmlCuePointForm.cuepointvo.player_events.push(new PauseVideoForDurationEvent());
				
			if(htmlCuePointForm.cepause.selected)
				htmlCuePointForm.cuepointvo.player_events.push(new PauseVideoEvent());
			
			sendNotification(ApplicationFacade.SAVE_CUEPOINT, htmlCuePointForm.cuepointvo);
		}
		
		public function adjustDuration(e:Event):void 
		{
			htmlCuePointForm.cduration.value = htmlCuePointForm.cendtime.value - htmlCuePointForm.cstarttime.value;
		}
		
		public function adjustEndTime(e:Event):void 
		{
			htmlCuePointForm.cendtime.value = htmlCuePointForm.cstarttime.value + htmlCuePointForm.cduration.value;
		}
		
	}
}