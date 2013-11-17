
var Newine = {
	get_and_render_collection: function(col){
		Newine.get_collection(col,function(data) {
			   $.each(data,function(i,ins){
			   		Newine.render_instance(col,ins);
			   });
		});	
	},

	get_collection: function(col, callback){
		Newine.get_instance(col,'',callback);	
	},

	get_instance: function(col,sub_url, callback, err_callback){
		console.log('Getting ' + col + sub_url);
		$.ajax({
			type: "GET",
			url: '/' + col + sub_url + '.json',
			accept: 'json',
			dataType: 'json',
			success: callback,
			error: err_callback
		});
	},

	render_instance: function(col,ins){
		$("#" + col + "-container").append(Mustache.render($("#" + col + "-template").html(),ins));
	}
};