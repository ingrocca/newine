$(function(){
	var id = window.location.pathname.split("/")[3];
	$('.loading-header').hide();
	var render_dispenser = function(){
		$('#dispensers-container').html('');
		$('#bottle-holders-container').html('');
		$('#bottle-holder-controls-container').html('');
		$('#temperature-controls-container').html('');
		Newine.get_instance('dispensers','/id/' + id,function(ins){
			Newine.render_instance("dispensers",ins);
			$.each(ins.bottle_holders, function(i,bh){
				bh.wine_name = function(){ if(!(bh.wine === null || bh.wine === undefined)) return bh.wine.name; else return "Ninguno"; };
				//bh.span = 100/ins.bottle_holders.length;
				if(ins.bottle_holders.length == 8){
					bh.span=10;
				}else{
					bh.span=20;
				}
				
				bh.n_bottles = ins.bottle_holders.length;
				
				Newine.render_instance('bottle-holders',bh);
				Newine.render_instance('bottle-holder-controls',bh);
			});

			$.each(ins.temperature_controls, function(i,tc){
				Newine.render_instance('temperature-controls',tc);
			});
			$.each(ins.bottle_holders, function(i,bh){
				var skillBar = $(".volume-inner[data-id=" + bh.id + "]");
			    var skillVal = skillBar.attr("data-progress");
			    $(skillBar).animate({
			        height: skillVal
			    }, 500);
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
			    }, 500);

			    $('.rem-volume[data-bottle-holder-id=' + bh_id + ']').html(data.serving.remaining_volume);


	     	}
	     	if(!(data.temperature_control === undefined)){
	     		var el = $(".temperature-input[data-temperature-control-id=" + data.temperature_control.id + "]");
	     		if(!(el === null || el === undefined)){
	     			el.val(data.temperature_control.temperature);
	     			el.effect('bounce');
	     		}
	     		
	     	}
	     	if(!(data.dispenser === undefined)){
	     		if (data.dispenser.id == id) {
	     			if(data.dispenser.online){
		     			$('#online_label').removeClass('label-danger');
			     		$('#online_label').addClass('label-success');
			     		$('#online_label').html('online');
		     		}else{
		     			$('#online_label').removeClass('label-success');
			     		$('#online_label').addClass('label-danger');
			     		$('#online_label').html('offline');
		     		}
	     		}
	     		
	     		
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

	$('#bottle-holder-controls-container').on("click",".change-wine",function(){
		current_wine_id = $(this).data('wine-id');
		current_bh_id = $(this).data('bottle-holder-id');
		$('.select-wine').css('background', '#FFFFFF');
		$('.select-wine[data-wine-id=' + current_wine_id + ']').css('background', '#EEAAAA');
		$("#change-wine-modal").modal('show');
	});
	var current_bh_shown = null;
	$('#bottle-holders-container').on("click",".bottle",function(){
		var bh_id = $(this).data('id');
		if(current_bh_shown != bh_id){
			current_bh_shown = bh_id;
			$('.bottle').removeClass('active');
			$('.bh-control').hide('fade');
			$('.bh-control[data-bottle-holder-id=' + bh_id+ ']').removeClass('hidden');
			checkbox = $('.bh-control[data-bottle-holder-id=' + bh_id+ ']').find('input[type=checkbox]');
			if( !checkbox.is(':checked') ){
				checkbox.prop('checked', checkbox.data('check'));	
			}
			$('.bh-control[data-bottle-holder-id=' + bh_id+ ']').show('fade');
			$('.bottle[data-id=' + bh_id+ ']').addClass('active');
		}
	});

	$('#bottle-holder-controls-container').on("click",".apply-servings",function(){
		var bh_id = $(this).data('bottle-holder-id');
		$.ajax({
				type: "POST",
				url: '/dispensers/bottle_holders/servings/' + bh_id + '.json',
				accept: 'json',
				dataType: 'json',
				data: $('.servings-form[data-bottle-holder-id=' + bh_id + ']').serialize(),
				success: function(data){
					console.log('changed servings');
					
					render_dispenser();
					
				}
			});
	});
	$('#temperature-controls-container').on("click",".update-temperature",function(){
		var tc_id = $(this).data('temperature-control-id');
		$.ajax({
				type: "POST",
				url: '/dispensers/temperature/' + tc_id + '.json',
				accept: 'json',
				dataType: 'json',
				data: $('.temperature-form[data-temperature-control-id=' + tc_id + ']').serialize(),
				success: function(data){
					console.log('changed temperature');
					
					render_dispenser();
					
				}
			});
	});

	$('#save-wine-change').click(function(){

		if(current_wine_id != 0){
			$("#change-wine-modal").modal('hide');
			$.ajax({
				type: "POST",
				url: '/dispensers/bottle_holders/wine/' + current_bh_id + '.json',
				accept: 'json',
				dataType: 'json',
				data: JSON.stringify({wine_id: current_wine_id}),
				success: function(data){
					console.log('changed wine');
					current_wine_id = 0;
					current_bh_id = 0;
					current_bh_shown = null;
					
					render_dispenser();
					
				}
			});
			current_wine_id = 0;
		}

	});
	$('#leave-empty').click(function(){

		$("#change-wine-modal").modal('hide');
		$.ajax({
			type: "POST",
			url: '/dispensers/bottle_holders/wine/' + current_bh_id + '.json',
			accept: 'json',
			dataType: 'json',
			data: JSON.stringify({wine_id: null}),
			success: function(data){
				console.log('changed wine');
				current_wine_id = 0;
				current_bh_id = 0;
				current_bh_shown = null;
				render_dispenser();
				
			}
		});
		current_wine_id = 0;

	});

	$("#edit-dispenser").click(function(e){
		$(this).parent().addClass('hide');
		$('#form-edit-dispenser').removeClass('hide')
	});

	$('#cancel-edit').click(function(e){
		e.preventDefault();
		$(this).closest('form').addClass('hide');
		$('#dispenser-name').removeClass('hide');
	})

	$(document).ajaxSend(function() {
		//root.addClass("ajax-loader-2");
		$('button').prop('disabled', true);
		$('input').prop('disabled', true);
		$('a').prop('disabled', true);
		$('.loading-header').slideDown();
	});
	$(document).ajaxComplete(function() {
		//root.removeClass("ajax-loader-2");
		$('button').prop('disabled', false);
		$('input').prop('disabled', false);
		$('a').prop('disabled', false);
		$('.loading-header').slideUp();
	});

	$('#detach-dispenser').click(function(event){
		var reconfirm = confirm("¿Seguro desea eliminar el dispenser?");
		if (reconfirm){
			$.ajax({
				type: "POST",
				url: $(this).data("href"),
				accept: 'json',
				dataType: 'json',
				data: JSON.stringify({id: id}),
				success: function(data){
					console.log('DESTROY OK');
					document.location.href="/";
				}, 
				error: function() {
					console.log(arguments);
				}
			});
		}
		
	});

	$("#searchInput").keyup(function () {
    //split the current value of searchInput
    var data = this.value.split(" ").filter(function(v){return v!==''});
    //create a jquery object of the rows
    var jo = $("#wines-container").find(".select-wine");
    if (this.value == "") {
        jo.show();
        return;
    }
    //hide all the rows
    jo.hide();

    //Recusively filter the jquery object to get results.
    jo.filter(function (i, v) {
        var $t = $(this).text();

        for (var d = 0; d < data.length; ++d) {
            if ($t.toLowerCase().indexOf(data[d]) >= 0){
                return true;
            }
        }
        return false;
    })
    //show the rows that match.
    .show();
	}).focus(function () {
    this.value = "";
    $(this).css({
        "color": "black"
    });
    $(this).unbind('focus');
	}).css({
    "color": "#C0C0C0"
	});
});
