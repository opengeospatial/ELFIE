(function (window, undefined) {
    "use strict";

    var V = {};
	
	/**
	 * Create container for the chart results
	 *
	 * @method createContainer
	 * @param {String} id of the block who the container will be created
	 * @param {String} Name of the container
	 * @autor Zakaria Khattabi
	 **/
	V.createContainer = function(div, container){ // , style
		var htmlCode = "<div id=\""+container+"\" style=\"width:100%;height:100%;\"></div>";
		$("#"+div).html(htmlCode);
	}
	
	V.execute = function(){
		return "done executing "+name+" in the container "+container+" in the library "+library;
	}
	
    window.visu = V;
}(window));