$(function(){

	var current_id = null;
	$('#brand_container').on("click",".brand-link",function(){
		var u_id = $(this).data('id');
		if(current_id != u_id){
			current_id = u_id;
			$('.brand-data').hide('fade');
			$('.brand-data[data-brand-id=' + u_id+ ']').removeClass('hidden');
			$('.brand-data[data-brand-id=' + u_id + ']').show('fade');
		}
	});

	$('.brand-link:first').trigger('click');

	$('.edit_brand').click(function(){
		$('.brand_info[data-brand-id=' + current_id + ']').hide();
		$('.brand_edit_form[data-brand-id=' + current_id + ']').removeClass('hidden');
		$(this).hide();
	});

	$('.cancel_edit').click(function(){
		$('.brand_info[data-brand-id=' + current_id + ']').show();
		$('.brand_edit_form[data-brand-id=' + current_id + ']').addClass('hidden');
		$('.edit_category[data-brand-id=' + current_id + ']').show();
	})
})