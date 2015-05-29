class LocationsController < ApplicationController
    
    before_action :find_location, :only => [:show, :edit, :update, :destroy]
    
    def find_location
        @location = Location.find_by(id: params["id"])
    end
    
    #Retrieve and display info of all locations
    def index
        if params["keyword"].present?
            @locations = Location.where("city LIKE ?", "%#{params["keyword"]}")
        else
            @locations = Location.all
            @locations = Location.order('city asc')
        end
    end
    
    #Create a new location and insert the new user into table, based on input parameters
    def create
        @location = Location.new
        @location.city = params[:city]
        @location.state = params[:state]
        @location.description = params[:description]
        if @location.save
            redirect_to locations_url, notice: "Thanks for adding a new location."
        else
            render "new"
        end
    end
    
    #Show location details
    def show
        cookies["location_id"] = @location.id
        @location = Location.find_by(id: params[:id])
        @users =  User.where(location_id: params[:id]).order('name')
        if @location == nil
            redirect_to locations_url, notice: "Location not found."
        end
    end
    
    #Edit the Location's details
    def edit
    end
    
    def new
        cookies.delete("location_id")
        @location = Location.new
        render "new"
    end
    
    #Update the database
    def update
        @location.city = params[:city]
        @location.state = params[:state]
        @location.description = params[:description]
        if @location.save
            redirect_to location_url, notice: "Successfully edited location information."
        else
            render "edit"
        end
    end
    
    #Delete location from database
    def destroy
        @location.delete
        redirect_to locations_url
    end
    
end
