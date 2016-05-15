class ApiController < ApplicationController

  include	ApplicationHelper
  
  layout false

  ## Endpoint de /instagram/tag/buscar
  def instagramTag
    
    require 'json'
    iniciar({:total => 0}, Array.new, "")
    begin  

      tag = params[:tag]
      token = params[:access_token]
      if tag.nil? || token.nil? || tag == "" || token == "" || params.count != 4 #sería 5 si fuera con header, pero no
        render :json => {:meta => "error en parámetros"}, :status => 400
        #render :json => {:error => "error 400 por parámetros malos"}  
        return
      end

    rescue Exception => e  
      render :json => {:meta => "error en parámetros"}, :status => 400
      #Haml::Engine.new(File.read(File.join(Rails.root, 'app/views/xxxx','_form.html.haml'))).render(Object.new, :hello => "Hello World")
      return
    end   

     valor = instagramTagMethod(tag.to_s,token.to_s)
     if valor == 0
        render :json => {:meta => "error en parámetros"}, :status => 400
     elsif valor == 1
        render :json => {:metadata => @metadataGlobal, :posts => @postsGlobal, :version => @versionGlobal} 
     end
  end
end
