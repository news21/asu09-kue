package com.news21.asu.kue.view
{
	import com.news21.asu.kue.ApplicationFacade;
	import com.news21.asu.kue.model.ProjectProxy;
	import com.news21.asu.kue.model.vo.MinifyVideoEvent;
	import com.news21.asu.kue.model.vo.PauseVideoEvent;
	import com.news21.asu.kue.model.vo.PauseVideoForDurationEvent;
	import com.news21.asu.kue.view.components.FlashCuePointForm;
	import com.news21.asu.util.PopManager;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.*;
	
	public class FlashCuePointFormMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'FlashCuePointFormMediator';
		public var projectProxy:ProjectProxy;
		
		public function FlashCuePointFormMediator( viewComponent:Object ) 
		{
			super( NAME, viewComponent );
			
			projectProxy = ProjectProxy( facade.retrieveProxy( ProjectProxy.NAME ) );
			
			flashCuePointForm.addEventListener(FlashCuePointForm.EVENT_CLOSE_POPUP, closePopup);
			
			flashCuePointForm.addEventListener(FlashCuePointForm.EVENT_DELETE_CUEPOINT, deleteCuePoint);
			flashCuePointForm.addEventListener(FlashCuePointForm.EVENT_SAVE_CUEPOINT, saveCuePoint);
			flashCuePointForm.addEventListener(FlashCuePointForm.EVENT_ADJUST_DURATION, adjustDuration);
			flashCuePointForm.addEventListener(FlashCuePointForm.EVENT_ADJUST_ENDTIME, adjustEndTime);
			flashCuePointForm.addEventListener(FlashCuePointForm.EVENT_SELECT_ASSET, showAssetChooser);
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
			var args:Object = {'atype':ApplicationFacade.ASSETTYPE_FLASH,'filtername':ApplicationFacade.ASSETTYPE_FLASH_CAMEL,'filters':ApplicationFacade.ASSETTYPE_FLASH_FILTER};
			sendNotification(ApplicationFacade.SHOW_ASSET_CHOOSER,args);
		}
		
		public function updateAssetBtn():void
		{
			flashCuePointForm.assetvo.file_name = projectProxy.currentAsset.file_name;
			flashCuePointForm.assetvo.modified_by = projectProxy.currentAsset.modified_by;
			flashCuePointForm.assetvo.type = projectProxy.currentAsset.type;
			
			flashCuePointForm.aselectbtn.label = 'SELECTED';
			flashCuePointForm.savebtn.enabled = true;
		}
		
		public function get flashCuePointForm():FlashCuePointForm
		{
			return viewComponent as FlashCuePointForm;
		}
		
		public function deleteCuePoint(e:Event=null):void
		{
			sendNotification(ApplicationFacade.DELETE_CUEPOINT,flashCuePointForm.cuepointvo);
		}
		
		public function closePopup(e:Event=null):void {
			PopManager.closePopUpWindow( flashCuePointForm, NAME );
			sendNotification(ApplicationFacade.PLAY_CURRENT_VIDEO);
		}
		
		public function saveCuePoint(e:Event):void 
		{
			flashCuePointForm.assetvo.modified_by = projectProxy.currentUser;
			flashCuePointForm.assetvo.type = ApplicationFacade.ASSETTYPE_FLASH;
			flashCuePointForm.cuepointvo.modified_by = projectProxy.currentUser;
			flashCuePointForm.cuepointvo.asset = flashCuePointForm.assetvo;
			flashCuePointForm.cuepointvo.type = flashCuePointForm.ctype.selectedLabel;
			flashCuePointForm.cuepointvo.name = flashCuePointForm.assetvo.type+'_'+flashCuePointForm.cuepointvo.time;
			
			if(flashCuePointForm.ceminify.selected)
				flashCuePointForm.cuepointvo.player_events.push(new MinifyVideoEvent());
				
			if(flashCuePointForm.cepauseduration.selected)			
				flashCuePointForm.cuepointvo.player_events.push(new PauseVideoForDurationEvent());
				
			if(flashCuePointForm.cepause.selected)
				flashCuePointForm.cuepointvo.player_events.push(new PauseVideoEvent());
			
			sendNotification(ApplicationFacade.SAVE_CUEPOINT, flashCuePointForm.cuepointvo);
		}
		
		public function adjustDuration(e:Event):void 
		{
			flashCuePointForm.cduration.value = flashCuePointForm.cendtime.value - flashCuePointForm.cstarttime.value;
		}
		
		public function adjustEndTime(e:Event):void 
		{
			flashCuePointForm.cendtime.value = flashCuePointForm.cstarttime.value + flashCuePointForm.cduration.value;
		}
		
	}
}