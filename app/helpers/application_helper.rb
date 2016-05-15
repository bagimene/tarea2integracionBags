module ApplicationHelper

	def rutaPost
		return "https://tareaintegracionbags.herokuapp.com/instagram/tag/buscar"
	    #return "http://localhost:3000/instagram/tag/buscar"
	end
	def access_token
		return "2019746130.59a3f2b.86a0135240404ed5b908a14c0a2d9402"
	end

	def httpPostRequest( url, authHeader ,params)
		require 'net/http'
		require 'uri'
		if authHeader.nil?
			headers = {'Content-Type' => 'application/json'}
		end	

        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

      
		response = http.post(uri.path, params.to_json, headers)	
		data = response.body 
	end

	def valid_json?(json)
  		begin
    	JSON.parse(json)
    	return true
  		rescue JSON::ParserError => e
   		return false
  		end
	end

	def httpGetRequest( url, authHeader)
		require 'net/http'
		require 'uri'
		
		if authHeader.nil?
			headers = {'Content-Type' => 'application/json'}
		end	
        uri = URI.parse(url)    
        #request = Net::HTTP::Get.new(uri, headers) #{'' => ''})
       	
       	begin 

       		  http = Net::HTTP.new(uri.host, uri.port)
			  http.use_ssl = true
			  http.verify_mode = OpenSSL::SSL::VERIFY_NONE # You should use VERIFY_PEER in production
			  request = Net::HTTP::Get.new(uri.request_uri)
			  response = http.request(request)
       	 	#response = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request) } 
       	
       	rescue Errno::ETIMEDOUT  
        	
    	end  
  

    	return data = response.body

	end


	def instagramTagMethod(tag,token)
	    url = "https://api.instagram.com/v1/tags/" + tag + "?access_token="  + token
	    
	    begin
	    #url = "https://api.instagram.com/v1/tags/search?q=" + tag.to_s + "&access_token="  + token.to_s
	      data =  httpGetRequest(url , nil )    
	      consultaTags = JSON.parse(data)
	    rescue => e  #probablemente si devuelve un html por error 404
	      #e.response
	      #render :json => {:meta => "error en parámetros"}, :status => 400
	      return 0
	    end

	    if consultaTags.count == 1 #esto pasa si da error, solo tiene "meta" pero no "data"
	      #render :json => {:meta => "error en parámetros"}, :status => 400
	      return 0
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

	    versionNumero = versionCommit    
	    version = versionNumero.to_s
	    #render :json => {:metadata => metadata, :posts => posts, :version => version} 
	    metadataPush(metadata)
	    postsPush(posts)
	    versionPush(version)
	    return 1
	end

    def metadataPush(metadata_)
       @metadataGlobal = metadata_           
    end
    def postsPush(posts_)
       @postsGlobal = posts_          
    end
    def versionPush(version_)
       @versionGlobal = version_           
    end

    def iniciar(metadata_, posts_, version_)
        @metadataGlobal = metadata_
        @postsGlobal = posts_
        @versionGlobal = version_
    end

    def versionCommit
	    
    	#response = Github::Client::Repos.branches 'bagimene', 'master'
		#require 'rest-client'
		#branch = github(:get, "tareaintegracionbags", "refs/heads/master")
	    #require 'octokit'
	    #user = Octokit.user 'bagimene'
	    url = "https://api.github.com/repos/bagimene/tareaintegracionbags/commits"
		data =  httpGetRequest(url , nil)
		consultaCommits = JSON.parse(data)
		ultimoCommit = consultaCommits[0]["commit"]["message"]
		ultimoCaracter = ultimoCommit[-1,1]
		ultimaVersion = ultimoCaracter.to_i
        return ultimaVersion
    end

end
