$(document).ready(function() {
  bindEvents();
});

function bindEvents(){
  // $('button.add-tag').on('click', addTag);
  $('form').submit(addTag);
  // get rid of clicks and just do based on 'enter' instead
  // add functionality for deleting tags
}

function addTag(event){
  event.preventDefault();
  var user_id = event.target.dataset.userId
  var track_id = event.target.dataset.trackId
  // var user_id = $(this).parent().data('userId') // BETTER TO USE 'THIS' OR 'EVENT' TO PULL DATA?
  // var track_id = $(this).parent().data('trackId')
  var input_value = event.target.querySelector('[name="tag"]').value
  var tag_element = event.target.parentElement.parentElement.getElementsByClassName('tags')
  appendTag(input_value, tag_element);
  event.target.reset();
  $.ajax({
    type: 'post',
    url: "/users/"+user_id+"/tracks/"+track_id+"/tags/add",
    data: {tag: input_value},
  }).done(function(){
    console.log("SUCCESS! Added tag '"+input_value+"' to user #"+user_id+"'s tags for track #"+track_id+".")
  }).fail(function(){
    console.log("FAILED to add tag '"+input_value+"' to user #"+user_id+"'s tags for track #"+track_id+".")
    alert("Something went wrong - please try again")
  });
}

function appendTag(tag, location){
  $(location).append(tag);
}
