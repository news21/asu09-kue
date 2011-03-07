package com.news21.asu.kue.view
{
	import com.news21.asu.kue.ApplicationFacade;
	import com.news21.asu.kue.model.ProjectProxy;
	import com.news21.asu.kue.model.vo.CuePoint;
	import com.news21.asu.kue.view.components.*;
	import com.news21.asu.util.PopManager;
	
	import flash.events.*;
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.*;
	import org.puremvc.as3.utilities.air.desktopcitizen.DesktopCitizenConstants;
	
	public class AppCanvasMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'AppCanvasMediator';
		public var projectProxy:ProjectProxy;
		
		public var primary_loaded:Boolean = false;
		
		public function AppCanvasMediator( viewComponent:Object ) 
		{
			super( NAME, viewComponent );
			
			projectProxy = ProjectProxy( facade.retrieveProxy( ProjectProxy.NAME ) );
			
			facade.registerMediator( new VideoTimelineMediator( appCanvas.vtimeline ) );	
			
			appCanvas.addEventListener(DesktopCitizenConstants.WINDOW_READY, launchpopPrimary);
			appCanvas.addEventListener(ApplicationFacade.SHOW_INIT_PROJECT, launchpopPrimary);
			appCanvas.addEventListener(ApplicationFacade.SHOW_FLASH, launchpopFlash);
			appCanvas.addEventListener(ApplicationFacade.SHOW_HTML, launchpopHTML);
			appCanvas.addEventListener(ApplicationFacade.SHOW_IMAGE, launchpopImage);
			appCanvas.addEventListener(ApplicationFacade.SHOW_LINK, launchpopLink);
			appCanvas.addEventListener(ApplicationFacade.SHOW_VIDEO, launchpopVideo);
			appCanvas.addEventListener(ApplicationFacade.EXPORT_PROJECT, launchpopupExport);
			appCanvas.addEventListener(ApplicationFacade.EDIT_CUEPOINT, editCuePoint);
		}

		override public function listNotificationInterests():Array 
		{
			return [ 	DesktopCitizenConstants.WINDOW_READY,
						ApplicationFacade.PROJECT_INITIALIZED,
						ApplicationFacade.PLAY_CURRENT_VIDEO,
						ApplicationFacade.CUE_POINT_SAVED,
						ApplicationFacade.CUEPOINT_XML_CHANGED
					];
		}

		override public function handleNotification( note:INotification ):void 
		{
			switch ( note.getName() ) {
				case DesktopCitizenConstants.WINDOW_READY:
					launchpopPrimary();
					break;
					
				case ApplicationFacade.PROJECT_INITIALIZED:
					setProjectLoaded();
					break;
				
				case ApplicationFacade.PLAY_CURRENT_VIDEO:
					appCanvas.kuePlayer.videoControls.play();
					break;
				
				case ApplicationFacade.CUE_POINT_SAVED:
					updateCuePointDG();
					break;
					
				case ApplicationFacade.CUEPOINT_XML_CHANGED:
					updateVideoPreview();
					break;
			}
		}
		
		private function get appCanvas():AppCanvas
		{
			return viewComponent as AppCanvas;
		}
		
		public function setProjectLoaded():void {
			primary_loaded = true;
			var projectproxy:ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
			//trace(projectproxy.primaryAssetFile.url);
			appCanvas.kuePlayer.videoSource.source = projectproxy.primaryAssetFile.url;
			appCanvas.kuePlayer.videoSource.load();
			updateCuePointDG();
		}
		
		public function launchpopPrimary(e:Event=null):void {
			if(!primary_loaded) {
				PopManager.openPopUpWindow( PrimaryAssetForm, PrimaryAssetFormMediator );
				primary_loaded = true;
			}
		}
		
		private function updateCuePointDG():void
		{
			var projectproxy:ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
			//trace('dg dp is '+ObjectUtil.toString(projectproxy.cue_points));
			appCanvas.cuepointDG.dataProvider = projectproxy.cue_points;
		}
		
		
		private function editCuePoint(e:Event=null):void
		{
			var selectedCP:CuePoint = appCanvas.cuepointDG.selectedItem.cuepoint;
			//trace(ObjectUtil.toString(selectedCP));
			switch (selectedCP.asset.type)
			{
				case "flash":
				//trace('flash');
					launchpopFlash(e,selectedCP);
				break;
				case "image":
				//trace('image');
					launchpopImage(e,selectedCP);
				break;
				case "html":
				//trace('html');
					launchpopHTML(e,selectedCP);
				break;
				case "link":
				//trace('link');
					launchpopLink(e,selectedCP);
				break;
				case "video":
				//trace('link');
					launchpopVideo(e,selectedCP);
				break;
			}
		}
		
		private function updateVideoPreview():void
		{
			if(projectProxy.project.cue_points.length > 0){
				var xml:XML = XML(projectProxy.generateFLVCoreCuePointsXML(projectProxy.project.cue_points.source));
				appCanvas.kuePlayer.parseXML4Kues(xml);
			}
		}
		
		private function pauseCurrentVideo():Number
		{
			appCanvas.kuePlayer.videoControls.pause();
			return int(Math.round(appCanvas.kuePlayer.videoSource.playheadTime));
		}
		
		public function launchpopFlash(e:Event,cp:CuePoint=null):void {
			var pevent:Object;
			var htime:int = pauseCurrentVideo();
			var pop:FlashCuePointForm = PopManager.openPopUpWindow( FlashCuePointForm, FlashCuePointFormMediator ) as FlashCuePointForm;
			pop.currentVideoTime = htime;
			if(cp!=null){
				pop.savebtn.enabled = true;
				pop.assetFile = cp.asset.file_name;
				
				pop.deletebtn.visible = true;
				pop.currentID = cp.cuepoint_id;
				pop.ctitle.text = cp.asset.title;
				pop.cstarttime.value = cp.time;
				pop.cduration.value = cp.duration;
				pop.cendtime.value = cp.time+cp.duration;
				
				for(var i:int=0;i<cp.player_events.length;i++)
				{
					pevent = cp.player_events[i].getPlayerEvent();
					switch (pevent.name)
					{
						case "minify-video":
							pop.ceminify.selected = true;
						break;
						case "pause-video":
							pop.cepause.selected = true;
						break;
						case "pause-video-for-duration":
							pop.cepauseduration.selected = true;
						break;
					}
				}
			}
		}
		
		public function launchpopVideo(e:Event,cp:CuePoint=null):void {
			var pevent:Object;
			var htime:int = pauseCurrentVideo();
			var pop:VideoCuePointForm = PopManager.openPopUpWindow( VideoCuePointForm, VideoCuePointFormMediator ) as VideoCuePointForm;
			pop.currentVideoTime = htime;
			if(cp!=null){
				pop.savebtn.enabled = true;
				pop.assetFile = cp.asset.file_name;
				
				pop.deletebtn.visible = true;
				pop.currentID = cp.cuepoint_id;
				pop.ctitle.text = cp.asset.title;
				pop.cstarttime.value = cp.time;
				pop.cduration.value = cp.duration;
				pop.cendtime.value = cp.time+cp.duration;
				
				for(var i:int=0;i<cp.player_events.length;i++)
				{
					pevent = cp.player_events[i].getPlayerEvent();
					switch (pevent.name)
					{
						case "minify-video":
							pop.ceminify.selected = true;
						break;
						case "pause-video":
							pop.cepause.selected = true;
						break;
						case "pause-video-for-duration":
							pop.cepauseduration.selected = true;
						break;
					}
				}
			}
		}
		
		public function launchpopHTML(e:Event,cp:CuePoint=null):void {
			var pevent:Object;
			var htime:int = pauseCurrentVideo();
			var pop:HTMLCuePointForm = PopManager.openPopUpWindow( HTMLCuePointForm, HTMLCuePointFormMediator ) as HTMLCuePointForm;
			pop.currentVideoTime = htime;
			if(cp!=null){
				pop.cbody.htmlText = cp.asset.body;
				
				pop.deletebtn.visible = true;
				pop.currentID = cp.cuepoint_id;
				pop.ctitle.text = cp.asset.title;
				pop.cstarttime.value = cp.time;
				pop.cduration.value = cp.duration;
				pop.cendtime.value = cp.time+cp.duration;
				
				for(var i:int=0;i<cp.player_events.length;i++)
				{
					pevent = cp.player_events[i].getPlayerEvent();
					switch (pevent.name)
					{
						case "minify-video":
							pop.ceminify.selected = true;
						break;
						case "pause-video":
							pop.cepause.selected = true;
						break;
						case "pause-video-for-duration":
							pop.cepauseduration.selected = true;
						break;
					}
				}
			}
		}
		
		public function launchpopLink(e:Event,cp:CuePoint=null):void {
			var pevent:Object;
			var htime:int = pauseCurrentVideo();
			var pop:LinkCuePointForm = PopManager.openPopUpWindow( LinkCuePointForm, LinkCuePointFormMediator ) as LinkCuePointForm;
			pop.currentVideoTime = htime;
			if(cp!=null){
				pop.clink.text = cp.asset.link;
				
				pop.deletebtn.visible = true;
				pop.currentID = cp.cuepoint_id;
				pop.ctitle.text = cp.asset.title;
				pop.cstarttime.value = cp.time;
				pop.cduration.value = cp.duration;
				pop.cendtime.value = cp.time+cp.duration;
				
				for(var i:int=0;i<cp.player_events.length;i++)
				{
					pevent = cp.player_events[i].getPlayerEvent();
					switch (pevent.name)
					{
						case "minify-video":
							pop.ceminify.selected = true;
						break;
						case "pause-video":
							pop.cepause.selected = true;
						break;
						case "pause-video-for-duration":
							pop.cepauseduration.selected = true;
						break;
					}
				}
			}
		}
		
		public function launchpopImage(e:Event,cp:CuePoint=null):void {
			var pevent:Object;
			var htime:int = pauseCurrentVideo();
			var pop:ImageCuePointForm = PopManager.openPopUpWindow( ImageCuePointForm, ImageCuePointFormMediator ) as ImageCuePointForm;
			pop.currentVideoTime = htime;
			if(cp!=null){
				pop.savebtn.enabled = true;
				pop.assetFile = cp.asset.file_name;
				
				pop.deletebtn.visible = true;
				pop.currentID = cp.cuepoint_id;
				pop.ctitle.text = cp.asset.title;
				pop.cstarttime.value = cp.time;
				pop.cduration.value = cp.duration;
				pop.cendtime.value = cp.time+cp.duration;
				
				for(var i:int=0;i<cp.player_events.length;i++)
				{
					pevent = cp.player_events[i].getPlayerEvent();
					switch (pevent.name)
					{
						case "minify-video":
							pop.ceminify.selected = true;
						break;
						case "pause-video":
							pop.cepause.selected = true;
						break;
						case "pause-video-for-duration":
							pop.cepauseduration.selected = true;
						break;
					}
				}
			}
		}
		
		public function launchpopupExport(e:Event):void {
			var htime:Number = pauseCurrentVideo();
			var pop:ExportPanel = PopManager.openPopUpWindow( ExportPanel, ExportPanelMediator ) as ExportPanel;
			sendNotification(ApplicationFacade.EXPORT_PROJECT);
		}
	}
}