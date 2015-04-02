$(document).ready(function() {
  bindEvents();
});

function bindEvents(){
  // $('button.add-tag').on('click', addTag);
  $('form.add-tag-form').submit(addTag);
  $('form.remove-tag-form').submit(removeTag);
  // get rid of clicks and just do based on 'enter' instead
  // add functionality for deleting tags
}

function addTag(event){
  event.preventDefault();
  var user_id = event.target.parentElement.parentElement.dataset.userId
  var track_id = event.target.parentElement.parentElement.dataset.trackId
  // var user_id = $(this).parent().data('userId') // BETTER TO USE 'THIS' OR 'EVENT' TO PULL DATA?
  // var track_id = $(this).parent().data('trackId')
  var newTagString = event.target.querySelector('[name="tag"]').value
  var tag_element = event.target.parentElement.parentElement.querySelector('td.tags')

  $(tag_element).append(formatNewTag(newTagString))
  event.target.reset();
  $.ajax({
    type: 'post',
    url: "/users/"+user_id+"/tracks/"+track_id+"/tags/add",
    data: {tag: newTagString},
  }).done(function(response){
    console.log("SUCCESS! Added tag '"+newTagString+"' to user #"+user_id+"'s tags for track #"+track_id+".")
    updateDataTagId(response)
  }).fail(function(){
    console.log("FAILED to add tag '"+newTagString+"' to user #"+user_id+"'s tags for track #"+track_id+".")
    alert("Failed to add tag - please try again")
  });
}

function removeTag(event){
  event.preventDefault();
  var user_id = $(event.target).parents().eq(2).data('userId')
  var track_id = $(event.target).parents().eq(2).data('trackId')
  var tag_id = $(event.target).data('tagId')
  $(event.target).parent().remove();
  $.ajax({
    type: 'delete',
    url: "/users/"+user_id+"/tracks/"+track_id+"/tags/"+tag_id+"/remove",
  }).done(function(){
    console.log("SUCCESS! Removed tag #"+tag_id+" from user #"+user_id+"'s tags for track #"+track_id+".")
  }).fail(function(){
    console.log("FAILED to remove tag #"+tag_id+" from user #"+user_id+"'s tags for track #"+track_id+".")
    alert("Failed to remove tag - please try again")
  });
};

function formatNewTag(newTagString){
  return "<button type='button' class='tag'><form data-tag-id='_TAG_ID_' class='remove-tag-form' action='/users/_USER_ID_/tracks/_TRACK_ID_/tags/_TAG_ID_/remove' method='post'><input name='_method' type='hidden' value='delete'><input type='submit' value='&#10006' class='remove-tag'>"+newTagString+"</form></button>"
};

function updateDataTagId(response){
  var form = $("[data-track-id="+response.track_id+"]").find("[data-tag-id=_TAG_ID_]")
  form.data('tagId', response.tag_id)
  form.attr('action', "/users/"+response.user_id+"/tracks/"+response.track_id+"/tags/"+response.tag_id+"/remove")
  console.log("Successfully updated hidden properties of new tag")
}