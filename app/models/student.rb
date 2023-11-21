class Student < ApplicationRecord
  has_one :user, dependent: :destroy

  has_many :school_class_students, dependent: :delete_all

  has_many :school_classes, through: :school_class_students

  has_many :quiz_feedbacks, dependent: :delete_all

  validates :registration_number, :document_number, presence: true

  accepts_nested_attributes_for :user

  delegate :full_name, :email, to: :user, allow_nil: true

  before_validation :set_user_password, on: [ :create ]

  accepts_nested_attributes_for :school_classes

  scope :search_by_full_name, ->(name) {
    where("first_name LIKE :name OR last_name LIKE :name", name: "%#{name}%") if name.present?
  }

  scope :search_by_registration_number, ->(registration_number) { where("registration_number ILIKE ?", "%#{registration_number}%") }

  def pending_quiz_feedbacks
    quiz_feedbacks.where(status: 'pending')
  end

  private

  def set_user_password
    self.user.password = self.document_number
  end
end
