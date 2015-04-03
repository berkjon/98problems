$(document).ready(function() {
  bindEvents();
});

function bindEvents(){
  $('form.add-tag-form').submit(addTag);
  $('table').on('submit', 'form.remove-tag-form', removeTagFromTrack);
  $('div.user-tags').on('submit', 'form.remove-tag-form', removeTagFromUser);
  $('div.user-tags').on('click', 'button.user-tag', addSelectedClass);
  $('div.row').on('click', 'div.tag-filter-button', filterTracksBySelectedTags);
  $('div.row').on('click', 'div.tag-export-button', exportTracksToSpotifyPlaylist);
}

function addTag(event){
  event.preventDefault();
  var user_id = event.target.parentElement.parentElement.dataset.userId
  var track_id = event.target.parentElement.parentElement.dataset.trackId
  var newTagString = event.target.querySelector('[name="tag"]').value.toLowerCase()
  if(newTagString[0] === '#'){newTagString = newTagString.substr(1, newTagString.length)}
  var tag_element = event.target.parentElement.parentElement.querySelector('td.tags')
  $(tag_element).append(formatNewTrackTag(newTagString))
  event.target.reset();
  $.ajax({
    type: 'post',
    url: "/users/"+user_id+"/tracks/"+track_id+"/tags/add",
    data: {tag: newTagString},
  }).done(function(response){
    console.log("SUCCESS! Added tag '"+newTagString+"' to user #"+user_id+"'s tags for track #"+track_id+".")
    updateTrackTagHiddenFields(response)
    addTagToUserIfNewTag(response);
  }).fail(function(){
    console.log("FAILED to add tag '"+newTagString+"' to user #"+user_id+"'s tags for track #"+track_id+".")
    alert("Failed to add tag - please try again")
  });
}

function removeTagFromTrack(event){
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
    alert("Failed to remove tag from Track - please try again")
  });
};

function removeTagFromUser(event){
  event.preventDefault();
  var user_id = $(event.target).data('userId')
  var tag_id = $(event.target).data('tagId')
  $(event.target).parent().remove();
  $('table').find("[data-tag-id="+tag_id+"]").parent().remove() // remove all other tags on page

  $.ajax({
    type: 'delete',
    url: "/users/"+user_id+"/tags/"+tag_id+"/delete",
  }).done(function(){
    console.log("SUCCESS! Removed tag #"+tag_id+" from user #"+user_id+"'s tags on ALL tracks.")
  }).fail(function(){
    console.log("FAILED to remove tag #"+tag_id+" from user #"+user_id+"'s tags.")
    alert("Failed to remove tag from User - please try again")
  });

}

function formatNewTrackTag(newTagString){
  return "<button type='button' class='tag track-tag'><form data-tag-id='_TAG_ID_' class='remove-tag-form' action='/users/_USER_ID_/tracks/_TRACK_ID_/tags/_TAG_ID_/remove' method='post'><input name='_method' type='hidden' value='delete'><input type='submit' value='&#10006' class='remove-tag'>"+newTagString+"</form></button>"
};

function formatNewUserTag(response){
  return "<button type='button' class='tag user-tag'><form data-tag-id="+response.tag_id+" data-user-id="+response.user_id+" class='remove-tag-form' action='/users/"+response.user_id+"/tags/"+response.tag_id+"/delete' method='post'><input name='_method' type='hidden' value='delete'><input type='submit' value='&#10006' class='remove-tag'>"+response.tag_string+"</form></button>"
};

function updateTrackTagHiddenFields(response){
  var form = $("[data-track-id="+response.track_id+"]").find("[data-tag-id=_TAG_ID_]");
  form.attr('data-tag-id', response.tag_id);
  form.attr('action', "/users/"+response.user_id+"/tracks/"+response.track_id+"/tags/"+response.tag_id+"/remove");
  console.log("Successfully updated hidden properties of new Track tag");
}

function addTagToUserIfNewTag(response){
  if ($('div.user-tags').find("[data-tag-id="+response.tag_id+"]").parent().length === 0) {
    $('div.user-tags').append(formatNewUserTag(response))
  }
}

function addSelectedClass(event){
  $(event.target).toggleClass('selected')
}



// FILTERING TRACKS \\
function filterTracksBySelectedTags(event){
  event.preventDefault();
  event.stopPropagation();
  var selectedElements = $('div.user-tags').find('.selected').children();
  var userId = selectedElements.attr('data-user-id');
  var tagIds = selectedElements.map(function(){return $(this).attr('data-tag-id');});
  // WHY IS ALL THE BELOW NECESSARY?  CAUSES ERROR OTHERWISE
  var x = [];
  for (var n=0;n<tagIds.length;n++){
    x.push(tagIds[n])
  }
  var tagIdsString = JSON.stringify(x);
  // debugger;
  $.ajax({
    type: 'get',
    url: "/users/"+userId+"/filter",
    data: {tag_ids: tagIdsString},
  }).done(function(response){
    $('tbody').empty();
    $('tbody').prepend(response);
  }).fail(function(){
    alert("Failed to filter and re-output tags")
  });
}

// EXPORTING TO SPOTIFY \\
  // var hitExportAjax = false
function exportTracksToSpotifyPlaylist(event){
  console.log('export tracks function hit')
  event.preventDefault();
  event.stopPropagation();
  var selectedElements = $('div.user-tags').find('.selected').children();
  var userId = selectedElements.attr('data-user-id');
  var tagIds = selectedElements.map(function(){return $(this).attr('data-tag-id');});
  // WHY IS ALL THE BELOW NECESSARY?  CAUSES ERROR OTHERWISE
  var x = [];
  for (var n=0;n<tagIds.length;n++){
    x.push(tagIds[n])
  }
  var tagIdsString = JSON.stringify(x);

  //now do for track ids
  var trackIds = $('tr.track').map(function(){return $(this).attr('data-track-id')})
  var y = [];
  for (var n=0;n<trackIds.length;n++){
    y.push(trackIds[n])
  }
  var trackIdsString = JSON.stringify(y);


    $.ajax({
      type: 'post',
      url: "/users/"+userId+"/export_to_spotify",
      data: {tag_ids: tagIdsString, track_ids: trackIdsString},
    }).done(function(response){
      debugger;
      console.log("SUCCESS!  Created new Spotify Playlist")
      // hitExportAjax = false
    }).fail(function(){
      alert("Failed to filter and re-output tags")
    });
  // }
}