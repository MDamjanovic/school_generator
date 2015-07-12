class SchoolsController < ApplicationController
  include ApplicationHelper
  
  before_action :authenticate_user!
  before_action :verify_school, except: [:new , :create]
  before_action :verify_user , only: [:show, :edit, :update, :destroy]

  # manipulation with student
  def generate_students
      @school.generate_students
      redirect_to school_path(@school.id), notice: 'Students were successfully generated.'  
  end

  def schedule_students
      @school.schedule_students   
      redirect_to school_path(@school.id), notice: 'Students were successfully scheduled.'
  end

  def index
    show
  end

  def show 
  end

  def new
    if current_user.added_school?
      redirect_to edit_school_path(current_user.users_school), notice: "You're already created school."
    else
      @school = School.new
    end  
  end

  def edit
  end

  def create
    @school = new_school
    if @school.save
      redirect_to school_path(@school.id), notice: 'School was successfully created.'  
    else
      render :new
    end
  end

  def update
    if @school.update_attributes(school_params)
      @school.update_departments
      redirect_to school_path(@school.id), :notice => "School successfully updated."
    else
      render :edit
    end  
  end   

  def destroy
    @school.remove_all_data
    redirect_to root_path, notice: 'School was successfully destroyed.'
  end


  private
  def new_school
    params = school_params
    params[:user_id] = current_user.id
    School.new(params)
  end

  def school_params
    params.require(:school).permit(:name, :number_of_departments)
  end

  def verify_user
    if current_user.added_school? 
      user_not_authorized unless policy(@school,current_user).authorized?
    else
      redirect_to new_school_path,  alert: "School does not exists. Create school." 
    end 
  end

  def verify_school
    unless School.exists?(params[:id])
      redirect_to root_path
    else
      @school = School.find(params[:id])
    end    
  end

end
