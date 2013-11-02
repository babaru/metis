//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery.remotipart
//= require jquery.pjax
//= require wice_grid
//= require nebulas
//= require icon_grid
//= require backbone-rails
//= require accounting
//= require jquery.contextMenu
//= require moment.min

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
