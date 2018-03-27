class HomeController < ApplicationController
  def index  
    @site = YAML.load_file("#{Rails.root}/config/settings.yml")[Rails.env]["site"] rescue "Facility Name" 
  end
  
  def ajax_links
    
    page = params[:page].to_i rescue 1
    
    page = 1 if params.nil? or page < 1
    
    if page == 1
      pagesize = 11 
      
      startpos = 0
    else
      pagesize = 10
      
      startpos = 11 + ((page - 2) * 10)
    end
    
    apps = {}
    
    Application.all.offset(startpos).limit(pagesize).each do |app|

      apps[app.application_name] = [app.url, app.icon_link, app.id]
    
    end
    
    render :json => apps
    
  end

  def log_app
  
    Frequency.create(:application => params["id"], :client => request.remote_ip) rescue nil
    
    render :text => "Logged!"
  
  end

end
