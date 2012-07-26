class Action
  include Command
  include Node

  # including Mongoid after Node. Fields seems to override attributes declared
  # in Node
  include Mongoid::Document 

  # field :parents, :type => Array, :default => []
  # field :children, :type => Array, :default => []
  # NOTE : tought about using recursively_embeds_many but it didn't fit so well
  
  has_and_belongs_to_many :parents,  :class_name => "Action", :inverse_of => :children
  has_and_belongs_to_many :children, :class_name => "Action", :inverse_of => :parents

  # Node methods use instance variable. We need to set them before we can do 
  # anything
  after_initialize do
    @parents  = self.parents
    @children = self.children
  end

  # When undo is called, we want to call undo on the children too. Would be cool
  # to be able to write something like this ... 
  # after_undo do {children.each &:undo} end

  # This method will be used to find an action in the tree. We return id by
  # by default but some action might override it to return a more meaningful
  # name
  def name
    id.to_s
  end

  # Add all children from the given action to self.children
  def merge action
    # raise an error if actions are not of same type
    unless self.class.to_s == action.class.to_s
      raise ArgumentError, "#{action.class} and #{self.class} are not equal" 
    end

    action.children.each do |child|
      # checking if the action already has such a child
      c = self.children.detect { |c| c.same_as? child }
      
      # if not, create one with no parents and no children
      unless c
        c = child.class.new(child.as_document.except "_id", "child_ids", "parent_ids")
        self.children << c
      end
      
      # then merge kids
      c.merge child 
    end
  end

  def same_as? action
    return self.class.to_s == action.class.to_s
  end

end
