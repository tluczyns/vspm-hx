package tl.vspm.helper;

import flash.errors.Error;
import flash.display.Sprite;
import tl.vspm.DescriptionViewSection;
import tl.btn.BtnHit;
import tl.vspm.ManagerSection;
import tl.vspm.LoaderXMLContentView;
import tl.vspm.StateModel;
import tl.vspm.EventStateModel;
import tl.btn.InjectorBtnHitVSPM;
import tl.btn.EventBtnHit;
import flash.display.DisplayObjectContainer;
import tl.vspm.SWFAddress;
import tl.btn.InjectorBtnHit;
import tl.vspm.EventModel;

class Menu extends Sprite {
	private var containerBtns(get, never):DisplayObjectContainer;
	public var numActiveBtn(get, set):Int;
	public var isEnabled(never, set):Bool;

	
	public static inline var CHANGED_NUM_ACTIVE_BTN:String = "changedNumActiveBtn";
	
	private var vecDescriptionViewSectionForBtn:Vector<DescriptionViewSection>;
	private var lengthBaseIndSection:Int;
	private var isOpenSectionFromFirstBtn:Bool;
	private var _numActiveBtn:Int = -1;
	
	public var vecBtn:Vector<BtnHit>;
	
	public function new(baseIndSection:String, suffIndSectionForBtn:String = "all", suffIndSectionToExclude:String = "", isOpenSectionFromFirstBtn:Bool = true) {
		super();
		this.isOpenSectionFromFirstBtn = isOpenSectionFromFirstBtn;
		this.lengthBaseIndSection = ManagerSection.getLengthIndSection(baseIndSection);
		this.vecDescriptionViewSectionForBtn = Vector.ofArray(cast LoaderXMLContentView.dictIndViewSectionToVecDescriptionSubViewSection[baseIndSection]);
		if ((suffIndSectionForBtn != "all") || (suffIndSectionToExclude != "")) {
			this.vecDescriptionViewSectionForBtn = this.vecDescriptionViewSectionForBtn.filter(function(descriptionViewSection:DescriptionViewSection, i:Int, vec:Vector<DescriptionViewSection>):Bool {
								return (((suffIndSectionForBtn == "all") || (ManagerSection.getElementIndSection(this.lengthBaseIndSection, descriptionViewSection.indBase) == suffIndSectionForBtn))
								&& ((suffIndSectionToExclude == "") || (ManagerSection.getElementIndSection(this.lengthBaseIndSection, descriptionViewSection.indBase) != suffIndSectionToExclude)));
							}, this);
		}
		this.createBtns();
		if (this.isOpenSectionFromFirstBtn) {
			StateModel.addEventListener(EventStateModel.START_CHANGE_SECTION, this.checkAndOpenSectionFromFirstBtn);
			StateModel.addEventListener(EventStateModel.CHANGE_SECTION, this.checkAndOpenSectionFromFirstBtn);
			this.checkAndOpenSectionFromFirstBtn();
		}
		StateModel.addEventListener(EventStateModel.START_CHANGE_SECTION, this.checkAndSetBtnActive);
		StateModel.addEventListener(EventStateModel.CHANGE_SECTION, this.checkAndSetBtnActive);
	}
	
	private function createBtns():Void {
		this.createContainerBtn();
		this.vecBtn = new Vector<BtnHit>(this.vecDescriptionViewSectionForBtn.length);
		this.initArrangeBtns();
		var descriptionViewSection:DescriptionViewSection;
		for (i in 0...this.vecDescriptionViewSectionForBtn.length) {
			descriptionViewSection = this.vecDescriptionViewSectionForBtn[i];
			var classBtn:Class<Dynamic> = this.getClassBtn(descriptionViewSection);
			var btn:BtnHit = Type.createInstance(classBtn, [descriptionViewSection]);
			btn.addInjector(new InjectorBtnHitVSPM(descriptionViewSection));
			this.arrangeBtn(btn, i);
			btn.addEventListener(EventBtnHit.CLICKED, this.onBtnClicked);
			this.containerBtns.addChild(btn);
			this.vecBtn[i] = btn;
		}
		this.endArrangeBtns();
	}
	
	private function createContainerBtn():Void {
	}
	
	private function initArrangeBtns():Void {
	}
	
	private function get_containerBtns():DisplayObjectContainer {
		return this;
	}
	
