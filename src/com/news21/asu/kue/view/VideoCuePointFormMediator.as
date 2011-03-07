package com.news21.asu.kue.view
{
	import com.news21.asu.kue.ApplicationFacade;
	import com.news21.asu.kue.model.ProjectProxy;
	import com.news21.asu.kue.model.vo.MinifyVideoEvent;
	import com.news21.asu.kue.model.vo.PauseVideoEvent;
	import com.news21.asu.kue.model.vo.PauseVideoForDurationEvent;
	import com.news21.asu.kue.view.components.VideoCuePointForm;
	import com.news21.asu.util.PopManager;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.*;
	
	public class VideoCuePointFormMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'VideoCuePointFormMediator';
		public var projectProxy:ProjectProxy;
		
		public function VideoCuePointFormMediator( viewComponent:Object ) 
		{
			super( NAME, viewComponent );
			
			projectProxy = ProjectProxy( facade.retrieveProxy( ProjectProxy.NAME ) );
			
			videoCuePointForm.addEventListener(VideoCuePointForm.EVENT_CLOSE_POPUP, closePopup);
			
			videoCuePointForm.addEventListener(VideoCuePointForm.EVENT_DELETE_CUEPOINT, deleteCuePoint);
			videoCuePointForm.addEventListener(VideoCuePointForm.EVENT_SAVE_CUEPOINT, saveCuePoint);
			videoCuePointForm.addEventListener(VideoCuePointForm.EVENT_ADJUST_DURATION, adjustDuration);
			videoCuePointForm.addEventListener(VideoCuePointForm.EVENT_ADJUST_ENDTIME, adjustEndTime);
			videoCuePointForm.addEventListener(VideoCuePointForm.EVENT_SELECT_ASSET, showAssetChooser);
		}

		override public function listNotificationInterests():Array 
		{
			return [ ApplicationFacade.CUE_POINT_SAVED,
					ApplicationFacade.ASSET_SELECTED
					 ];
		}

		override public function handleNotification( note:INotification ):void 
		{
			switch ( note.getName() ) {
				case ApplicationFacade.CUE_POINT_SAVED:
					closePopup();
					break;
				case ApplicationFacade.ASSET_SELECTED:
					updateAssetBtn();
					break;
			}
		}
		
		public function showAssetChooser(e:Event):void 
		{
			var args:Object = {'atype':ApplicationFacade.ASSETTYPE_VIDEO,'filtername':ApplicationFacade.ASSETTYPE_VIDEO_CAMEL,'filters':ApplicationFacade.ASSETTYPE_VIDEO_FILTER};
			sendNotification(ApplicationFacade.SHOW_ASSET_CHOOSER,args);
		}
		
		public function updateAssetBtn():void
		{
			videoCuePointForm.assetvo.file_name = projectProxy.currentAsset.file_name;
			videoCuePointForm.assetvo.modified_by = projectProxy.currentAsset.modified_by;
			videoCuePointForm.assetvo.type = projectProxy.currentAsset.type;
			
			videoCuePointForm.aselectbtn.label = 'SELECTED';
			videoCuePointForm.savebtn.enabled = true;
		}
		
		public function get videoCuePointForm():VideoCuePointForm
		{
			return viewComponent as VideoCuePointForm;
		}
		
		public function deleteCuePoint(e:Event=null):void
		{
			sendNotification(ApplicationFacade.DELETE_CUEPOINT,videoCuePointForm.cuepointvo);
		}
		
		public function closePopup(e:Event=null):void {
			PopManager.closePopUpWindow( videoCuePointForm, NAME );
			sendNotification(ApplicationFacade.PLAY_CURRENT_VIDEO);
		}
		
		public function saveCuePoint(e:Event):void 
		{
			videoCuePointForm.assetvo.modified_by = projectProxy.currentUser;
			videoCuePointForm.assetvo.type = ApplicationFacade.ASSETTYPE_VIDEO;
			videoCuePointForm.cuepointvo.modified_by = projectProxy.currentUser;
			videoCuePointForm.cuepointvo.asset = videoCuePointForm.assetvo;
			videoCuePointForm.cuepointvo.type = videoCuePointForm.ctype.selectedLabel;
			videoCuePointForm.cuepointvo.name = videoCuePointForm.assetvo.type+'_'+videoCuePointForm.cuepointvo.time;
			
			if(videoCuePointForm.ceminify.selected)
				videoCuePointForm.cuepointvo.player_events.push(new MinifyVideoEvent());
				
			if(videoCuePointForm.cepauseduration.selected)			
				videoCuePointForm.cuepointvo.player_events.push(new PauseVideoForDurationEvent());
				
			if(videoCuePointForm.cepause.selected)
				videoCuePointForm.cuepointvo.player_events.push(new PauseVideoEvent());
			
			sendNotification(ApplicationFacade.SAVE_CUEPOINT, videoCuePointForm.cuepointvo);
		}
		
		public function adjustDuration(e:Event):void 
		{
			videoCuePointForm.cduration.value = videoCuePointForm.cendtime.value - videoCuePointForm.cstarttime.value;
		}
		
		public function adjustEndTime(e:Event):void 
		{
			videoCuePointForm.cendtime.value = videoCuePointForm.cstarttime.value + videoCuePointForm.cduration.value;
		}
		
	}
}