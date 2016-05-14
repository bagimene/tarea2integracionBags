class ApiController < ApplicationController

  include	ApplicationHelper
  
  layout false

  ## Endpoint de /instagram/tag/buscar
  def instagramTag
    require 'json'

    begin  

      tag = params[:tag]
      token = params[:access_token]
      if tag.nil? || token.nil? || tag == "" || token == "" || params.count != 5
        render :json => {:meta => "error en parámetros"}, :status => 400
        #render :json => {:error => "error 400 por parámetros malos"}  
        return
      end

    rescue Exception => e  
      render :json => {:meta => "error en parámetros"}, :status => 400
      return
    end  
   
    url = "https://api.instagram.com/v1/tags/" + tag.to_s + "?access_token="  + token.to_s
    
    begin
    #url = "https://api.instagram.com/v1/tags/search?q=" + tag.to_s + "&access_token="  + token.to_s
      data =  httpGetRequest(url , nil )    
      consultaTags = JSON.parse(data)
    rescue => e  #probablemente si devuelve un html por error 404
      #e.response
      render :json => {:meta => "error en parámetros"}, :status => 400
      return
    end

    if consultaTags.count == 1 #esto pasa si da error, solo tiene "meta" pero no "data"
      render :json => {:meta => "error en parámetros"}, :status => 400
      return
    end

    #totalTags = consultaTags["data"].count   #si se quiere el verdadero total, arriba se saca
    #metadata = [:total => totalTags] 
    totalTags = consultaTags["data"]["media_count"]
    metadata = {:total => totalTags}

    url = "https://api.instagram.com/v1/tags/" + tag.to_s + "/media/recent?access_token="  + token.to_s
    data =  httpGetRequest(url , nil )
    consultaTags = JSON.parse(data)

    posts = Array.new 

    consultaTags["data"].each do |cadaTag|
      tagsAsociados = Array.new 
      cadaTag["tags"].each do |asociados|
        tagsAsociados.push(asociados)
      end      
      username = cadaTag["user"]["username"]
      likes = cadaTag["likes"]["count"]
      url = cadaTag["images"]["standard_resolution"]["url"]  #tiene que ser la mejor resolución
      if url.nil?
        url = cadaTag["images"]["thumbnail"]["url"]
        if url.nil?
          url = cadaTag["images"]["low_resolution"]["url"]
        end
      end
      caption = cadaTag["caption"]["text"]
      cadaPost = {:tags => tagsAsociados,:username => username, :likes => likes, :url => url, :caption => caption}
      posts.push(cadaPost)  
    end    

    version = ""    
    render :json => {:metadata => metadata, :posts => posts, :version => version}  
  end
end
