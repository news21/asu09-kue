package com.news21.asu.kue.view
{
	import com.news21.asu.kue.ApplicationFacade;
	import com.news21.asu.kue.view.components.ImageCuePointForm;
	import com.news21.asu.util.PopManager;
	import com.news21.asu.kue.model.ProjectProxy;
	import com.news21.asu.kue.model.vo.MinifyVideoEvent;
	import com.news21.asu.kue.model.vo.PauseVideoEvent;
	import com.news21.asu.kue.model.vo.PauseVideoForDurationEvent;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.*;
	
	public class ImageCuePointFormMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'ImageCuePointFormMediator';
		public var projectProxy:ProjectProxy;
		
		public function ImageCuePointFormMediator( viewComponent:Object ) 
		{
			super( NAME, viewComponent );
			
			projectProxy = ProjectProxy( facade.retrieveProxy( ProjectProxy.NAME ) );
			
			imageCuePointForm.addEventListener(ImageCuePointForm.EVENT_DELETE_CUEPOINT, deleteCuePoint);
			imageCuePointForm.addEventListener(ImageCuePointForm.EVENT_SAVE_CUEPOINT, saveCuePoint);
			imageCuePointForm.addEventListener(ImageCuePointForm.EVENT_CLOSE_POPUP, closePopup);
			imageCuePointForm.addEventListener(ImageCuePointForm.EVENT_ADJUST_DURATION, adjustDuration);
			imageCuePointForm.addEventListener(ImageCuePointForm.EVENT_ADJUST_ENDTIME, adjustEndTime);
			imageCuePointForm.addEventListener(ImageCuePointForm.EVENT_SELECT_ASSET, showAssetChooser);
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
			var args:Object = {'atype':ApplicationFacade.ASSETTYPE_IMAGE,'filtername':ApplicationFacade.ASSETTYPE_IMAGE_CAMEL,'filters':ApplicationFacade.ASSETTYPE_IMAGE_FILTER};
			sendNotification(ApplicationFacade.SHOW_ASSET_CHOOSER,args);
		}
		
		public function updateAssetBtn():void
		{
			imageCuePointForm.assetvo.file_name = projectProxy.currentAsset.file_name;
			imageCuePointForm.assetvo.modified_by = projectProxy.currentAsset.modified_by;
			imageCuePointForm.assetvo.type = projectProxy.currentAsset.type;
			
			imageCuePointForm.aselectbtn.label = 'SELECTED';
			imageCuePointForm.savebtn.enabled = true;
		}
		
		public function get imageCuePointForm():ImageCuePointForm
		{
			return viewComponent as ImageCuePointForm;
		}
		
		public function deleteCuePoint(e:Event=null):void
		{
			sendNotification(ApplicationFacade.DELETE_CUEPOINT,imageCuePointForm.cuepointvo);
		}
		
		public function closePopup(e:Event=null):void {
			PopManager.closePopUpWindow( imageCuePointForm, NAME );
			sendNotification(ApplicationFacade.PLAY_CURRENT_VIDEO);
		}
		
		public function saveCuePoint(e:Event):void 
		{
			imageCuePointForm.assetvo.modified_by = projectProxy.currentUser;
			imageCuePointForm.assetvo.type = ApplicationFacade.ASSETTYPE_IMAGE;
			imageCuePointForm.cuepointvo.modified_by = projectProxy.currentUser;
			imageCuePointForm.cuepointvo.asset = imageCuePointForm.assetvo;
			imageCuePointForm.cuepointvo.type = imageCuePointForm.ctype.selectedLabel;
			imageCuePointForm.cuepointvo.name = imageCuePointForm.assetvo.type+'_'+imageCuePointForm.cuepointvo.time;
			
			if(imageCuePointForm.ceminify.selected)
				imageCuePointForm.cuepointvo.player_events.push(new MinifyVideoEvent());
				
			if(imageCuePointForm.cepauseduration.selected)			
				imageCuePointForm.cuepointvo.player_events.push(new PauseVideoForDurationEvent());
				
			if(imageCuePointForm.cepause.selected)
				imageCuePointForm.cuepointvo.player_events.push(new PauseVideoEvent());
			
			sendNotification(ApplicationFacade.SAVE_CUEPOINT, imageCuePointForm.cuepointvo);
		}
		
		public function adjustDuration(e:Event):void 
		{
			imageCuePointForm.cduration.value = imageCuePointForm.cendtime.value - imageCuePointForm.cstarttime.value;
		}
		
		public function adjustEndTime(e:Event):void 
		{
			imageCuePointForm.cendtime.value = imageCuePointForm.cstarttime.value + imageCuePointForm.cduration.value;
		}
		
	}
}