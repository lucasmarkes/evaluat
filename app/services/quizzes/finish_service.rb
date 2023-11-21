require "dry/transaction/operation"

class Quizzes::FinishService
  include Dry::Transaction::Operation

  def initialize(params)
    @params = params
    @answer_questions = []
  end

  def call
    finish_quiz
  end

  private

  attr_accessor :params, :answer_questions

  def quiz
    @quiz ||= Quiz.find(params[:quiz_id])
  end

  def quiz_feedback
    @quiz_feedback ||= QuizFeedback.find(params[:quiz_feedback_id])
  end

  def prepare_answer_questions
    params[:questions].each { |key, value| answer_questions << value }
  end

  def update_answer_questions
    answers = quiz_feedback.answer_questions.map do |answer|
      selected_answer = answer_questions.select { |answer_question| answer_question[:question_id] == answer["question_id"] }.first

      answer["answer"] = selected_answer[:answer]

      answer
    end

    quiz_feedback.answer_questions = answers
    quiz_feedback.save
    quiz_feedback.concluded!
  end

  def update_quiz
    quiz.concluded! if quiz.pending_quiz_feedbacks.count == 0
  end

  def finish_quiz
    prepare_answer_questions
    update_answer_questions
    update_quiz
  end
end
