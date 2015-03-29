class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new
    if user.role? :admin
        can :manage, :all
    elsif user.role? :instructor
        #afterschool
        #this next line of code does not work; figure out why
        can :manage, AfterSchool
        #can :read, After_school
        #can :update, After_school do |afterschool|
            #afterschool_ins = afterschool.program.instructors.map(&:id)
        #end

        #assignment
        
        #child
        can :manage, Child do |child|
            child_instructors = user.instructor.programs.map{|c| c.children.map(&:id)}
            child_instructors.include? child.id
        end
        #keep in mind this may change
        can :create, Child
        
        #enrichment
        can :manage, Enrichment do |enrichment|
            enrichment_instructors = user.instructor.programs.map{|c| c.enrichments.map(&:id)}
            enrichment_instructors.include? enrichment.id
        end
        can :create, Enrichment
        
        #enrollment
        
        #field_trip
        can :manage, FieldTrip do |field_trip|
            field_trip_instructors = user.instructor.programs.map{|c| c.field_trips.map(&:id)}
            field_trip_instructors.include? field_trip.id
        end
        can :create, FieldTrip
        
        #guardian
        #make sure instructors can only see guardians linked to the child
        
        #instructor
        can :read, Instructor
        can :update, Instructor do |instructor|
            instructor.id == user.instructor_id
        end

        #location
        can :manage, Location

        #program
        can :read, Program do |program|
            program_instructors = user.instructor.programs.map(&:id)
            program_instructors.include? program.id
        end

        #provider
        can :read, Provider
        
        #school
        can :manage, School
        
        #user
        can :update, User 
    
    #elsif user.role? :guardian
    #    can :manage, Child do |child|
    #        child.guardian.id == user.guardian_id
    #    end
    end
  end
end
