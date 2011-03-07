package com.news21.asu.util
{
    import flash.events.*;
    import flash.net.*;

    public class XMLLoader extends EventDispatcher
    {
        private var urlRequest:URLRequest;
        private var urlLoader:URLLoader;
        private var xmlUrl:String;
        private var xml:XML;
        static public const XML_LOADED:String = "xmlLoaded";
        static public const CACHE_KILLER_ON:Boolean = false;

        public function XMLLoader(url:String)
        {
            xmlUrl = url;
        }

        public function load():void
        {
            if (CACHE_KILLER_ON) {
            	urlRequest = new URLRequest(xmlUrl+"?cache="+new Date().getTime());
            } else {
                urlRequest = new URLRequest(xmlUrl);
            }
            urlLoader = new URLLoader(urlRequest);
            urlLoader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
        }

        private function onComplete(e:Event):void
        {
        	trace(e.target.data)
            xml = new XML(e.target.data);
            dispatchEvent(new Event(XML_LOADED));
        }
		
		private function onIOError(e:IOErrorEvent):void
        {
            trace("Unable to load requested XML file: "+e.text);
        }
		
		public function getXML():XML
        {
            return xml;
        }
    }
}
