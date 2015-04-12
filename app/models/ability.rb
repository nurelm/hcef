class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new
    if user.role? :admin
        can :manage, :all
    elsif user.role? :instructor
        can :manage, :all
        #afterschool
        #this next line of code does not work; figure out why
        can :create, AfterSchool
        can :manage, AfterSchool do |afterschool|
            afterschool_instructors = user.instructor.programs.map{|c| c.after_schools.map(&:id)}
            afterschool_instructors.include? after_school.id
        end
        
        #can :read, After_school
        #can :update, After_school do |afterschool|
            #afterschool_ins = afterschool.program.instructors.map(&:id)
        #end

        #assignment
        
        #child
        can :create, Child
        can :manage, Child do |child|
            child_instructors = user.instructor.programs.map{|c| c.children.map(&:id)}
            child_instructors.include? child.id
        end
        #keep in mind this may change
        
        #enrichment
        can :create, Enrichment
        can :manage, Enrichment do |enrichment|
            enrichment_instructors = user.instructor.programs.map{|c| c.enrichments.map(&:id)}
            enrichment_instructors.include? enrichment.id
        end
        
        #enrollment
        
        #field_trip
        can :create, FieldTrip
        can :manage, FieldTrip do |field_trip|
            field_trip_instructors = user.instructor.programs.map{|c| c.field_trips.map(&:id)}
            field_trip_instructors.include? field_trip.id
        end
        
        #guardian
        can :manage, Guardian
        #make sure instructors can only see guardians linked to the child
        #DO THIS
        
        #instructor
        can :read, Instructor
        can :update, Instructor do |instructor|
            instructor.id == user.instructor_id
        end

        #location
        can :manage, Location

        #can :create, Location
        #can :manage, Location do |location|
        #    program_instructors = user.instructor.programs.map{|c| c.location.id}
        #    program_instructors.include? location.id
        #end

        #sub_location

        #program
        can :manage, Program

        #provider
        can :read, Provider
        
        #school
        can :manage, School
        
        #user
        can :update, User do |current_user|
            current_user.id == user.id
        end
    end
    else can :manage, :all
    #elsif user.role? :guardian
    #    can :manage, Child do |child|
    #        child.guardian.id == user.guardian_id
    #    end
  end
end
