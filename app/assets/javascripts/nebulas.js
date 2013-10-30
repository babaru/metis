//= require bootstrap
//= require bootstrap-datetimepicker
//= require bootstrap-editable

$(document).ready(function() {
  $("a[rel=popover]").popover();
  $(".tooltip").tooltip();
  $("a[rel=tooltip]").tooltip();

  // $('.dropdown-toggle').dropdown();

  // $('.navbar .dropdown-toggle.top').on('mouseover', function() {
  //   $(this).dropdown('toggle');
  // })

  $('.date-time-picker').datetimepicker({
    format: 'yyyy-MM-dd hh:mm:ss'
  });

  $('.date-picker').datetimepicker({
    format: 'yyyy-MM-dd',
    pickTime: false
  });

  $(".collapse").collapse({
    toggle: false
  });

  $('.accordion-toggle').click(function() {
    if (!$(this).hasClass('open')) {
      $(this).addClass('open');
      $('.icon-angle-left', this).removeClass('icon-angle-left').addClass('icon-angle-down');
    } else {
      $(this).removeClass('open');
      $('.icon-angle-down', this).removeClass('icon-angle-down').addClass('icon-angle-left');
    }
  })
});
