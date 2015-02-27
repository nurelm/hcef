class Enrichment < ActiveRecord::Base
  # Relationships
  belongs_to :provider
  belongs_to :program

  # Validations
  validates_numericality_of :length, presence: true
end
