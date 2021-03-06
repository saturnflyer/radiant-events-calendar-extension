class Admin::EventsController < Admin::ResourceController
  if defined?(TextileEditorExtension)
    before_filter :include_textile_editor_assets, :only => [:new, :edit]
  end
  before_filter :adjust_times, :only => [ :create, :update ]
  model_class Event

  helper 'admin/references'
  
  def index
    if params['looking'] == 'back'
      @events = Event.past
    else
      @events = Event.future
    end
  end

  def auto_complete_for_event_category
    find_options = {
      :select => "DISTINCT category",
      :conditions => [ "LOWER(category) LIKE ?", "#{params[:event][:category].downcase}%" ],
      :order => "category ASC",
      :limit => 10 }
    @items = Event.send(:with_exclusive_scope) { Event.all find_options }
    render :inline => "<%= auto_complete_result @items, 'category' %>"
  end

  protected

    def adjust_times
      start_time = parse_time(params[:event][:'start_time(5i)'])
      end_time = parse_time(params[:event][:'end_time(5i)'])
      params[:event].delete(:'start_time(5i)')
      params[:event].delete(:'end_time(5i)')

      date = Date.parse(params[:event][:date])
      params[:event][:start_time] = start_time.blank? ? start_time : start_time.change(:year => date.year, :month => date.month, :day => date.day)
      params[:event][:end_time] = end_time.blank? ? end_time : end_time.change(:year => date.year, :month => date.month, :day => date.day)
    end

  private

    def parse_time(str)
      str.blank? ? str : Time.parse(str)
    end

end
