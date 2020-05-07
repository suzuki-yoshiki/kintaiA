class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month, :edit_over_time, :update_over_time, :edit_request_one_month, :update_request_one_month, :edit_change_request, :edit_request_overtime]
  before_action :logged_in_user, only: [:update, :edit_one_month, :edit_over_time, :update_over_time, :edit_request_one_month, :update_request_one_month, :edit_request_overtime]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: [:edit_one_month, :edit_over_time, :update_over_time, :edit_request_one_month, :update_request_one_month, :edit_request_overtime]

  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  def index
  end
  
  def show_work_time
    @attendances = Attendance.all
    respond_to do |format|
     format.html do
      #html用の処理を書く
     end 
      format.csv do
         send_data render_to_string, filename: "show_work_time.csv", type: :csv
      end
    end
  end
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_request_overtime
    @attendance = Attendance.find(params[:id])
  end
  
  def update_request_overtime
  end
  
  def edit_change_request
    @attendance = Attendance.find(params[:id])
  end
  
  def update_change_request
  end
  
  def edit_request_one_month
    @attendance = Attendance.find(params[:id])
  end
  
  def update_request_one_month
    @user = User.find(params[:id])
    @attendance = Attendance.find(params[:id])
    if params[:attendance][:instructor_confirmation].blank?
       flash[:danger] = "承認申請できませんでした。"
    else @attendance.update.attributes(requests_params)
       flash[:success] = "承認申請しました。"
    end
       redirect_to user_url @user
  end
  
  def edit_over_time
    @user = User.find(params[:id])
    @attendance = Attendance.find(params[:id])
    @date = @user.attendances.where(worked_on: @first_day..@last_day)
  end
  
  def update_over_time
    @attendance = Attendance.find(params[:id])
    @user = User.find(params[:attendance][:user_id])
    if params[:attendance][:plan_finished_at].blank? || params[:attendance][:instructor_confirmation].blank?
      flash.now[:danger] = "必須箇所が空欄です。"
    else @attendance.update_attributes(over_time_params)
      flash.now[:success] = "残業申請しました。"
    end
    redirect_to user_url @user
  end

  def edit_one_month
  end

  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        if item[:finished_at].present? && item[:started_at].blank?
            flash[:danger] = "出勤時間が入力されてません"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
        elsif item[:finished_at].blank? && item[:started_at].present?
            flash[:danger] = "退勤時間が入力されてません"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
        end
        attendance.update_attributes!(item)
      end
        flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
        redirect_to user_url(date: params[:date]) and return
        rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
        flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      end
    redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
  end
  
  def edit_log
    @attendance = Attendance.find(params[:id])
  end
  
  private

    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end
    
    #残業申請の情報
    def over_time_params
      params.require(:attendance).permit(:plan_finished_at, :tomorrow, :business_process_content, :instructor_confirmation)
    end
    
    def requests_params
      params.require(:attendance).permit(:mark_instructor_confirmation, :instructor_confirmation)
    end
    
    

    # beforeフィルター

    # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end  
    end
end