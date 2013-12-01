$(function(){
	//Newine.get_and_render_collection('users');

	$('.next_page').html("Siguiente >");
	$('.previous_page').html("< Anterior");

	var current_id = null;
	$('#users-container').on("click",".user-link",function(){
		var u_id = $(this).data('id');
		if(current_id != u_id){
			current_id = u_id;
			$('.user-data').hide('fade');
			$('.user-data[data-user-id=' + u_id+ ']').removeClass('hidden');
			$('.user-data[data-user-id=' + u_id + ']').show('fade');
		}
	});
});