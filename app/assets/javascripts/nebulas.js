//= require bootstrap
//= require bootstrap-datetimepicker
//= require bootstrap-editable

$(document).ready(function() {

  //
  // Bootstrap basic
  //
  $('.dropdown-toggle').dropdown();
  $("a[rel=tooltip]").tooltip();

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
