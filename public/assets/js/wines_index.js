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
		$("form.form-active").removeClass('form-active');
		$('.wine_info[data-wine-id=' + current_id + ']').hide();
		data = $('.wine_edit_form[data-wine-id=' + current_id + ']').removeClass('hidden').addClass('form-active');
		$('.wine_edit_form[data-wine-id=' + current_id + ']').find(".select2").select2({
  		placeholder: 'Seleccione una opción',
  		language: "es",
  		theme: "bootstrap"
		});
		$(this).hide();
	});
	$('.cancel_edit').click(function(){
		$("form.form-active").removeClass('form-active');
		$('.wine_info[data-wine-id=' + current_id + ']').show();
		$('.wine_edit_form[data-wine-id=' + current_id + ']').addClass('hidden');
		$('.edit_wine[data-wine-id=' + current_id + ']').show();
	})

	$('#new_wine_btn').click(function(){
		$('#new-wine-modal').modal('show');
		$('#new-wine-modal').find('form').addClass('form-active');
	});

	$(".add-variety").click(function(e){
		e.preventDefault();
		$("#new_variety_modal").modal();
	})

	$("#form_variety").submit(function(event){
		event.preventDefault();
		$.post($(this).attr('action'), $(this).serialize(), function(data){
			data = $.parseJSON(data);
			option = "<option value='"+data.id+"' selected>"+data.name+"</option>"
			$(".select_variety").each(function(index, element){ $(element).append(option) })
		})
		$(this)[0].reset()
		$(this).closest(".modal").modal('hide');
		
	})

	$('#new-wine-modal').on('shown.bs.modal', function () {
		$(this).find(".select2").select2({
  		placeholder: 'Seleccione una opción',
  		language: "es",
  		theme: "bootstrap"
		});
	})

});