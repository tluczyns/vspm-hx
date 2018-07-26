package tl.types;


class StringUtils {
	
	public function new() {
		super();
	}
	
	public static function isEmail(str:String):Bool {
		var posAt:Int = str.indexOf("@");
		var countAt:Int = 0;
		while (posAt != -1) {
			posAt = str.indexOf("@", posAt + 1);
			countAt++;
		}
		posAt = str.indexOf("@");
		var posLastDot:Int = str.lastIndexOf(".");
		var arrDomains:Array<Dynamic> = ["ac", "ad", "ae", "af", "ag", "ai", "al", "am", "an", "ao", "aq", "ar", "as", "at", "au", "aw", "ax", "az", "ba", "bb", "bd", "be", "bf", "bg", "bh", "bi", "bj", "bm", "bn", "bo", "br", "bs", "bt", "bw", "by", "bz", "ca", "cc", "cd", "cf", "cg", "ch", "ci", "ck", "cl", "cm", "cn", "co", "cr", "cu", "cv", "cx", "cy", "cz", "de", "dj", "dk", "dm", "do", "dz", "ec", "ee", "eg", "eo", "er", "es", "et", "eu", "fi", "fj", "fk", "fm", "fo", "fr", "ga", "gd", "ge", "gf", "gg", "gh", "gi", "gl", "gm", "gn", "gp", "gq", "gr", "gs", "gt", "gu", "gw", "gy", "hk", "hm", "hn", "hr", "ht", "hu", "id", "ie", "il", "im", "in", "io", "iq", "ir", "is", "it", "je", "jm", "jo", "jp", "ke", "kg", "kh", "ki", "km", "kn", "kp", "kr", "kw", "ky", "kz", "la", "lb", "lc", "li", "lk", "lr", "ls", "lt", "lu", "lv", "ly", "ma", "mc", "me", "md", "mg", "mh", "mk", "ml", "mm", "mn", "mo", "mp", "mq", "mr", "ms", "mt", "mu", "mv", "mw", "mx", "my", "mz", "na", "nc", "ne", "nf", "ng", "ni", "nl", "no", "np", "nr", "nu", "nz", "om", "pa", "pe", "pf", "pg", "ph", "pk", "pl", "pn", "pr", "ps", "pt", "pw", "py", "qa", "re", "ro", "rs", "ru", "rw", "sa", "sb", "sc", "sd", "se", "sg", "sh", "si", "sk", "sl", "sm", "sn", "sr", "st", "sv", "sy", "sz", "tc", "td", "tf", "tg", "th", "tj", "tk", "tl", "tm", "tn", "to", "tr", "tt", "tv", "tw", "tz", "ua", "ug", "uk", "us", "uy", "uz", "va", "vc", "ve", "vg", "vi", "vn", "vu", "wf", "ws", "ye", "za", "zm", "zw", "tp", "su", "yu", "bu", "bx", "fl", "wa", "biz", "com", "edu", "gov", "info", "int", "mil", "name", "net", "org", "pro", "aero", "cat", "coop", "jobs", "museum", "travel", "mobi", "arpa", "root", "post", "tel", "cym", "geo", "kid", "kids", "mail", "safe", "sco", "web", "xxx"];
		return cast((countAt == 1) && (posAt > 0) && (posLastDot != -1) && (posLastDot > posAt + 1) && (posLastDot < str.length - 1) && (Lambda.indexOf(arrDomains, str.substring(posLastDot + 1, str.length).toLowerCase()) != -1), Bool);
	}
	
	public static function moveOneLetterWordsToNewLine(str:String):String {
		var arrWord:Array<Dynamic> = str.split(" ");
		var strModified:String = "";
		for (i in 0...arrWord.length) {
			var word:String = arrWord[i];
			if (i != arrWord.length - 1) {
				if ((word.length == 1) || ((word.length == 2) && (new as3hx.Compat.Regex("[,.:;!?]")).test(word.charAt(1)))) {
					strModified += (word + String.fromCharCode(160));
				}
				//\u00A0
				else {
					strModified += (word + " ");
				}
			}
			else {
				strModified += word;
			}
		}
		return strModified;
	}
	
	public static function toUpperFirstToLowerRestEachWord(str:String):String {
		return str.split(" ").map(function(strElement:String, i:Int, array:Array<Dynamic>):String {
							return StringUtils.toUpperFirstToLowerRest(strElement);
						}).join(" ");
	}
	
	public static function toUpperFirstToLowerRest(str:String):String {
		return str.substring(0, 1).toUpperCase() + str.substring(1, str.length).toLowerCase();
	}
	
	public static function toUpperFirst(str:String):String {
		return str.substring(0, 1).toUpperCase() + str.substring(1);
	}
	
	public static function toLowerFirst(str:String):String {
		return str.substr(0, 1).toLowerCase() + str.substr(1);
	}
	
