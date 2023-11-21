class Quiz < ApplicationRecord
  STATUS_PT_BR = {
    in_progress: "Em andamento",
    concluded: "Concluido"
  }

  include AASM
  include JsonLoader

  belongs_to :school_class
  has_many :quiz_feedbacks, dependent: :delete_all

  validates :name, :questions, :school_class_id, presence: true

  aasm column: :status, whiny_transitions: false do
    state :in_progress, initial: true
    state :concluded

    event :concluded do
      transitions from: :in_progress, to: :concluded

      before do
        Quizzes::MetricCalculatorService.new(self).call
      end
    end
  end

  def build_questions
    questions = load_json_erb_file('questions/example')
    self.questions = questions
  end

  def pending_quiz_feedbacks
    quiz_feedbacks.where(status: 'pending')
  end

  def status_humanized
    STATUS_PT_BR[self.status.to_sym]
  end
end
