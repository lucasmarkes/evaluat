class QuizFeedback < ApplicationRecord
  include AASM
  include JsonLoader

  belongs_to :quiz
  belongs_to :student

  validates :answer_questions, presence: true, on: :update

  aasm column: :status, whiny_transitions: false do
    state :pending, initial: true
    state :concluded

    event :concluded do
      transitions from: :pending, to: :concluded
    end
  end

  def build_answer_questions
    self.answer_questions = self.quiz.questions.map do |question|
      answer_question = load_json_erb_file('questions/answer/example')
      answer_question["question_id"] = question["id"]
      answer_question["question_text"] = question["text"]

      answer_question
    end
  end
end
