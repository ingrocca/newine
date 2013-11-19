$(function(){
	var id = window.location.pathname.split("/")[3];
	Newine.get_instance('dispensers','/id/' + id,function(ins){
		Newine.render_instance("dispensers",ins);
		$.each(ins.bottle_holders, function(i,bh){
			bh.wine_name = function(){ if(!(bh.wine === null || bh.wine === undefined)) return bh.wine.name; else return "Ninguno"; };
			Newine.render_instance('bottle-holders',bh);
		});
		$.each(ins.bottle_holders, function(i,bh){
			var skillBar = $(".volume-inner[data-id=" + bh.id + "]");
		    var skillVal = skillBar.attr("data-progress");
		    $(skillBar).animate({
		        height: skillVal
		    }, 1500);
		});
		
	});

	var host = window.location.hostname;
	var sock = new WebSocket( "ws://" + host + ":8080");

	sock.onopen = function(){
	   sock.onmessage = function(evt){
	     	
	     	console.log(evt.data);
	     	data = JSON.parse(evt.data)
	     	
	     	if(!(data.serving === undefined)){
	     		var volume_percent = data.serving.volume_percent;
	     		var bh_id = data.serving.bottle_holder_id;
	     		var skillBar = $(".volume-inner[data-id=" + bh_id + "]");
	     		skillBar.attr('data-progress', "" + volume_percent + "%");
			    var skillVal = skillBar.attr("data-progress");
			    $(skillBar).animate({
			        height: skillVal
			    }, 1500);


	     	}
	     
	    }
	}



});