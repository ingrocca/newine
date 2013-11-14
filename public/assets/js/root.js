$(function(){
	Newine.get_collection('dispensers');

	$('#toggle-dispenser-modal').click(function(){
		$('#new-dispenser-modal').modal('show');
	});

});