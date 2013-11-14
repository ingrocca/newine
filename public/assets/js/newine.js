
var Newine = {
	get_collection: function(col){
		console.log('Getting ' + col);
		$.ajax({
			type: "GET",
			url: '/' + col + '.json',
			accept: 'json',
			dataType: 'json',
			success: function(data) {
			   $.each(data,function(i,ins){
			   		$("#" + col + "-container").append(Mustache.render($("#" + col + "-template").html(),ins));
			   });
			}
		});
	}
};