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
			   		el.hide();
			   		$("#events-container").prepend(el);
			   		if(i < data.length){
			   			console.log('again');
			   			el.show(add_elem);//"drop",{direction: "down"},1000,add_elem);
			   		}
			   		else {
			   			el.show();
			   		}
 
			   };
			   if (data.length>0)
					add_elem();
		});	
	$('#toggle-dispenser-modal').click(function(){
		$('#new-dispenser-modal').modal('show');
	});

	var host = window.location.hostname;
	

	var sock = new WebSocket( "ws://" + host + ":8080");
   
   	var current_uid = null;
   	sock.onopen = function(){
	   sock.onmessage = function(evt){
	     	
	     	console.log(evt.data);
	     	data = JSON.parse(evt.data)
	     	if(!(data.tag === undefined)){
	     		$('#nfc-tag-modal').modal('show');
	     		if(data.tag.uid != current_uid){
		     		current_uid = data.tag.uid;
		 			$('#tags-container').html('');
		     		Newine.get_instance('tags','/uid/' + data.tag.uid, function(ins){
		     			if(!(ins.uid === undefined)){
		     				Newine.render_instance('tags',ins);
		     			}

			     	}, function(xhr,opts,errorThrown){
			     		$('#tags-container').html('<div class="alert error">Tag nuevo</div>');
			     		return true;
			     	});
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

});