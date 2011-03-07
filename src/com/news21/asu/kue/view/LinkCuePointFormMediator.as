package com.news21.asu.kue.view
{
	import com.news21.asu.kue.ApplicationFacade;
	import com.news21.asu.kue.model.ProjectProxy;
	import com.news21.asu.kue.model.vo.MinifyVideoEvent;
	import com.news21.asu.kue.model.vo.PauseVideoEvent;
	import com.news21.asu.kue.model.vo.PauseVideoForDurationEvent;
	import com.news21.asu.kue.view.components.LinkCuePointForm;
	import com.news21.asu.util.PopManager;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.*;
	
	public class LinkCuePointFormMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'LinkCuePointFormMediator';
		public var projectProxy:ProjectProxy;
		
		public function LinkCuePointFormMediator( viewComponent:Object ) 
		{
			super( NAME, viewComponent );
			
			projectProxy = ProjectProxy( facade.retrieveProxy( ProjectProxy.NAME ) );
			
			linkCuePointForm.addEventListener(LinkCuePointForm.EVENT_DELETE_CUEPOINT, deleteCuePoint);
			linkCuePointForm.addEventListener(LinkCuePointForm.EVENT_CLOSE_POPUP, closePopup);
			linkCuePointForm.addEventListener(LinkCuePointForm.EVENT_SAVE_CUEPOINT, saveCuePoint);
			linkCuePointForm.addEventListener(LinkCuePointForm.EVENT_ADJUST_DURATION, adjustDuration);
			linkCuePointForm.addEventListener(LinkCuePointForm.EVENT_ADJUST_ENDTIME, adjustEndTime);
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
		
		public function get linkCuePointForm():LinkCuePointForm
		{
			return viewComponent as LinkCuePointForm;
		}
		
		public function deleteCuePoint(e:Event=null):void
		{
			sendNotification(ApplicationFacade.DELETE_CUEPOINT,linkCuePointForm.cuepointvo);
		}
		
		public function closePopup(e:Event=null):void 
		{
			PopManager.closePopUpWindow( linkCuePointForm, NAME );
			sendNotification(ApplicationFacade.PLAY_CURRENT_VIDEO);
		}
		
		public function saveCuePoint(e:Event):void 
		{
			linkCuePointForm.assetvo.modified_by = projectProxy.currentUser;
			linkCuePointForm.assetvo.type = ApplicationFacade.ASSETTYPE_LINK;
			linkCuePointForm.cuepointvo.modified_by = projectProxy.currentUser;
			linkCuePointForm.cuepointvo.asset = linkCuePointForm.assetvo;
			linkCuePointForm.cuepointvo.type = linkCuePointForm.ctype.selectedLabel;
			linkCuePointForm.cuepointvo.name = linkCuePointForm.assetvo.type+'_'+linkCuePointForm.cuepointvo.time;
			
			if(linkCuePointForm.ceminify.selected)
				linkCuePointForm.cuepointvo.player_events.push(new MinifyVideoEvent());
				
			if(linkCuePointForm.cepauseduration.selected)			
				linkCuePointForm.cuepointvo.player_events.push(new PauseVideoForDurationEvent());
				
			if(linkCuePointForm.cepause.selected)
				linkCuePointForm.cuepointvo.player_events.push(new PauseVideoEvent());
			
			sendNotification(ApplicationFacade.SAVE_CUEPOINT, linkCuePointForm.cuepointvo);
		}
		
		public function adjustDuration(e:Event):void 
		{
			linkCuePointForm.cduration.value = linkCuePointForm.cendtime.value - linkCuePointForm.cstarttime.value;
		}
		
		public function adjustEndTime(e:Event):void 
		{
			linkCuePointForm.cendtime.value = linkCuePointForm.cstarttime.value + linkCuePointForm.cduration.value;
		}
		
	}
}