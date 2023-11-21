class SchoolClass < ApplicationRecord
  SHIFT_PT_BR = {
    morning: "Manhã",
    afternoon: "Tarde",
    night: "Noite"
  }

  has_many :school_class_students, dependent: :delete_all

  has_many :students, through: :school_class_students

  has_many :quizzes, dependent: :delete_all

  enum shift: {
    morning: 0,
    afternoon: 1,
    night: 2
  }

  scope :by_discipline, ->(discipline_name) { where("discipline_name ILIKE ?", "%#{discipline_name}%") }

  validates :discipline_name, :teacher_name, :students, :shift, :course, presence: true

  accepts_nested_attributes_for :students

  def students_options_list
    self.students.map{ |s| [s.full_name, s.id] }
  end

  def students_option_object_list
    self.students.map{ |s| {id: s.id, full_name: s.full_name, registration_number: s.registration_number} }
  end

  def shift_humanized
    SHIFT_PT_BR[self.shift.to_sym]
  end
end
