class CategoriesController < ApplicationController

	before_action :restrict_admin_user

  def index
    @categories = Category.all
  end

	def new
    @category = Category.new
  end

	def edit
		@category = Category.find(params[:id])
  end

	def create
    @category = Category.new(category_params)
		if @category.save
			redirect_to categories_url
		else
			render :new
		end
	end
	
  def update
		if @category.update(category_params)
			redirect_to categories_url
		else
			render :edit
		end
  end

	def destroy
		@category = Category.find_by(id: params[:id])
    @category.delete
  	redirect_to categories_url
  end

  private

    def category_params
      params.require(:category).permit(:name, :description)
		end
		
		def restrict_admin_user
			unless user_admin?
				return redirect_to root_path
			end
		end

end
