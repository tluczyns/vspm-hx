/**
 * View Section and Popup Manager (VSPM)  <https://github.com/tluczyns/vspm>
 * Frontend multilevel subpage manager developed according to MVC pattern.
 * VSPM is (c) 2009-2017 Tomasz Luczynski
 * Licensed under MIT License
 *
 * @author		Tomasz Luczynski <tluczyns@gmail.com> <http://www.programuje.pl>
 * @version		1.2
 */
package tl.vspm;

import tl.types.Singleton;
import flash.utils.Dictionary;
import flash.display.DisplayObjectContainer;

//import tl.types.DictionaryExt;
class ManagerPopup extends Singleton {
	public static var dictDescriptionViewPopup(get, never):Dictionary;

	
	//static private var _dictDescriptionViewPopup: DictionaryExt = new DictionaryExt();
	private static var _dictDescriptionViewPopup:Dictionary = new Dictionary();
	public static var dspObjContainerPopup:DisplayObjectContainer;
	
	public static function init(dspObjContainerPopup:DisplayObjectContainer):Void {
		ManagerPopup.dspObjContainerPopup = dspObjContainerPopup;
		StateModel.addEventListener(EventStateModel.CHANGE_PARAMETERS, ManagerPopup.checkAndHideOrShowPopupsOnParametersChange);
	}
	
	private static function checkAndHideOrShowPopupsOnParametersChange(e:EventStateModel):Void {
		for (ind in Reflect.fields(ManagerPopup._dictDescriptionViewPopup)) {
			var descriptionViewPopup:DescriptionViewPopup = ManagerPopup._dictDescriptionViewPopup[ind];
			descriptionViewPopup.checkAndHideShowView(e.data.oldParameters);
		}
	}
	
	private static function get_dictDescriptionViewPopup():Dictionary
	//DictionaryExt {
		
		return ManagerPopup._dictDescriptionViewPopup;
	}

	public function new() {
		super();
	}
}

