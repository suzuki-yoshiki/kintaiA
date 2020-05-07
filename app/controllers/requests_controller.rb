class RequestsController < ApplicationController
    
    def update
        @user = User.find(params[:user_id])
        @request = Request.find_by(user_id: @user.id)
        if @request.update.attributes(requests_params)
           flash[:success] = "承認申請しました。"
        else
           flash[:danger] = "承認申請できませんでした。"
        end
        redirect_to @user
    end
    
    
      private
      
      
      def requests_params
          params.require(:request).permit(:month, :mark, :superior_id)
      end
    
end
