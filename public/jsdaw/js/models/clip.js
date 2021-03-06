define([
  "jquery",
  "underscore",
  "backbone"
], function($, _, Backbone) {
  var ClipModel = Backbone.Model.extend ({
    
    //Setting the id to match Mongoid ids
    idAttribute : "_id", 

    // FIXME : Ugly, should be set in the collection !
    url : function () {
      var url = "tracks/" + this.get ("track_id") + "/clips";
      if (this.id) url += "/" + this.id;
      return url;      
    },
    
    defaults : {
      source_offset : 0,
      begin_offset  : 0,
      end_offset    : 0,
      selected      : false
    }

  });
  return ClipModel;
});