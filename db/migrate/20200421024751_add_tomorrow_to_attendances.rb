class AddTomorrowToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :tomorrow, :string
    add_column :attendances, :business_process_content, :string
    add_column :attendances, :instructor_confirmation, :string
    add_column :attendances, :plan_finished_at, :datetime
  end
end
