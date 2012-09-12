/**
 * RootAction tree view. It renders the root_action of a song_version.
 */
define([
  "jquery",
  "underscore",
  "backbone",
  "text!templates/root_action.html",
  "text!templates/action.html",
  "text!templates/action_children.html",
], function($, _, Backbone, rootActionTemplate, actionTemplate, actionChildrenTemplate) {
  return Backbone.View.extend ({
    
    // The main template for the root action
    template : _.template (rootActionTemplate),

    // A common template for actions
    actionTemplate : _.template (actionTemplate),

    // A template for actions children
    childrenTemplate : _.template (actionChildrenTemplate),

    events : {
      "click #root-action-refresh" : "refreshClicked"
    },

    initialize : function () {
      _.bindAll (this, "render");
      this.model.on ("change", this.render);
    },

    render : function () {
      console.log (this.model);
      // Computing root action view
      var root_action = this.template (this.model);

      // Computing tree view
      var tree = this.renderAction (this.model, this.childrenTemplate ());

      // Concatenate the two views in el
      $(this.el).html ($(root_action).add (tree));

      return this;
    },
    
    /**
     * This fonction renders an action. It is recursively called on each 
     * children.
     */
    renderAction : function (action, el) {
      var new_el = $(el).html (this.actionTemplate ({
        pretty_name : action.pretty_name,
        created_at  : action.created_at
      }));
      if (action.children.length > 0) {
        var self = this;
        _.each (action.children, function (child) {
          $(new_el).append (
            self.renderAction(child, self.childrenTemplate (child))
          );
        });
      }
      return new_el;
    },

    refreshClicked : function () {
      var self = this;
      this.model.fetch ({success : function () {
        console.log (self);
      }});
    }

  });
});