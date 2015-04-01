$(document).ready(function() {
  bindEvents();
});

function bindEvents(){
  $('button.add-tag').on('click', addTag);
  // get rid of clicks and just do based on 'enter' instead
  // add functionality for deleting tags
}

function addTag(event){
  event.preventDefault();
  // debugger;
  var user_id = $(this).parent().data('userId')
  var track_id = $(this).parent().data('trackId')
  $.ajax({
    type: 'post',
    url: "/users/"+user_id+"/tracks/"+track_id+"/tags/add",
    data: {tag: $('input').val()},
  }).done(function(){
  debugger;
    appendTag($('input').val());
  });
}

function appendTag(tag, location){
  $('td.tags').append(tag);
}