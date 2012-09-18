define([
  "jquery",
  "underscore",
  "backbone",
  "router",
  "models/song_version",
  "views/song_version_view"
], function (
  $, _, Backbone, Router, SongVersionModel, SongVersionView) {

  var initialize = function(clawData){
    // Pass in our Router module and call it's initialize function
    //Router.initialize();

    // Create a song version model
    var songVersionModel = new SongVersionModel (clawData.currentSongVersion);

    //Huh 
    window.authenticityToken = clawData.authenticityToken;

    // Render the song version
    new SongVersionView ({
      el : "#main",
      model : songVersionModel
    }).render ();
    
  };

  return {
    initialize: initialize
  };

});