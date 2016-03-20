$(function(){

	var current_id = null;
	$('#category_container').on("click",".category-link",function(){
		var u_id = $(this).data('id');
		if(current_id != u_id){
			current_id = u_id;
			$('.category-data').hide('fade');
			$('.category-data[data-category-id=' + u_id+ ']').removeClass('hidden');
			$('.category-data[data-category-id=' + u_id + ']').show('fade');
		}
	});

	$('.category-link:first').trigger('click');

	$('.edit_category').click(function(){
		$('.category_info[data-category-id=' + current_id + ']').hide();
		$('.category_edit_form[data-category-id=' + current_id + ']').removeClass('hidden');
		$(this).hide();
	});

	$('.cancel_edit').click(function(){
		$('.category_info[data-category-id=' + current_id + ']').show();
		$('.category_edit_form[data-category-id=' + current_id + ']').addClass('hidden');
		$('.edit_category[data-category-id=' + current_id + ']').show();
	})

	$('.category-low').on('change',function(e){
		form = $(this).closest('form')
		form.find(".category-med").val($(this).val())
		form.find(".category-high").val($(this).val())
	})
})