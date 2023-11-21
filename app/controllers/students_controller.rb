class StudentsController < AuthenticatedController
  STUDENTS_PER_PAGE = 10
  before_action :admin_only

  def index
    @student = Student.new
    @student.build_user
    @modal_open = false
    @students = paginated_students
  end

  def create
    @student = Student.new(student_params)

    if @student.save
      @modal_open = false
      @students = paginated_students

      flash[:notice] = "Estudante cadastrado com sucesso"
      redirect_to students_path
    else
      @modal_open = true
      @students = paginated_students

      render :index
    end
  end

  def show
    @student = Student.find(params[:id])
                .as_json(include: { user: { only: [:id, :first_name, :last_name, :email] } }, except: [:user_id])

    render json: @student, status: :ok
  end

  def search
    students = Student.search_by_registration_number(params[:registration_number]).as_json(only: [:id, :registration_number], methods: [:full_name])

    render json: students, status: :ok
  end

  def update
    @student = Student.find(params[:id])
    if @student.update(student_params)
      flash[:notice] = "Estudante atualizado com sucesso"
      redirect_to students_path
    else
      @modal_open = true
      @students = paginated_students

      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    Student.delete(params[:id])
    @students = paginated_students

    redirect_to students_path
  end

  private

  def student_params
    params.require(:student).permit(:registration_number, :document_number,
      user_attributes: %i[id first_name last_name email])
  end

  def current_page
    @current_page ||= params[:page] || 1
  end

  def paginated_students
    Student.paginate(page: current_page, per_page: STUDENTS_PER_PAGE)
  end
end
