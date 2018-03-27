class UploadController < ApplicationController
  def index     
  end
  
  def uploadFile
    post = DataFile.save(params[:photos])
    render :text => "File has been uploaded successfully"
  end
end
