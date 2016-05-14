module ApplicationHelper

	
	def rutaPost
		return "https://tareaintegracionbags.herokuapp.com/instagram/tag/buscar"#"http://localhost:3000/instagram/tag/buscar"
	end
	def access_token
		return "2019746130.59a3f2b.86a0135240404ed5b908a14c0a2d9402"
	end

	def httpPostRequest( url, authHeader ,params)
		require 'net/http'
		require 'uri'
		if authHeader.nil?
			headers = {'Content-Type' => 'application/json'}
		else
			headers = {'Authorization' => authHeader , 'Content-Type' => 'application/json'}
		end	

        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)

        if params.nil?
		response = http.post(uri.path,'{}', headers)
		else
		response = http.post(uri.path, params.to_json, headers)	 
		end	

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
		else
			headers = {'Authorization' => authHeader , 'Content-Type' => 'application/json'}
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
       	 	puts "--- Time out de la conexion" 
        	
    	end  
    	if response.nil?
    		return nil
    	end	
  

    	return data = response.body

	end
end
