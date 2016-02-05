$(function(){

	var current_id = null;
	$('#special_event_container').on("click",".special-event-link",function(){
		var u_id = $(this).data('id');
		if(current_id != u_id){
			current_id = u_id;
			$('.special-event-data').hide('fade');
			$('.special-event-data[data-special-event-id=' + u_id+ ']').removeClass('hidden');
			$('.special-event-data[data-special-event-id=' + u_id + ']').show('fade');
		}
	});

	$('.special-event-link:first').trigger('click');

	$('.edit_special_event').click(function(){
		$('.special_event_info[data-special-event-id=' + current_id + ']').hide();
		$('.special_event_edit_form[data-special-event-id=' + current_id + ']').removeClass('hidden');
		$(this).hide();
	});

	$('.cancel_edit').click(function(){
		$('.special_event_info[data-special-event-id=' + current_id + ']').show();
		$('.special_event_edit_form[data-special-event-id=' + current_id + ']').addClass('hidden');
		$('.edit_special_event[data-special-event-id=' + current_id + ']').show();
	})
})