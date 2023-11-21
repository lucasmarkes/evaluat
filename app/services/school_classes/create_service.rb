require "dry/transaction/operation"

class SchoolClasses::CreateService
  include Dry::Transaction::Operation

  def initialize(params)
    @params = params
  end

  def call
    create_school_class
  end

  private

  attr_accessor :params

  def load_students(student_ids)
    student_ids.delete_if { |str| str.empty? }

    Student.where(id: student_ids)
  end

  def create_school_class
    students = load_students(params[:students])
    school_class = SchoolClass.new(params.except(:students))

    school_class.students << students

    school_class.save

    school_class
  end
end
