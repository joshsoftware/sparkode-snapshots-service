# frozen_string_literal: true

class SnapshotSerializer < ActiveModel::Serializer
  attributes :id, :image_url, :created_at

  # def candidate_name
  #   candidate = object.token.candidate
  #   [candidate.first_name, candidate.last_name].join(' ')
  # end
end
