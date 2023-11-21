class SchoolClassesController < AuthenticatedController
  SCHOOL_CLASSES_PER_PAGE = 10
  before_action :admin_only

  def index
    @school_class = SchoolClass.new
    @modal_open = false
    @school_classes = paginated_school_classes
  end

  def create
    @school_class = SchoolClasses::CreateService.new(school_class_params).call

    if @school_class.persisted?
      @modal_open = false
      @school_classes = paginated_school_classes

      flash[:notice] = "Turma cadastrada com sucesso"
      redirect_to school_classes_path
    else
      @modal_open = true
      @school_classes = paginated_school_classes

      render :index
    end
  end

  def show
    @school_class = SchoolClass.find(params[:id]).as_json(methods: [:students_option_object_list])

    render json: @school_class, status: :ok
  end

  def update
    @school_class = SchoolClasses::UpdateService.new(params[:id], school_class_params).call
    if @school_class.errors.empty?
      @modal_open = false
      flash[:notice] = "Turma atualizada com sucesso"
      redirect_to school_classes_path
    else
      @modal_open = true
      @school_classes = paginated_school_classes

      render :index, status: :unprocessable_entity
    end
  end

  def search
    school_classes = SchoolClass.by_discipline(params[:name]).as_json(only: [:id, :discipline_name, :teacher_name])

    render json: school_classes, status: :ok
  end

  def destroy
    SchoolClass.delete(params[:id])
    @school_classes = paginated_school_classes

    redirect_to school_classes_path
  end

  private

  def school_class_params
    params.require(:school_class).permit(:discipline_name, :teacher_name, :shift, :course, students: [])
  end

  def current_page
    @current_page ||= params[:page] || 1
  end

  def paginated_school_classes
    SchoolClass.paginate(page: current_page, per_page: SCHOOL_CLASSES_PER_PAGE)
  end
end
