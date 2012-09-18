define([
  "jquery",
  "underscore",
  "backbone",
  "models/clip",
  "collections/clip_collection"
], function($, _, Backbone, Clip, ClipCollection) {
  var TrackModel = Backbone.Model.extend ({
    
    //Setting the id to match Mongoid ids
    idAttribute : "_id", 

    defaults : {
      name : "New track",
      volume : 0
    },

    initialize : function (data) {
      var clipModels = _.map (data.clips, function (json_clip) {
        return new Clip (json_clip);
      });
      this.clips = new ClipCollection (clipModels);
    },

    addClip : function () {
      //create a new clip model
      var c = new Clip ();
      //set the parent collection so the url is correct
      c.collection = this.clips

      var self = this;
      //persist the clip
      c.save({}, {wait : true, success : function () {
	//add it to the song version clip collection
        self.clips.add (c);
      }});
      
    }
  });
  return TrackModel;
});