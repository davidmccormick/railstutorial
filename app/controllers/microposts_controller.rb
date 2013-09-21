class MicropostsController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user, only: :destroy
	
	def create
		@micropost = current_user.microposts.build(params[:micropost])
		if @micropost.save
			flash[:success] = "Micropost Created"
			redirect_to root_path
		else
			#@feed_items = current_user.feed.paginate(page: params[:page])
			@feed_items = []
			render 'static_pages/home'
		end
	end
	
	def destroy
		# @micropost provided by the #correct_user method
		@micropost.destroy
		redirect_back_or root_path
	end
	
	private
	
		def correct_user
			@micropost = Micropost.find_by_id(params[:id])
			if (@micropost == nil)
				flash[:error] = "Sorry, that micropost could not be found!"
				redirect_to root_path
			elsif (@micropost.user != current_user)
				flash[:error] = "You are not allowed to destroy microposts that you do not own!"
				redirect_to root_path
			end
		end
end
