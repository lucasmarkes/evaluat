require "dry/transaction/operation"

class Quizzes::MetricCalculatorService
  include Dry::Transaction::Operation

  def initialize(quiz)
    @quiz = quiz
    @results = []
  end

  def call
    calculate_metrics
  end

  private

  attr_accessor :quiz, :results

  def build_metric_result(questions_id, question_text)
    {
      question_id: questions_id,
      question_text: question_text,
      value: 0
    }
  end

  def quiz_feedbacks
    @quiz_feedbacks ||= quiz.quiz_feedbacks
  end

  def prepare_metric_results
    quiz.questions.each do |question|
      @results << build_metric_result(question["id"], question["text"])
    end
  end

  def calculate_media
    feedbacks_quantity = quiz_feedbacks.count

    results.each do |result|
      result[:value] = result[:value].to_f / feedbacks_quantity
    end

    results
  end

  def process_quiz_feedbacks
    quiz_feedbacks.each do |feedback|
      feedback.answer_questions.each do |answer|
        index = results.find_index { |metric_obj| metric_obj[:question_id] == answer["question_id"] }
        results[index][:value] = results[index][:value].to_i + answer["answer"].to_i
      end
    end

    calculate_media
  end

  def save_metrics
    quiz.result_metrics = results

    quiz.save!
  end

  def calculate_metrics
    prepare_metric_results
    process_quiz_feedbacks
    save_metrics
  end
end
