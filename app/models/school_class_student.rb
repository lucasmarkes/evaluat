class SchoolClassStudent < ApplicationRecord
  belongs_to :student
  belongs_to :school_class
end