	private function getClassBtn(descriptionViewSection:DescriptionViewSection):Class<Dynamic> {
		throw new Error("'protected function getClassBtn(descriptionViewSection: DescriptionViewSection): Class' must be implemented!");
	}
	
	private function arrangeBtn(btn:BtnHit, i:Int):Void {
	}
	
	private function endArrangeBtns():Void {
	}
	
	private function onBtnClicked(e:EventBtnHit):Void {
		this.setModelValue(this.getIndSectionForBtn(cast((e.target), BtnHit)));
	}
	
	private function setModelValue(indSection:String):Void {
		SWFAddress.setValueWithCurrentParameters(indSection);
	}
	
	public function getIndSectionForBtn(btn:BtnHit):String {
		var injectorVSPM:InjectorBtnHitVSPM = cast((btn.vecInjector.filter(function(injector:InjectorBtnHit, num:Int, vecInjector:Vector<InjectorBtnHit>):Bool {
							return Std.is(injector, InjectorBtnHitVSPM);
						})[0]), InjectorBtnHitVSPM);
		return injectorVSPM.descriptionView.ind;
	}
	
	private function deleteBtns():Void {
		for (i in 0...this.vecBtn.length) {
			var btn:BtnHit = this.vecBtn[i];
			this.containerBtns.removeChild(btn);
			btn.removeEventListener(EventBtnHit.CLICKED, this.onBtnClicked);
			btn.destroy();
			btn = null;
		}
		this.vecBtn = Vector.ofArray(cast []);
		this.deleteContainerBtns();
	}
	
	private function deleteContainerBtns():Void {
	}
	
	//open first btn
	
	private function checkAndOpenSectionFromFirstBtn(e:EventStateModel = null):Void {
		var indSection:String = ((e.type == EventStateModel.CHANGE_SECTION)) ? ManagerSection.currIndSection:ManagerSection.newIndSection;
		if ((ManagerSection.getElementIndSection(this.lengthBaseIndSection, indSection) == "") || (ManagerSection.dictDescriptionViewSection[indSection] == null)) {
			this.setModelValue(this.getIndSectionForBtn(this.vecBtn[0]));
		}
	}
	
	//set btn active
	
	private function checkAndSetBtnActive(e:EventStateModel):Void {
		var indSection:String = ((e.type == EventStateModel.CHANGE_SECTION)) ? ManagerSection.currIndSection:ManagerSection.newIndSection;
		var indSectionToMatchWithBtn:String = ManagerSection.getSubstringIndSection(0, this.lengthBaseIndSection + 1, indSection);
		var i:Int = 0;
		while ((i < this.vecDescriptionViewSectionForBtn.length) && (this.vecDescriptionViewSectionForBtn[i].ind != indSectionToMatchWithBtn)) 
		//(!ManagerSection.isEqualsElementsIndSection(this.vecDescriptionViewSectionForBtn[i].ind, indSection)){
			
			i++;
		}
		this.numActiveBtn = ((i < this.vecDescriptionViewSectionForBtn.length)) ? i:-1;
	}
	
	private function get_numActiveBtn():Int {
		return this._numActiveBtn;
	}
	
	private function set_numActiveBtn(value:Int):Int {
		if (value != this._numActiveBtn) {
			this._numActiveBtn = value;
			this.dispatchEvent(new EventModel(Menu.CHANGED_NUM_ACTIVE_BTN, value));
		}
		return value;
	}
	
	//
	
	private function set_isEnabled(value:Bool):Bool {
		for (btn/* AS3HX WARNING could not determine type for var: btn exp: EField(EIdent(this),vecBtn) type: null */ in this.vecBtn) {
			btn.isEnabled = value;
		}
		return value;
	}
	
	//
	
	public function destroy():Void {
		StateModel.removeEventListener(EventStateModel.START_CHANGE_SECTION, this.checkAndSetBtnActive);
		StateModel.removeEventListener(EventStateModel.CHANGE_SECTION, this.checkAndSetBtnActive);
		if (this.isOpenSectionFromFirstBtn) {
			StateModel.removeEventListener(EventStateModel.START_CHANGE_SECTION, this.checkAndOpenSectionFromFirstBtn);
			StateModel.removeEventListener(EventStateModel.CHANGE_SECTION, this.checkAndOpenSectionFromFirstBtn);
			this.checkAndOpenSectionFromFirstBtn();
		}
		this.deleteBtns();
	}
}

