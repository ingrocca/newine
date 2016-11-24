$(function(){
	//Newine.get_and_render_collection('wines');

	$('.next_page').html("Siguiente >");
	$('.previous_page').html("< Anterior");

	var current_id = null;
	$('#varieties-container').on("click",".variety-link",function(){
		var u_id = $(this).data('id');
		if(current_id != u_id){
			current_id = u_id;
			$('.variety-data').hide();
			$('.variety-data[data-variety-id=' + u_id+ ']').removeClass('hidden');
			$('.variety-data[data-variety-id=' + u_id + ']').show('fade');
		}
	});

	$('.variety-link:first').trigger('click');

	
	$('.edit_variety').click(function(){
		$("form.form-active").removeClass('form-active');
		$('.variety_info[data-variety-id=' + current_id + ']').hide();
		data = $('.variety_edit_form[data-variety-id=' + current_id + ']').removeClass('hidden').addClass('form-active');
		$(this).hide();
	});

	$('.cancel_edit').click(function(){
		$("form.form-active").removeClass('form-active');
		$('.variety_info[data-variety-id=' + current_id + ']').show();
		$('.variety_edit_form[data-variety-id=' + current_id + ']').addClass('hidden');
		$('.edit_variety[data-variety-id=' + current_id + ']').show();
	})

	$('#new_variety_modal').click(function(){
		$('#new-variety-modal').modal('show');
		$('#new-variety-modal').find('form').addClass('form-active');
	});


});