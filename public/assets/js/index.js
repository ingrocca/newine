function toFixedLength(num, length) {
    var r = "" + num;
    while (r.length < length) {
        r = "0" + r;
    }
    return r;
}

$(function(){
	Newine.get_and_render_collection('dispensers');
	Newine.get_collection('events',function(data) {
				var i = 0;
			   	var add_elem = function() {
			   		ins = data[i];
			   		i += 1;
			   		var d = new Date(ins.created_at);
			   		ins.timestamp = "" + d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear() + " - " + toFixedLength(d.getHours(),2) + ":" + toFixedLength(d.getMinutes(),2) + ":" + toFixedLength(d.getSeconds(),2); 
			   		
			   		var cs = ins.color.toString(16);
			   		while(cs.length < 6)
			   			cs = '0' + cs;
			   		ins.style = "'background-color: #" + cs + ";'";
			   		var el = $(Mustache.render($("#events-template").html(),ins));
			   		//el.hide();
			   		$("#events-container").append(el);
			   		if(i < data.length){
			   		//	console.log('again');
			   			//el.show(add_elem);//"drop",{direction: "down"},1000,add_elem);
						add_elem();
			   		}
			   		else {
			   			//el.show();
			   		}
 
			   };
			   if (data.length>0)
					add_elem();
		});	
	$('#toggle-dispenser-modal').click(function(){
		$('#new-dispenser-modal').modal('show');
	});

	var host = window.location.hostname;
	
console.log(host);
	var sock = new WebSocket( "ws://" + host + ":8080");
   
   	var current_uid = null;
   	var current_tag = null;
   	var tag_is_known = false;
   	sock.onopen = function(){
	console.log("socket open");	   
sock.onmessage = function(evt){
	     	
	     	console.log(evt.data);
	     	data = JSON.parse(evt.data)
	     	if(!(data.tag === undefined)){
	     		$('#existing-card-group').hide();
	     		$('.new-card-group').hide();
	     		$('#tag_form_buttons').hide();
	     		$('#nfc-tag-modal').modal('show');
	     		if(data.tag.uid != current_uid){
	     			
		     		current_uid = data.tag.uid;
		     		$('#tag_uid_hidden').val(current_uid);
		 			$('#tags-container').html('');
		     		Newine.get_instance('tags','/uid/' + data.tag.uid, function(ins){
		     			if(!(ins.uid === undefined)){
		     				tag_is_known = true;
		     				current_tag = ins;
		     				Newine.render_instance('tags',ins);
		     				$('#existing-card-group').show();
		     			}


			     	}, function(xhr,opts,errorThrown){
			     		tag_is_known = false;
			     		$('#tags-container').html('<div class="alert alert-warning">Tag nuevo</div>');
			     		$('.new-card-group').show();
			     		$('#existing_user_fields').show();
			     		$('#new_user_fields').hide();
			     		$("#new_user_fields :input").attr("disabled", true);
			     		$('#tag_form_buttons').show();
			     		return true;
			     	});
		     	}else{
		     		if(!tag_is_known)
		     		{
		     			$('.new-card-group').show();
		     			$('#tag_form_buttons').show();
		     			$('#existing_user_fields').show();
			     		$('#new_user_fields').hide();
			     		$("#new_user_fields :input").attr("disabled", true);
		     		}else{
		     			$('#existing-card-group').show();
		     		}
		     	}


	     	}
	     	if(!(data.evnt === undefined)){
	     		var ins = data.evnt
	     		var d = new Date(ins.created_at);
			   	ins.timestamp = "" + d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear() + " - " + toFixedLength(d.getHours(),2) + ":" + toFixedLength(d.getMinutes(),2) + ":" + toFixedLength(d.getSeconds(),2); 
			   	ins.style = "'background-color: #" + ins.color.toString(16) + ";'";
	     		var el = $(Mustache.render($("#events-template").html(),ins));
	     		el.hide();
	     		$("#events-container").prepend(el);
	     		el.show("drop",{direction: "up"},500);
	     	}
	     
	    }
	}

	$("#add_credit").click(function(){
		var credit = $('#credit_to_add').val();
		$.ajax({
			type: "POST",
			url: '/tags/add_credit/'  + current_uid + '.json',
			accept: 'json',
			dataType: 'json',
			data: JSON.stringify({add_credit: credit}),
			success: function(ins){
				if(!(ins.uid === undefined)){
					$("#tag-alerts-container").html($("#add-credit-success-template").html());
					$('#tags-container').html('');
     				Newine.render_instance('tags',ins);
     				$('#existing-card-group').show();
     			}
			}
		});
	});

	$("#format_tag").click(function(){
		var r = confirm('Eliminar la información de la tarjeta?');
		if(r){
			$.ajax({
				type: "DELETE",
				url: '/tags/'  + current_tag.id + '.json',
				accept: 'json',
				dataType: 'json',
				success: function(ins){
					tag_is_known = false;
					$('#existing-card-group').hide();
		     		$('.new-card-group').hide();
		     		$('#tag_form_buttons').hide();
		     		$('#nfc-tag-modal').modal('show');
	  
	  				$('#tags-container').html('<div class="alert error">Tag nuevo</div>');
		     		$('.new-card-group').show();
		     		$('#tag_form_buttons').show();
		     		$('#existing_user').trigger('click');

				}
			});
		}
	});

	$("#search_users").click(function(){
		var q = $('#user_search').val();
		$.ajax({
			type: "GET",
			url: '/users.json?q='  + q,
			accept: 'json',
			dataType: 'json',
			success: function(data){
				console.log('got users');
				console.log(data);
				$('#tag_user_id').html('');
				$.each(data,function(i,usr){

					$('#tag_user_id').append('<option value=' + usr.id + '>' + usr.name + '</option>')
				});
			}
		});
	});

	$('#existing_user').click(function(){
		$('#new_user_hidden').val(false);
		$('#new_user_fields').hide();
		$("#new_user_fields :input").attr("disabled", true);
		$('#existing_user_fields').show();
		$(this).addClass('active');
		$('#create_new_user').removeClass('active');
	});

	$('#create_new_user').click(function(){
		$('#new_user_hidden').val(true);
		$('#new_user_fields').show();
		$("#new_user_fields :input").attr("disabled", false);
		$('#existing_user_fields').hide();
		$(this).addClass('active');
		$('#existing_user').removeClass('active');
	});

});
