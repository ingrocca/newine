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
			   		ins.style = "'background-color: #" + ins.color.toString(16) + ";'";
			   		var el = $(Mustache.render($("#events-template").html(),ins));
			   		el.hide();
			   		$("#events-container").prepend(el);
			   		if(i < data.length){
			   			console.log('again');
			   			el.show(add_elem);//"drop",{direction: "down"},1000,add_elem);
			   		}
			   		else {
			   			el.delay(500).show("drop",{direction: "up"},1000);
			   		}
 
			   };
			   add_elem();
		});	
	$('#toggle-dispenser-modal').click(function(){
		$('#new-dispenser-modal').modal('show');
	});

});