class QuizzesController < AuthenticatedController
  before_action :admin_only, except: [:answer_quiz, :finish_quiz]
  before_action :student_only, except: [:index, :create, :show, :destroy]

  QUIZZES_PER_PAGE = 10

  def index
    @quiz = Quiz.new
    @modal_open = false
    @quizzes = paginated_quizzes
  end

  def create
    @quiz = Quizzes::CreateService.new(quiz_params).call

    if @quiz.persisted?
      @modal_open = false
      @quizzes = paginated_quizzes

      flash[:notice] = "Quiz cadastrado com sucesso"
      redirect_to quizzes_path
    else
      @modal_open = true
      @quizzes = paginated_quizzes

      render :index
    end
  end

  def show
    @quiz = Quiz.find(params[:id]).as_json(methods: [:school_class])

    render json: @quiz, status: :ok
  end

  def destroy
    Quiz.delete(params[:id])
    @quizzes = paginated_quizzes

    redirect_to quizzes_path
  end

  def answer_quiz
    @quiz_feedback = current_user.student.quiz_feedbacks.find_by(quiz_id: params[:quiz_id], status: :pending)

    render status: :not_found, template: 'errors/not_found' if @quiz_feedback.blank?
  end

  def finish_quiz
    Quizzes::FinishService.new(finish_quiz_params).call
    flash[:notice] = "Obrigado por responder o quiz: #{current_quiz.name}"

    redirect_to root_path
  end

  private

  def current_quiz
    @quiz ||= Quiz.find(finish_quiz_params[:quiz_id])
  end

  def quiz_params
    params.require(:quiz).permit(:name, :school_class_id)
  end

  def finish_quiz_params
    params.require(:quiz).permit(:quiz_id, :quiz_feedback_id, questions: %i[question_id answer])
  end

  def current_page
    @current_page ||= params[:page] || 1
  end

  def paginated_quizzes
    Quiz.paginate(page: current_page, per_page: QUIZZES_PER_PAGE)
  end
end
