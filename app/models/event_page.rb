class EventPage < Page
  include Radiant::Taggable
  
  attr_accessor :event
  
  def find_by_url(url, live = true, clean = false)
    url = clean_url(url) if clean
    if url =~ %r{^#{ self.url }(\d+)/?}
      begin 
        self.event = Event.find($1)
        self
      rescue ActiveRecord::RecordNotFound
        super
      end
    else
      super
    end
  end
  
  tag 'event' do |tag|
    tag.locals.event = self.event
    tag.expand
  end
end