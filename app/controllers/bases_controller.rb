class BasesController < ApplicationController
    before_action :set_user, only: :edit
    
    def index
      @bases = Base.all
    end
    
    def new
      @base = Base.new
    end
    
    def create
     @base = Base.new(base_params)
      if @base.save
        flash[:success] = "拠点情報を追加しました。"
        redirect_to user_bases_url @user
      else
        flash[:danger] = "追加は失敗しました"
        render :new
      end
    end
    
    def edit
      @base = Base.find(params[:id])
    end
    
    def update
      if @base.update_attributes(base_params)
       flash[:success] = "拠点情報を更新しました。"
      else
       flash[:danger] = "更新は失敗しました。"
      end
       redirect_to user_bases_url
    end
    
  private
  
      def base_params
        params.require(:base).permit(:base_name, :base_number, :base_type)
      end
end
