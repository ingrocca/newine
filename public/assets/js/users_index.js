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

	$('.user-link:first').trigger('click');

	$(".format_tag").click(function(){
		var r = confirm('Eliminar la información de la tarjeta?');
		if(r){
			var tag_id = $(this).data('tag-id');
			$.ajax({
				type: "DELETE",
				url: '/tags/'  + tag_id + '.json',
				accept: 'json',
				dataType: 'json',
				success: function(ins){
					$('.tag-panel[data-tag-id='+ tag_id + ']').remove();
				}
			});
		}
	});
	$('.edit_user').click(function(){
		$('.user_info[data-user-id=' + current_id + ']').hide();
		$('.user_edit_form[data-user-id=' + current_id + ']').removeClass('hidden');
		$(this).hide();
	});

	$('.cancel_edit').click(function(){
		$('.user_info[data-user-id=' + current_id + ']').show();
		$('.user_edit_form[data-user-id=' + current_id + ']').addClass('hidden');
		$('.edit_user[data-user-id=' + current_id + ']').show();
	})
	$(".add_credit").click(function(){
		var tag_id = $(this).data('tag-id');
		var tag_uid = $(this).data('tag-uid');
		var credit = $('.credit_to_add[data-tag-id=' + tag_id + ']').val();
		$.ajax({
			type: "POST",
			url: '/tags/add_credit/'  + tag_uid + '.json',
			accept: 'json',
			dataType: 'json',
			data: JSON.stringify({add_credit: credit}),
			success: function(ins){
				if(!(ins.uid === undefined)){
					window.location = '/users/' + ins.user.id
     			}
			}
		});
	});

	$("input[name='user[permissions]']").change(function(e){
		if($(this).val() == 'customer'){
			$(this).closest('form').find('.category-group').show();
		}else{
			$(this).closest('form').find('.category-group').hide();
		}
	})
});