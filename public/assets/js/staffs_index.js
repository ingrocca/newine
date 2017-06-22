$(function(){

  var current_id = null;
  $('body').on("click",".staff-link",function(){
    var u_id = $(this).data('id');
    if(current_id != u_id){
      current_id = u_id;
      $('.staff-data').hide('fade');
      $('.staff-data[data-staff-id=' + u_id+ ']').removeClass('hidden');
      $('.staff-data[data-staff-id=' + u_id + ']').show('fade');
    }
  });

  $('.staff-link:first').trigger('click');

  $('.edit_staff').click(function(){
    $('.staff_info[data-staff-id=' + current_id + ']').hide();
    $('.staff_edit_form[data-staff-id=' + current_id + ']').removeClass('hidden');
    $(this).hide();
  });

  $('.cancel_edit').click(function(){
    $('.staff_info[data-staff-id=' + current_id + ']').show();
    $('.staff_edit_form[data-staff-id=' + current_id + ']').addClass('hidden');
    $('.edit_staff[data-staff-id=' + current_id + ']').show();
  })
});
