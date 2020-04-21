class AddAttendanceTypeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :attendance_type, :string
  end
end
