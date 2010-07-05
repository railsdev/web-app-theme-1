$(function() {
  $(".pagination a").live("click", function() {
    $("#carregando").html("<span class='loading'><img id='spinner' src='/images/spinner.gif'>carregando...</span>");
    $.get(this.href, null, null, "script");
    return false;
  });
  $(".ordem a").live("click", function() {
    $("#carregando").html("<span class='loading'><img id='spinner' src='/images/spinner.gif'>carregando...</span>");
    $.get(this.href, null, null, "script");
    return false;
  });
});

