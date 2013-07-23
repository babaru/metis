$(document).ready(function() {
  var grid = $('.icon-grid');
  if(!grid.hasClass('grid')) {
    grid.addClass('grid');
  }
  var row = null;
  $('.icon-grid a').each(function(index) {
    if (index % 6 == 0) {
      row = $('<div />').addClass('grid-row');
      grid.append(row);
    }

    var cell = $('<div />').addClass('cell2');
    cell.append($(this).css('background', "url('" + $(this).attr('logo-url') + "') no-repeat center center"));
    row.append(cell);
  });
});
