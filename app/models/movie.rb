class Movie < ActiveRecord::Base
  
  VALID_SORTS = ["title", "release_date"]
  
  scope :order_by, lambda { |sort_column| order("#{sort_column} ASC") }
  
  def self.ratings
    Movie.select('DISTINCT rating').order('rating ASC').collect {|result| result.rating}
  end
  
  def self.filtered(params)
    valid_ratings = Movie.ratings
    
    movies = Movie
    movies = movies.order_by(params[:sort]) unless params[:sort].blank? or !VALID_SORTS.include?(params[:sort])
    unless params[:ratings].blank?
      clauses = []
      params[:ratings].keys.each do |rating|
        clauses << "rating = '#{rating}'" if valid_ratings.include?(rating)
      end
      movies = movies.where(clauses.join(" OR "))
    end
    movies.all
  end
end