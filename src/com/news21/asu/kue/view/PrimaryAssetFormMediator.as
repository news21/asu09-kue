package com.news21.asu.kue.view
{
	import com.news21.asu.kue.ApplicationFacade;
	import com.news21.asu.kue.model.vo.Asset;
	import com.news21.asu.kue.view.components.PrimaryAssetForm;
	import com.news21.asu.util.PopManager;
	import com.news21.asu.kue.model.ProjectProxy;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.*;
	
	public class PrimaryAssetFormMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'PrimaryAssetFormMediator';
		public var projectProxy:ProjectProxy;
		
		public function PrimaryAssetFormMediator( viewComponent:Object ) 
		{
			super( NAME, viewComponent );
			
			projectProxy = ProjectProxy( facade.retrieveProxy( ProjectProxy.NAME ) );
			
			primaryAssetForm.addEventListener(PrimaryAssetForm.EVENT_SELECT_PA, showPrimaryChooser);
			primaryAssetForm.addEventListener(PrimaryAssetForm.EVENT_CREATE_NEW_PROJECT, createNewProject);
			primaryAssetForm.addEventListener(PrimaryAssetForm.EVENT_OPEN_EXISTING_PROJECT, openExistingProject);
		}

		override public function listNotificationInterests():Array 
		{
			return [ ApplicationFacade.PRIMARY_ASSET_SELECTED, ApplicationFacade.PROJECT_INITIALIZED ];
		}

		override public function handleNotification( note:INotification ):void 
		{
			
			switch ( note.getName() ) {
				case ApplicationFacade.PRIMARY_ASSET_SELECTED:
					updatePrimaryAssetBtn();
					break;
				case ApplicationFacade.PROJECT_INITIALIZED:
					closePopup();
					break;
			}
			
		}
		
		public function get primaryAssetForm():PrimaryAssetForm
		{
			return viewComponent as PrimaryAssetForm;
		}
		
		public function closePopup():void {
			PopManager.closePopUpWindow( primaryAssetForm, NAME );
		}
		
		
		public function showPrimaryChooser(e:Event):void 
		{
			sendNotification(ApplicationFacade.SHOW_PRIMARY_ASSET_CHOOSER);
		}
		
		public function updatePrimaryAssetBtn():void
		{
			primaryAssetForm.paselectbtn.label = 'SELECTED';
			primaryAssetForm.newprojectbtn.enabled = true;
		}
		
		public function createNewProject(e:Event):void
		{
			sendNotification(ApplicationFacade.NEW_PROJECT, primaryAssetForm.projectvo);
		}
		
		public function openExistingProject(e:Event):void
		{
			sendNotification(ApplicationFacade.OPEN_EXISTING_PROJECT);
		}
	}
}