	public static function isUpper(char:String):Bool {
		return ("A" <= char) && (char <= "Z");
	}
	
	public static function isLower(char:String):Bool {
		return ("A" <= char) && (char <= "Z");
	}
	
	public static function toUnderscoreFromUpperOrCamelCase(str:String):String {
		var returnStr:String = "";
		var char:String;
		for (i in 0...str.length) {
			char = str.charAt(i);
			if ((i > 0) && (StringUtils.isUpper(char))) {
				returnStr += "_";
			}
			returnStr += char.toLocaleUpperCase();
		}
		return returnStr;
	}
	
	public static function toUpperCaseFromUnderscore(str:String):String {
		return str.split("_").map(function(strElement:String, i:Int, array:Array<Dynamic>):String {
							return StringUtils.toUpperFirst(strElement);
						}).join("");
	}
	
	public static function toCamelCaseFromUnderscore(str:String):String {
		return str.split("_").map(function(strElement:String, i:Int, array:Array<Dynamic>):String {
							return ((i == 0)) ? StringUtils.toLowerFirst(strElement):StringUtils.toUpperFirst(strElement);
						}).join("");
	}
	
	public static function removeMultipleSpaces(str:String):String {
		while (str.substr(0, 1) == " ") {
			str = str.substring(1);
		}
		while (str.indexOf("  ") != -1) {
			str = str.split("  ").join(" ");
		}
		while (str.substr(-1) == " ") {
			str = str.substr(0, str.length - 1);
		}
		return str;
	}
	
	public static function breakSentenceAndToUpperFirstToLowerRest(str:String):String {
		var arrWord:Array<Dynamic> = str.split(" ");
		for (i in 0...arrWord.length) {
			arrWord[i] = StringUtils.toUpperFirstToLowerRest(arrWord[i]);
		}
		return arrWord.join(" ");
	}
	
	public static function breakSentenceToLowerCaseUnderscore(str:String):String {
		var arrWord:Array<Dynamic> = str.split(" ");
		for (i in 0...arrWord.length) {
			arrWord[i] = Std.string(arrWord[i]).toLowerCase();
		}
		return arrWord.join("_");
	}
	
	public static function getDigitArray(str:String):Array<Dynamic> {
		var arrDigit:Array<Dynamic> = new Array<Dynamic>(str.length);
		for (i in 0...str.length) {
			arrDigit[i] = as3hx.Compat.parseFloat(str.charAt(i));
		}
		return arrDigit;
	}
	
	public static function createStrPrice(amountPrice:Float):String {
		var strPrice:String = Std.string(amountPrice).replace(".", ",");
		if (strPrice.indexOf(",") == -1) {
			strPrice += ",";
		}
		var posComma:Int = strPrice.indexOf(",");
		var countDigitsAfterComma:Int = as3hx.Compat.parseInt(strPrice.length - 1 - posComma);
		var precision:Int = 2;
		if (countDigitsAfterComma > precision) {
			strPrice = strPrice.substr(0, strPrice.length - (countDigitsAfterComma - precision));
		}
		else if (countDigitsAfterComma < precision) {
			for (i in countDigitsAfterComma...precision) {
				strPrice += "0";
			}
		}
		return strPrice;
	}
	
	public static function isEmpty(str:String):Bool {
		return ((str.valueOf() == "") || (str.valueOf() == "undefined") || (str.valueOf() == "null"));
	}
	
	public static function getFileExtension(nameFile:String):String {
		return nameFile.substr(nameFile.lastIndexOf(".") + 1);
	}
	
	public static function replace(str:String, p:Dynamic = null, repl:Dynamic = null):String {
		var strSrc:String;
		do {
			strSrc = str;
			str = strSrc.replace(p, repl);
		} while ((str != strSrc));
		return str;
	}
	
	public static function depolonize(str:String):String {
		var arrFrom:Array<Dynamic> = [" ", "-", ",", "'", "\"", "&", "#", "ą", "ę", "ł", "ó", "ć", "ś", "ń", "ż", "ź", "Ą", "Ę", "Ł", "Ó", "Ć", "Ś", "Ń", "Ż", "Ź"];
		var arrTo:Array<Dynamic> = ["_", "_", "_", "_", "_", "_", "_", "a", "e", "l", "o", "c", "s", "n", "z", "z", "A", "E", "L", "O", "C", "S", "N", "Z", "Z"];
		for (i in 0...arrFrom.length) {
			str = StringUtils.replace(str, arrFrom[i], arrTo[i]);
		}
		return str;
	}
	
	public static function addZerosBeforeNumberAndReturnString(number:Int, digitCount:Int):String {
		var numberStr:String = Std.string(number);
		while (numberStr.length < digitCount) {
			numberStr = "0" + numberStr;
		}
		return numberStr;
	}
}

