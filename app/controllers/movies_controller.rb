class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  #list of required params, do redirect to make it RESTful
  req_params = { #{key => def_value, ...
    :sort_by => nil,
    :ratings => Hash[Movie.all_ratings.map {|r| [r, "1"]}]}
  params_val = {}
  tobe_redirect = false
  req_params.each do |k,v|
    if !params[k] && session[k]
      #in case of missing params but seesion of last value is found
      tobe_redirect = true
    else
      session[k] = (params[k] or v)
    end
    params_val[k] = session[k]
  end
  if tobe_redirect then
    flash.keep
    redirect_to movies_path(params_val)
  end
  #sorting issue
    sorting_attr = session[:sort_by]
    eval "@sort_by_#{sorting_attr} = 1"
  #rating issue
    @selected_ratings = session[:ratings]
    @all_ratings = Movie.all_ratings
  #get the movies
    @movies = Movie.order(sorting_attr).find_all_by_rating(@selected_ratings.keys)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
