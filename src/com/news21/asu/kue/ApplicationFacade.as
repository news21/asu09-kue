/*
  kore - Google Code Search for Adobe RIA Developers
  Copyright(c) 2007-08 Cliff Hall <clifford.hall@puremvc.org>
  Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package com.news21.asu.kue
{
	import com.news21.asu.kue.controller.*;
	import com.news21.asu.kue.model.*;
	import com.news21.asu.kue.view.*;
	
	import org.puremvc.as3.patterns.facade.*;
	import org.puremvc.as3.utilities.air.desktopcitizen.DesktopCitizenConstants;
	import org.puremvc.as3.utilities.air.desktopcitizen.controller.WindowOpenCommand;
	
	
	public class ApplicationFacade extends Facade
	{
		
		// Notification name constants
		public static const STARTUP:String = "startup";
		public static const SHUTDOWN:String = "shutdown";
		
		public static const SHOW_INIT_PROJECT:String = 'show_init_project';
		public static const SHOW_FLASH:String = 'show_flash';
		public static const SHOW_HTML:String = 'show_html';
		public static const SHOW_IMAGE:String = 'show_image';
		public static const SHOW_LINK:String = 'show_link';
		public static const SHOW_VIDEO:String = 'show_video';
		
		public static const NEW_PROJECT:String = 'new_project';
		public static const PROJECT_INITIALIZED:String = 'project_initialized';
		public static const EXPORT_PROJECT:String = 'export_project';
		
		public static const SHOW_PRIMARY_ASSET_CHOOSER:String = 'show_primary_asset_chooser';
		public static const PRIMARY_ASSET_SELECTED:String = 'primary_asset_selected'
		
		public static const SHOW_ASSET_CHOOSER:String = 'show_asset_chooser';
		public static const ASSET_SELECTED:String = 'asset_selected'
		public static const OPEN_EXISTING_PROJECT:String = 'open_existing_project'
		public static const CREATE_EXISTING_PROJECT:String = 'create_existing_project'
		
		public static const DELETE_CUEPOINT:String = 'delete_cuepoint'; 
		public static const EDIT_CUEPOINT:String = 'edit_cuepoint'; 
		public static const SAVE_CUEPOINT:String = 'save_cuepoint'; 
		public static const CUE_POINT_SAVED:String = 'cuepoint_saved'; 
		
		public static const PAUSE_CURRENT_VIDEO:String = 'pause_current_video';
		public static const PLAY_CURRENT_VIDEO:String = 'play_current_video';
		
		public static const CUEPOINT_XML_CHANGED:String = 'cuepoint_xml_changed';
		
		public static const ASSETTYPE_VIDEO:String = 'video';
		public static const ASSETTYPE_FLASH:String = 'flash';
		public static const ASSETTYPE_IMAGE:String = 'image';
		public static const ASSETTYPE_LINK:String = 'link';
		public static const ASSETTYPE_HTML:String = 'html';
		
		public static const ASSETTYPE_IMAGE_CAMEL:String = 'Images';
		public static const ASSETTYPE_FLASH_CAMEL:String = 'Flash SWFs';
		public static const ASSETTYPE_VIDEO_CAMEL:String = 'Flash FLVs';
		
		public static const ASSETTYPE_IMAGE_FILTER:String = '*.jpg; *.gif; *.png';
		public static const ASSETTYPE_FLASH_FILTER:String = '*.swf';
		public static const ASSETTYPE_VIDEO_FILTER:String = '*.flv';
		
		/**
		 * Singleton ApplicationFacade Factory Method
		 */
		public static function getInstance() : ApplicationFacade {
			if ( instance == null ) instance = new ApplicationFacade( );
			return instance as ApplicationFacade;
		}

		/**
		 * Register Commands with the Controller 
		 */
		override protected function initializeController( ) : void 
		{
			super.initializeController();
					
			registerCommand( STARTUP,  StartupCommand );
			registerCommand( SHUTDOWN, ShutdownCommand );
			registerCommand( DesktopCitizenConstants.WINDOW_OPEN, WindowOpenCommand );
			registerCommand( DesktopCitizenConstants.WINDOW_CLOSED, ShutdownCommand );
			
			registerCommand( SHOW_PRIMARY_ASSET_CHOOSER, CreatePrimaryAssetCommand );
			registerCommand( SHOW_ASSET_CHOOSER, CreateAssetCommand );
			registerCommand( NEW_PROJECT, CreateNewProjectCommand );
			registerCommand( DELETE_CUEPOINT, DeleteCuePointCommand );
			registerCommand( SAVE_CUEPOINT, SaveCuePointCommand );
			registerCommand( EXPORT_PROJECT, ExportProjectCommand );
			registerCommand( OPEN_EXISTING_PROJECT, OpenExistingProjectCommand );
			registerCommand( CREATE_EXISTING_PROJECT, CreateExistingProjectCommand );
		}

		/**
		 * The view hierarchy has been built, so start the application.
		 */
		public function startup( app:Kue ):void
		{
			sendNotification( STARTUP, app );
		}
		
	}
}