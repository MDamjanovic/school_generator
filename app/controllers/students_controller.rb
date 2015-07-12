class StudentsController < ApplicationController

  def update
    @student = Student.find(params[:id])
    with_special_needs = @student.with_special_needs.nil?? true: nil

    @student.update_attribute(:with_special_needs , with_special_needs)

    respond_to do |format|
      if @student.save
        format.html { redirect_to :back}
        format.js 
      else
        format.html { redirect_to :back}
        format.js 
      end
    end
  end

end
