//= require bootstrap
//= require bootstrap-datetimepicker
//= require bootstrap-editable
//= require icon_grid

$(document).ready(function() {

  //
  // Bootstrap basic
  //
  $('[alt]').each(function() {
    if ($(this).attr('title') == undefined) {
      $(this).attr('title', $(this).attr('alt')).attr('rel', 'tooltip');
    }
  })
  $('[title]').attr('rel', 'tooltip');
  $('.dropdown-toggle').dropdown();
  $("[rel=tooltip]").tooltip();

  //
  // bootstrap-datetimepicker
  //
  $('.date-time-picker').datetimepicker(
    {
      format: 'yyyy-MM-dd hh:mm:ss'
    }
  );
  $('.date-picker').datetimepicker(
    {
      format: 'yyyy-MM-dd',
      pickTime: false
    }
  );

});
