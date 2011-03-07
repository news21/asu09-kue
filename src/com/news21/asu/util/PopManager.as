package com.news21.asu.util
{
	import mx.managers.PopUpManager;
	import mx.core.IFlexDisplayObject;
	import com.news21.asu.kue.ApplicationFacade;
	import flash.display.Sprite;
	import mx.core.Application;
	
	public class PopManager extends PopUpManager
	{
		public static function openPopUpWindow( ComponentClass:Class, MediatorClass:Class ):IFlexDisplayObject
		{
			var window:IFlexDisplayObject = PopUpManager.createPopUp( Application.application as Sprite, ComponentClass, true );
			ApplicationFacade.getInstance().registerMediator( new MediatorClass( window ) );
			PopUpManager.centerPopUp( window );
			return window;
		}
		public static function closePopUpWindow( window:IFlexDisplayObject, mediatorName:String ):void
		{
			PopUpManager.removePopUp( window );
			ApplicationFacade.getInstance().removeMediator( mediatorName );
		}
	}

}