class Rss::SourcesController < ApplicationController
  before_filter :load_source

  def show
    if params[:days]
      @relations = @source.relations.most_cited
                .published_last_x_days(params[:days].to_i)
    elsif params[:months]
      @relations = @source.relations.most_cited
                .published_last_x_months(params[:months].to_i)
    else
      @relations = @source.relations.most_cited
    end
    render :show
  end

  protected

  def load_source
    @source = Source.where(name: params[:id]).first

    # raise error if source wasn't found
    fail ActiveRecord::RecordNotFound, "No record for \"#{params[:id]}\" found" if @source.blank?
  end
end
