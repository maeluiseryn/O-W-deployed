#encoding: UTF-8
class EmailBoxController < ApplicationController
  def index
    
    @emails =current_user.email_dbs
    respond_to do |format|
      format.html # index.html.erb

    end
  end
  def destroy
    @email = EmailDb.find(params[:id])

    define_path
    ServerFileOperation.delete(@email.content,@public_path)
    @email.destroy
    respond_to do |format|
      format.html { redirect_to(email_box_path) }
      format.xml  { head :ok }
    end
  end

  def show
     @email = EmailDb.find(params[:id])
     respond_to do |format|
      format.html {render Rails.root.to_s+@email.content}
      end
  end


end
