package com.news21.asu.kue.view
{
	import com.news21.asu.kue.ApplicationFacade;
	import com.news21.asu.kue.view.components.ExportPanel;
	import com.news21.asu.util.PopManager;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.*;
	
	public class ExportPanelMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'ExportPanelMediator';
		
		public function ExportPanelMediator( viewComponent:Object ) 
		{
			super( NAME, viewComponent );
			
			exportPanel.addEventListener(ExportPanel.EVENT_CLOSE_POPUP, closePopup);
		}

		override public function listNotificationInterests():Array 
		{
			return [ ];
		}

		override public function handleNotification( note:INotification ):void 
		{
			/*
			switch ( note.getName() ) {
				case DesktopCitizenConstants.WINDOW_READY:
					launchpopPrimary();
					break;
				
			}
			*/
		}
		
		public function get exportPanel():ExportPanel
		{
			return viewComponent as ExportPanel;
		}
		
		public function closePopup(e:Event):void {
			PopManager.closePopUpWindow( exportPanel, NAME );
		}
		
	}
}