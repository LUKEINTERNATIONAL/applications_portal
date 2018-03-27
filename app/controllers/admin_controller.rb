class AdminController < ApplicationController

  before_filter :check_login, :except => ['login', 'logout', 'login!', 'logout', 'dologin']  
  
  def index
	  
    @pagesize = 6
        
    page = (params[:page] || 1)
    
    offset = ((page.to_i - 1) * @pagesize)
    
    offset = 0 if offset < 0
  
    @apps = Application.all.offset(offset).limit(@pagesize)

    #producing a view that will be properly jsonified at the view side

    @applications = []

    @apps.each do |app|

      record = {
          "id" => (app.id rescue nil),
          "name" => (app.application_name rescue nil),
          "url" => (app.url rescue nil),
          "icon" => (app.icon_link rescue nil),
          "updated" => (app.updated_at.strftime("%d/%b/%Y %H:%M") rescue nil)
      }

      @applications << record
    end

    @total = Application.all.count
    
    @lastpage = (@total / @pagesize) rescue 1
  
    if (@total % @pagesize) > 0
      
      @lastpage = @lastpage + 1
      
    end
  
  end

  def ajax_apps_list
  
    pagesize = 6
        
    page = (params[:page] || 1)
    
    offset = ((page.to_i - 1) * pagesize)
    
    offset = 0 if offset < 0
  
    apps = Application.all.offset(offset).limit(pagesize)
    result = []
    
    apps.each do |app|
    
      record = {            
            "id" => (app.id rescue nil),
            "name" => (app.application_name rescue nil),            
            "url" => (app.url rescue nil),
            "icon" => (app.icon_link rescue nil),
            "updated" => (app.updated_at.strftime("%d/%b/%Y %H:%M") rescue nil)
         }
    
      result << record
    end
  
    render :json => result
  
  end

  def ajax_delete_icon
  
    if File.exists?("#{Rails.root}/public/data/#{params["values"]["icon"].strip}")
      
      File.delete("#{Rails.root}/public/data/#{params["values"]["icon"].strip}")
    
    end
  
    Application.find(params["values"]["id"]).update_attributes(:icon_link => nil) # rescue nil
  
    redirect_to "/admin/ajax_apps_list?page=" + (params["page"] || 1).to_s and return
  
  end

  def upload_file
  
    ext = params[:uploadfile][0].original_filename.match(/\.([^\.]+)$/)[1] rescue nil
    
    post = DataFile.save(params[:uploadfile], "img#{params["id"]}.#{ext}")
    
    Application.find(params["id"]).update_attributes(:icon_link => "img#{params["id"]}.#{ext}") # rescue nil
  
    render :text => "File has been uploaded successfully"
  end
  
  def user_list
  
    @pagesize = 6
        
    page = (params[:page] || 1)
    
    offset = ((page.to_i - 1) * @pagesize)
    
    offset = 0 if offset < 0
  
    if !@user.role.blank?
    
      if @user.role.strip.downcase == "admin"
      
        users = User.find(:all, :limit => @pagesize, :offset => offset)	
        
      else
      
        users = [@user]
      
      end
    
    else
    
      users = [@user]
    
    end
  
    @users = []
    
    users.each do |user|
    
      record = {     
            "id" => (user.id rescue nil),       
            "username" => (user.username rescue nil),
            "first_name" => (user.first_name rescue nil),
            "last_name" => (user.last_name rescue nil),
            "status" => (user.user_status rescue nil),
            "role" => (user.role rescue nil),
         }
    
      @users << record
    end
  
    @total = User.all.count
    
    @lastpage = (@total / @pagesize) rescue 1
  
    if (@total % @pagesize) > 0
      
      @lastpage = @lastpage + 1
      
    end
  
  end

  def void
  
    app = Application.find(params["id"]) rescue nil
  
    
    if File.exists?("#{Rails.root}/public/data/#{app["icon_link"].strip rescue nil}")
      
      File.delete("#{Rails.root}/public/data/#{app["icon_link"].strip rescue nil}") rescue nil
    
    end
  
    app.destroy
  
    redirect_to "/admin" and return
      
  end

  def void_user
  
    user = User.find(params["id"]) rescue nil
      
    user.destroy rescue nil
  
    redirect_to "/admin/user_list" and return
      
  end

  def update_app
  
    if !params["values"].blank?
    
      if params["values"]["id"].strip.downcase == "new"
    
        app = Application.create(:application_name => params["values"]["name"], :url => params["values"]["url"]) rescue nil
    
      else
      
        app = Application.find(params["values"]["id"]).update_attributes(:application_name => params["values"]["name"], :url => params["values"]["url"]) rescue nil
      
      end
    
    end
  
    render :text => (app.id rescue nil)
  
  end

  def update_user
  
    if !params["values"].blank?
    
      if params["values"]["id"].strip.downcase == "new"
    
        if params["values"]["username"].blank?
        
          render :json => {:error => "Username can't be blank!"}.to_json and return
        
        end
    
        if !User.find_by_username(params["values"]["username"]).blank?
        
          render :json => {:error => "Username already taken!"}.to_json and return
        
        end
    
        user = User.create(:first_name => params["values"]["first_name"], :last_name => params["values"]["last_name"], :role => params["values"]["role"], :user_status => params["values"]["status"], :username => params["values"]["username"]) rescue nil
    
      else
      
        if !params["values"]["role"].blank? and !params["values"]["status"].blank?
        
          user = User.find(params["values"]["id"]).update_attributes(:first_name => params["values"]["first_name"], :last_name => params["values"]["last_name"], :role => params["values"]["role"], :user_status => params["values"]["status"]) rescue nil 
      
        else 
        
          user = User.find(params["values"]["id"]).update_attributes(:first_name => params["values"]["first_name"], :last_name => params["values"]["last_name"]) # rescue nil
          
        end
      
      end
    
    end
  
    render :json => {:success => (user.id rescue nil)}.to_json
  
  end

  def ajax_users_list
  
    @pagesize = 6
        
    page = (params[:page] || 1)
    
    offset = ((page.to_i - 1) * @pagesize)
    
    offset = 0 if offset < 0
  
    if !@user.role.blank?
    
      if @user.role.strip.downcase == "admin"
      
        users = User.find(:all, :limit => @pagesize, :offset => offset)	
        
      else
      
        users = [@user]
      
      end
    
    else
    
      users = [@user]
    
    end
  
    @users = []
    
    users.each do |user|
    
      record = {     
            "id" => (user.id rescue nil),       
            "username" => (user.username rescue nil),
            "first_name" => (user.first_name rescue nil),
            "last_name" => (user.last_name rescue nil),
            "status" => (user.user_status rescue nil),
            "role" => (user.role rescue nil),
         }
    
      @users << record
    end
  
    @total = User.all.count
    
    @lastpage = (@total / @pagesize) rescue 1
  
    if (@total % @pagesize) > 0
      
      @lastpage = @lastpage + 1
      
    end
  
    render :json => @users.to_json
  
  end

  def edit_user
  end

  def login
  end

  def change_password
  end

  def update_password
  
    if @user.authenticated?(params["oldpassword"])
    
      @user.update_attributes(:plain_password => params["password"]) rescue nil
      
      flash[:notice] = "Password changed!"
      
      redirect_to "/admin/user_list" and return
    
    else
    
      flash[:error] = "Password change failed!"
    
      redirect_to "/admin/change_password" and return
    
    end
  
  end

  def add_user
	
		@user = User.new(params[:user])
		@user.save
		redirect_to "/admin/user_list?user_id=#{params[:user_id]}"
		
  end

  def block_user
	logged_in(params[:user_id])
  end

  def change_role
	logged_in(params[:user_id])
  end
                           
  def login!(user)
    session[:current_user_id] = user.id
    @@current_user = user
  end

  def logout
    session[:current_user_id] = nil
    @@current_user = nil
    
    redirect_to "/" and return
  end

  def dologin
  
    user = User.find_by_username(params[:username]) rescue nil
    
    if !user.blank? and user.authenticated?(params[:password])
      login! user
      
      session[:flash] = nil
      
      redirect_to "/admin/index" and return
    else
      flash[:error] = 'That username and/or password was not valid.'
      
      redirect_to "/admin/login" and return
    end
    
  end


protected

  def check_login
    # raise params.inspect
    if session[:current_user_id].blank?
      verify(params[:username], params[:password])
      
    else
    
      @user = User.find(session[:current_user_id]) rescue nil
      
    end
  end

  def verify(username, password)
    
    @user = User.find_by_username(username) rescue nil
    
    if !@user.blank? and @user.authenticated?(password)
      login! @user
      
      # redirect_to "/admin/index" and return
    else
      # flash[:error] = 'That username and/or password was not valid.'
      
      redirect_to "/admin/login" and return
    end
    
  end
  
end
