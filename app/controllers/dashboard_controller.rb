class DashboardController < AuthenticatedController
  before_action :set_quiz, only: [:index]

  def index
  end

  private

  def set_quiz
    @quiz = current_user.student.pending_quiz_feedbacks.first&.quiz  if current_user.student?
  end
end
