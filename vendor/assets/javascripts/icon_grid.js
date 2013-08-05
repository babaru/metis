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
    cell.append($(this).addClass('item').css('background', "url('" + $(this).attr('logo-url') + "') no-repeat center center"));
    var editable = $(this).attr('data-editable');
    if(editable == "true") {
      cell.append('<div class="edit-panel"><a href="' + $(this).attr('href') + '/edit"><span class="edit icon-stack"><i class="icon-sign-blank icon-stack-base"></i><i class="icon-pencil icon-light" /></span></a><a href="' + $(this).attr('href') + '" data-method="delete" data-confirm="确定要删除这个条目？"><span class="delete icon-stack"><i class="icon-sign-blank icon-stack-base"></i><i class="icon-trash icon-light" /></span></a></div>');
    }
    $('.edit-panel', cell).hide();
    row.append(cell);
  });

  $('.icon-grid a').hover(function() {
    $('.edit-panel', $(this).parent()).show();
  }, function() {
    $('.edit-panel', $(this).parent()).hide();
  });

  $('.edit-panel').hover(function() {
    $(this).show();
  }, function() {
    $(this).hide();
  });
});
