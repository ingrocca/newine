$(function(){
	$(".delete").click(function(event){
		event.preventDefault();
		if(confirm("Está seguro que desea borrar?")){
			$("<form action="+$(this).data('delete')+" method='POST'></form>").submit();
		}
	})
})