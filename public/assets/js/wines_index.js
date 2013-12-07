$(function(){
	//Newine.get_and_render_collection('wines');

	$('.next_page').html("Siguiente >");
	$('.previous_page').html("< Anterior");

	var current_id = null;
	$('#wines-container').on("click",".wine-link",function(){
		var u_id = $(this).data('id');
		if(current_id != u_id){
			current_id = u_id;
			$('.wine-data').hide();
			$('.wine-data[data-wine-id=' + u_id+ ']').removeClass('hidden');
			$('.wine-data[data-wine-id=' + u_id + ']').show('fade');
		}
	});

	$('.wine-link:first').trigger('click');

	
	$('.edit_wine').click(function(){
		$('.wine_info[data-wine-id=' + current_id + ']').hide();
		$('.wine_edit_form[data-wine-id=' + current_id + ']').removeClass('hidden');
		$(this).hide();
	});
	$('.cancel_edit').click(function(){
		$('.wine_info[data-wine-id=' + current_id + ']').show();
		$('.wine_edit_form[data-wine-id=' + current_id + ']').addClass('hidden');
		$('.edit_wine[data-wine-id=' + current_id + ']').show();
	})

	$('#new_wine_btn').click(function(){
		$('#new-wine-modal').modal('show');
	});
});