function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

checked=false;
function checkedAll () {
  var formulario = document.getElementById('formlote');
	if (checked == false)
  {
    checked = true
  }
  else
  {
    checked = false
  }
	for (var i =0; i < formulario.elements.length; i++)
	{
    formulario.elements[i].checked = checked;
	}
}

