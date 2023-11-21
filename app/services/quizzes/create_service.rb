require "dry/transaction/operation"

class Quizzes::CreateService
  include Dry::Transaction::Operation

  def initialize(params)
    @params = params
  end

  def call
    create_quiz
  end

  private

  attr_accessor :params

  def school_class
    @school_class ||= SchoolClass.find(params[:school_class_id])
  end

  def create_quiz_feedback(quiz)
    school_class.students.each do |student|
      quiz_feedback = student.quiz_feedbacks.build(quiz_id: quiz.id)
      quiz_feedback.build_answer_questions

      quiz_feedback.save
    end
  end

  def create_quiz
    quiz = Quiz.new(params)
    quiz.build_questions

    quiz.save

    create_quiz_feedback(quiz) if quiz.errors.empty?

    quiz
  end
end
