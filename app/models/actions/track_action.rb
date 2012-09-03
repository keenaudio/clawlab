class TrackAction < Action
  field :song_version_id, :type => Moped::BSON::ObjectId
  belongs_to :track

  def same_as? action
    super(action) && self.track == action.track
  end
end
