class AddColumnCourseToSchoolClass < ActiveRecord::Migration[7.1]
  def change
    add_column :school_classes, :course, :string, limit: 255
  end
end
