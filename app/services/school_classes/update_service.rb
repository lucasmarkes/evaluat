require "dry/transaction/operation"

class SchoolClasses::UpdateService
  include Dry::Transaction::Operation

  def initialize(school_class_id, params)
    @school_class_id = school_class_id
    @params = params
  end

  def call
    update_school_class
  end

  private

  attr_accessor :params, :school_class_id

  def school_class
    @school_class ||= SchoolClass.find(school_class_id)
  end

  def update_school_class
    ActiveRecord::Base.transaction do
      school_class.assign_attributes(params.except(:students))
      update_school_class_students(params[:students])

      raise ActiveRecord::Rollback unless school_class.save
    end

    school_class
  end

  def remove_unnecessary_students(old_student_ids, new_student_ids)
    old_student_ids.each do |old_id|
      unless new_student_ids.include?(old_id)
        school_class.school_class_students.find_by(student_id: old_id).delete
      end
    end
  end

  def create_new_students(old_student_ids, new_student_ids)
    new_student_ids.each do |new_id|
      school_class.students << Student.find(new_id) unless old_student_ids.include?(new_id)
    end
  end

  def update_school_class_students(student_ids)
    student_ids.delete_if { |str| str.empty? }
    new_student_ids = student_ids.map { |str| str.to_i }
    old_student_ids = school_class.students.pluck(:id)

    remove_unnecessary_students(old_student_ids, new_student_ids)
    create_new_students(old_student_ids, new_student_ids)
  end
end
