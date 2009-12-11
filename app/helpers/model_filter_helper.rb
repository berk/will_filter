# Methods added to this helper will be available to all templates in the application.
module ModelFilterHelper
  def will_filter(opts = {})
    render :partial=> "/model_filter/filter"
  end
end
