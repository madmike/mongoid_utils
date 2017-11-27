module Concerns::Votable
  extend ActiveSupport::Concern

  included do
    field :votes_up, type: Integer, default: 0
    field :votes_down, type: Integer, default: 0
    field :votes_value, type: Integer, default: 0

    embeds_many :votes, class_name: 'Concerns::Votable::Vote'

    scope :voted_by, ->(voter) { where('votes.user_id' => voter.id) }
    scope :votable, -> { order_by(votes_value: :desc) }

    index votes_value: 1
    index 'votes.user_id' => 1
  end

  def voted?(voter)
    votes.where(voter: voter).first != nil
  end

  def vote_up(voter)
    vote!(1, voter)
  end

  def vote_down(voter)
    vote!(-1, voter)
  end

  def vote!(value, voter)
    vote = self.votes.find_or_create_by(user: voter)

    if vote.value == value
      vote.destroy
      value = 0
    end

    update_values(value, vote)
    vote.update_attribute(:value, value) if value != 0

    vote
  end

  def votes_count
    self.votes.count
  end

#   def votes_value
#     self.votes_up - self.votes_down
#   end

  module ClassMethods
  end

private
  def update_values(value, vote)
    votes_up_change = (vote.value > 0 ? -vote.value : 0) + (value > 0 ? value : 0)
    votes_down_change = (vote.value < 0 ? vote.value : 0) + (value < 0 ? value.abs : 0)

    self.timeless.inc(votes_up: votes_up_change)
    self.timeless.inc(votes_down: votes_down_change)
    self.timeless.inc(votes_value: votes_up_change - votes_down_change)
  end

  class Vote
    include Mongoid::Document

    field :value, type: Integer, default: 0

    belongs_to  :user
    embedded_in :votable
  end
end