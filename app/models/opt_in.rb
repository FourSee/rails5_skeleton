# frozen_string_literal: true

# == Schema Information
#
# Table name: opt_ins
#
#  id           :bigint(8)        not null, primary key
#  alert_name   :string           not null, indexed => [recipient_id, entity_id, scope, channel_name]
#  channel_name :string           not null, indexed => [recipient_id, entity_id, scope, alert_name]
#  scope        :string           not null, indexed => [recipient_id, entity_id, alert_name, channel_name]
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  entity_id    :integer          not null, indexed => [recipient_id, scope, alert_name, channel_name]
#  recipient_id :integer          not null, indexed => [entity_id, scope, alert_name, channel_name]
#
# Indexes
#
#  unique_composite_key  (recipient_id,entity_id,scope,alert_name,channel_name) UNIQUE
#

class OptIn < ApplicationRecord
  # scope: is the type of domain object that opt-in applies to. For example
  # it could be post or comment
  # entity_id: is the ID of the scope (post id or comment id)
  # channel_name: is the name of the channel opted into. email or slack are examples
  # alert_name: is the name of the alert: new_user or comment_posted
  # user_id: is the name of the user who's opted into this

  self.table_name = :opt_ins

  validates :scope, :entity_id, :channel_name, :alert_name, :recipient_id, presence: true
end
