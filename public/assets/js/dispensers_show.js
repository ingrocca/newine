$(function(){
	var id = window.location.pathname.split("/")[3];
	Newine.get_instance('dispensers','/id/' + id,function(ins){
		Newine.render_instance("dispensers",ins);
		$.each(ins.bottle_holders, function(i,bh){
			bh.wine_name = function(){ if(!(bh.wine === null || bh.wine === undefined)) return bh.wine.name; else return "Ninguno"; };
			Newine.render_instance('bottle-holders',bh);
		});
		
	});



});