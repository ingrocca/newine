$(function(){
  $("#user-search").select2({
    minimumInputLength: 2,
    allowClear: true,
    placeholder: 'Nombre o Apellido',
    ajax: {
      url: "/users/search",
      dataType: 'json',
      delay: 250,
      data: function (params) {
        return {
          q: params.term // search term
        };
      },
      processResults: function (data) {
        return {
          results: $.map(data, function (item) {
              return {
                  text: item.name +" "+ item.surname,
                  id: item.id
              }
          })
        };
      }
    }
  });
})
