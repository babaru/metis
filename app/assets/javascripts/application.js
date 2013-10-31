//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery.remotipart
//= require jquery.pjax
//= require wice_grid

//= require icon_grid
//= require bootstrap-contextmenu
//= require backbone-rails
//= require context
//= require accounting

$(function() {
  $('[data-pjax-container]').pjax('a:not([data-remote]):not([data-behavior]):not([data-skip-pjax])');

  $('[data-pjax-container]').on('pjax:start', function() {
    $('#pjax-loading-dialog').modal({
      backdrop: 'static',
      keyboard: false
    });
  }).on('pjax:end', function() {
    $('#pjax-loading-dialog').modal('hide');
  });
});
