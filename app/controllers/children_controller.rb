class ChildrenController < ApplicationController
  before_action :set_child, only: [:show, :edit, :update, :destroy, :child_active]
  authorize_resource

  def index
    @children = Child.active.alphabetical.paginate(:page => params[:page], :per_page => 30)
  end

  def show
    @programs = @child.programs
    @average_times = @child.average_activity_time
  end

  def new
  	@child = Child.new
  	@guardian = Guardian.new
  	@school = School.new
  	@locations = Location.all                      if current_user.role == 'admin'
  	@locations = current_user.instructor.locations if current_user.role == 'instructor'
    @school_district = SchoolDistrict.new
  end

  def edit
  	@locations = Location.all                      if current_user.role == 'admin'
  	@locations = current_user.instructor.locations if current_user.role == 'instructor'
  end

  def child_active
  	if @child.active==true
  		@child.active=false
  		@child.save
  		redirect_to dash_path, notice: "#{@child.name} was made inactive"
  	else
  		@child.active=true
  		@child.save
  		redirect_to dash_path, notice: "#{@child.name} was made active"
  	end
  end

  def create
  	@locations = Location.all
		@child = Child.new(child_params)
    if params[:child][:location_ids].nil? #this part checks to see if child was assigned a location, which is mandatory
      @child.errors.add(:base, "Child needs to be assigned to location")
      redirect_to new_child_path, alert: "Child needs to be assigned to location"
		elsif @child.save
			redirect_to programs_url, notice: "#{@child.name} was added to the system"
		else
      redirect_to new_child_path
		end
	end

	def update
		if params[:child][:location_ids].nil? #this part checks to see if child was assigned a location, which is mandatory
      @child.errors.add(:base, "Child needs to be assigned to location")
      redirect_to edit_child_path, alert: "Child needs to be assigned to location"
    elsif @child.update(child_params)
			redirect_to @child, notice: "#{@child.name} has been updated"
		else
			render action: 'edit'
		end
	end

	def destroy
    guardian_name = @child.guardian.try(:name)
    name = @child.name
		@child.destroy

		redirect_to dash_path, notice: "#{name} and all of their associated data has been deleted.
      Please note, that their guardian #{guardian_name} remains in the system and will need to be removed
      separately."
	end

	private

		def set_child
			@child = Child.find(params[:id])
		end

		def child_params
			params.require(:child).permit(:first_name, :last_name, :date_of_birth, :grade, :school_id, :guardian_id, :active, :location_ids => [])
		end
end
