class EventPage < Page
  include Radiant::Taggable
  
  attr_accessor :event
  
  def virtual?
    true
  end
  
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
  
  desc %{ Shows the contents if an event is found.}
  tag 'if_event' do |tag|
    tag.locals.event = self.event
    tag.expand if self.event
  end
  
  desc %{ Shows the contents if an event is not found.}
  tag 'unless_event' do |tag|
    tag.expand unless self.event
  end
  
  desc %{ Sets the scope for the current event.}
  tag 'if_event:event' do |tag|
    tag.expand
  end
end