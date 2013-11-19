$(function(){
	var id = window.location.pathname.split("/")[3];
	var render_dispenser = function(){
		$('#dispensers-container').html('');
		$('#bottle-holders-container').html('');
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
	};

	render_dispenser();

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

	Newine.get_and_render_collection('wines');

	var current_wine_id = 0;
	var current_bh_id = 0;
	$("#wines-container").on("click", ".select-wine", function(){
		console.log('click!');
		var wine_id = $(this).data('wine-id');
		$('.select-wine').css('background', '#FFFFFF');
		$('.select-wine[data-wine-id=' + wine_id + ']').css('background', '#EEAAAA');
		current_wine_id = wine_id;
	});

	$('#bottle-holders-container').on("click",".change-wine",function(){
		current_wine_id = $(this).data('wine-id');
		current_bh_id = $(this).data('bottle-holder-id');
		$('.select-wine[data-wine-id=' + current_wine_id + ']').css('background', '#EEAAAA');
		$("#change-wine-modal").modal('show');
	});

	$('#save-wine-change').click(function(){

		if(current_wine_id!=0){
			$.ajax({
				type: "POST",
				url: '/dispensers/bottle_holders/wine/' + current_bh_id + '.json',
				accept: 'json',
				dataType: 'json',
				data: JSON.stringify({wine_id: current_wine_id}),
				success: function(data){
					console.log('changed wine');
					$("#change-wine-modal").modal('hide');
					render_dispenser();
					
				}
			});
		}

	});
	$('#leave-empty').click(function(){

		
		$.ajax({
			type: "POST",
			url: '/dispensers/bottle_holders/wine/' + current_bh_id + '.json',
			accept: 'json',
			dataType: 'json',
			data: JSON.stringify({wine_id: null}),
			success: function(data){
				console.log('changed wine');
				$("#change-wine-modal").modal('hide');
				render_dispenser();
				
			}
		});
		

	});

});