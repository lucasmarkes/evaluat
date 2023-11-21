class AddColumnResultMetricsToQuiz < ActiveRecord::Migration[7.1]
  def change
    add_column :quizzes, :result_metrics, :json, default: []
  end
end
