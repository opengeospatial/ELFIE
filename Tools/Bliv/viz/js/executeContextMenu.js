//@author : Zakaria Khattabi
//Script enable to execute right click to see graph information
$(function(){
	$("#selector").contextMenu({
		selector: 'img', 
		callback: function(key, options) {
			//var m = "clicked: " + key;
			//window.console && console.log(m) || alert(m); 
			var alt=$(this).attr("alt");
			
			var name = alt.substring(alt.lastIndexOf("-"));
			name = name.replace("-", "");
			console.log(name);
			var userLang = "";
			($('#print').val()=="Print")?userLang="EN":userLang="FR";
				
			switch (key){
				case "nom":
					getNameGraph(name);
					break;
				case "doc":
					getDocGraph(name);
					break;
				case "des":
					getDesGraph(name, userLang);
					break;
			}
		},
		items: {
			"nom": {name: "Nom", icon: "info"},
			"doc": {name: "Documentation", icon: "link"},
			"sep1": "---------",
			"des": {"name": "Description","icon": "file"}
		}
	});
	
	function getNameGraph(name)
	{
		alert(name);
	}
	
	function getDocGraph(name)
	{
		var doc;
		$.ajax({
			type: 'GET',
			url: 'http://localhost:9091/sparql/save-request/graphs',
			dataType: 'json',
			success: function(data) {
				$.each(data.graphs, function(key, val) {
					if(val.name == name){
						doc = data.graphs[key].doc;
						$("input:hidden[name=graphDoc]").val(doc);
						//alert($("#graphDoc").val());
						window.open(doc);
					}
				});
			}
		});
	}
	
	function getDesGraph(name, userLang)
	{
		var doc;
		$.ajax({
			type: 'GET',
			url: 'http://localhost:9091/sparql/save-request/graphs',
			dataType: 'json',
			success: function(data) {
				$.each(data.graphs, function(key, val) {
					if(val.name == name){
						if(userLang == "FR"){
							graph = data.graphes[key];
					
							var result = '<br/><table style="border-collapse:collapse;width:90%;">';
							result = result+'<tr><th style="border:1px solid #a6c9e2;background-color:#4297D7;color:#FFFFFF;">Description <b>'+graph.name+'</b></th></tr>';
							result = result+'<tr><td style="border:1px solid #a6c9e2;">'+graph.description+'</td></tr>';
							result = result+'<tr><td style="border:1px solid #a6c9e2;"> De '+graph.paramMin+' à ';
							if(graph.paramMax == 11){
								result = result+' n paramètres</td></tr>';
							} else {
								result = result+' '+graph.paramMax+' paramètres</td></tr>';
							}
							if(graph.typeParam1 != "null"){
								result = result+'<tr><td style="border:1px solid #a6c9e2;">Paramètre 1';
								if(graph.Param1IsRequired)
									result = result+'* ';
								if(typeof graph.display1 === "undefined"){
									result = result+': '+graph.typeParam1+'</td></tr>';
								} else {
									result = result+': '+graph.display1+'</td></tr>';
								}
							}
							if(graph.typeParam2 != "null"){
								result = result+'<tr><td style="border:1px solid #a6c9e2;">Paramètre 2';
								if(graph.Param2IsRequired)
									result = result+'* ';
								if(typeof graph.display2 === "undefined"){
									result = result+': '+graph.typeParam2+'</td></tr>';
								} else {
									result = result+': '+graph.display2+'</td></tr>';
								}
							}
							if(graph.typeParam3 != "null"){
								result = result+'<tr><td style="border:1px solid #a6c9e2;">Paramètre 3';
								if(graph.Param3IsRequired)
									result = result+'* ';
								if(typeof graph.display3 === "undefined"){
									result = result+': '+graph.typeParam3+'</td></tr>';
								} else {
									result = result+': '+graph.display3+'</td></tr>';
								}
							}
							if(graph.typeParam4 != "null"){
								result = result+'<tr><td style="border:1px solid #a6c9e2;">Paramètre 4';
								if(graph.Param4IsRequired)
									result = result+'* ';
								if(typeof graph.display4 === "undefined"){
									result = result+': '+graph.typeParam4+'</td></tr>';
								} else {
									result = result+': '+graph.display4+'</td></tr>';
								}
							}
							if(graph.typeParam5 != "null"){
								result = result+'<tr><td style="border:1px solid #a6c9e2;">Paramètre 5';
								if(graph.Param5IsRequired)
									result = result+'* ';
								if(typeof graph.display5 === "undefined"){
									result = result+': '+graph.typeParam5+'</td></tr>';
								} else {
									result = result+': '+graph.display5+'</td></tr>';
								}
							}
							result = result+'<tr><td style="border:1px solid #a6c9e2;">Catégorie : '+graph.category+'</td></tr>';
							result = result+'<tr><td style="border:1px solid #a6c9e2;">Sous-catégorie : '+graph.subCategory+'</td></tr>';
							result = result+'<tr><td style="border:1px solid #a6c9e2;">&copy;&nbsp;Copyright : '+graph.author+'</td></tr>';
							result = result+'</table>';
							
							$("#description").html(result);
						} else {
							graph = data.graphs[key];
					
							var result = '<table style="border-collapse:collapse;width:90%;">';
							result = result+'<tr><th style="border:1px solid #a6c9e2;background-color:#4297D7;color:#FFFFFF;">Description <b>'+graph.name+'</b></th></tr>';
							result = result+'<tr><td style="border:1px solid #a6c9e2;">'+graph.description+'</td></tr>';
							result = result+'<tr><td style="border:1px solid #a6c9e2;">Name of graph : '+graph.name+'</td></tr>';
							result = result+'<tr><td style="border:1px solid #a6c9e2;">From '+graph.paramMin+' to ';
							if(graph.paramMax == 11){
								result = result+' n parameters</td></tr>';
							} else {
								result = result+' '+graph.paramMax+' parameters</td></tr>';
							}
							if(graph.typeParam1 != "null"){
								result = result+'<tr><td style="border:1px solid #a6c9e2;">Parameter 1';
								if(graph.Param1IsRequired)
									result = result+'* ';
								if(typeof graph.display1 === "undefined"){
									result = result+': '+graph.typeParam1+'</td></tr>';
								} else {
									result = result+': '+graph.display1+'</td></tr>';
								}
							}
							if(graph.typeParam2 != "null"){
								result = result+'<tr><td style="border:1px solid #a6c9e2;">Parameter 2';
								if(graph.Param2IsRequired)
									result = result+'* ';
								if(typeof graph.display2 === "undefined"){
									result = result+': '+graph.typeParam2+'</td></tr>';
								} else {
									result = result+': '+graph.display2+'</td></tr>';
								}
							}
							if(graph.typeParam3 != "null"){
								result = result+'<tr><td style="border:1px solid #a6c9e2;">Parameter 3';
								if(graph.Param3IsRequired)
									result = result+'* ';
								if(typeof graph.display3 === "undefined"){
									result = result+': '+graph.typeParam3+'</td></tr>';
								} else {
									result = result+': '+graph.display3+'</td></tr>';
								}
							}
							if(graph.typeParam4 != "null"){
								result = result+'<tr><td style="border:1px solid #a6c9e2;">Parameter 4';
								if(graph.Param4IsRequired)
									result = result+'* ';
								if(typeof graph.display4 === "undefined"){
									result = result+': '+graph.typeParam4+'</td></tr>';
								} else {
									result = result+': '+graph.display4+'</td></tr>';
								}
							}
							if(graph.typeParam5 != "null"){
								result = result+'<tr><td style="border:1px solid #a6c9e2;">Parameter 5';
								if(graph.Param5IsRequired)
									result = result+'* ';
								if(typeof graph.display5 === "undefined"){
									result = result+': '+graph.typeParam5+'</td></tr>';
								} else {
									result = result+': '+graph.display5+'</td></tr>';
								}
							}
							result = result+'<tr><td style="border:1px solid #a6c9e2;">Category : '+graph.category+'</td></tr>';
							result = result+'<tr><td style="border:1px solid #a6c9e2;">Sub-category : '+graph.subCategory+'</td></tr>';
							result = result+'<tr><td style="border:1px solid #a6c9e2;">&copy;&nbsp;Copyright : '+graph.author+'</td></tr>';
							result =  result + '</table>';
							
							$("#description").html(result);
						}
					}
				});
			}
		});
	}
});