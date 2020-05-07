class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :attendance_work, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
  before_action :admin_or_correct_user, only: [:index, :show, :edit_one_month]
  
  def index
    @users = User.all
  end
  
  def attendance_work
   @work_users = []
    User.all.each do |user|
      if user.attendances.any?{|a|
        (Date.today && 
        a.started_at.present? && 
        a.finished_at.blank?)}
      @work_users.push(user)
      end
    end
  end
  
  def import
    # fileはtmpに自動で一時保存される
    if params[:file].blank?
       flash[:danger] = "CSVファイルが選択されてません。"
    else User.import(params[:file])
       flash[:success] = "インポートしました。"
    end
       redirect_to users_url
  end
 
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    @date = @user.attendances.where(worked_on: @first_day..@last_day)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # 保存成功後、ログインします。
      flash[:success] = "新規作成に成功しました"
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
       flash[:success] = "ユーザー情報を更新しました。"
       redirect_to user_url
    else
       render :edit      
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(user_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :password_confirmation)
    end
    
    def user_info_params
      params.permit(:name, :email, :password, :affiliation, :employee_number, :uid, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end
    
    #def basic_info_params
      #params.require(:user).permit(:affiliation, :basic_time, :work_time)
    #end
    
     # beforeフィルター

    # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      User.paginate(page: params[:page], per_page: 20)
      unless current_user.admin? || current_user?(@user)
        flash[:danger] = "権限がありません。"
        redirect_to(root_url)
      end  
    end
end
