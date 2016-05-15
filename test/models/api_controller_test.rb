require 'test_helper'
include	ApplicationHelper

class ApiControllerTest < ActionController::TestCase
#=begin  
  #############################
  ##TEST PARA PARÁMETROS CORRECTOS:
  #############################
  test "validar token" do
  	require 'json'
  	#por ahora probamos local

  	url = rutaPost     
  	params = {"tag"=> "snowy","access_token"=> "24342342"}
	data =  httpPostRequest(url , nil, params)
    consultaTags = JSON.parse(data)
    #ApiController.instagramTag()
    assert consultaTags["meta"] == "error en parámetros"
    #assert_response :success
  end
  test "validar tag vacío" do
  	require 'json'
  	#por ahora probamos local

  	url = rutaPost     
  	params = {"tag"=> "","access_token"=> access_token}
	data =  httpPostRequest(url , nil, params)
    consultaTags = JSON.parse(data)
    #ApiController.instagramTag()
    assert consultaTags["meta"] == "error en parámetros"
    #assert_response :success
  end
  test "validar tag inexistente" do
  	require 'json'
  	#por ahora probamos local

  	url = rutaPost     
  	params = {"tag"=> ".","access_token"=> access_token}
	data =  httpPostRequest(url , nil, params)
    consultaTags = JSON.parse(data)
    #ApiController.instagramTag()
    assert consultaTags["meta"] == "error en parámetros"

    params = {"tag"=> "@^","access_token"=> access_token}
	data =  httpPostRequest(url , nil, params)
	consultaTags = JSON.parse(data)
    assert consultaTags["meta"] == "error en parámetros"
  end
  test "validar parámetros inexistentes" do
  	require 'json'
  	#por ahora probamos local

  	url = rutaPost    
  	params = {"tag"=> ""} #faltaría el access_token en este caso
	data =  httpPostRequest(url , nil, params)
    consultaTags = JSON.parse(data)
    #ApiController.instagramTag()
    assert consultaTags["meta"] == "error en parámetros"
    #assert_response :success
  end
  test "validar parámetros extras" do
  	require 'json'
  	url = rutaPost    
  	params = {"tag"=> "snowy", "extra"=> "de más","access_token"=> access_token}
	data =  httpPostRequest(url , nil, params)
    consultaTags = JSON.parse(data)
    assert consultaTags["meta"] == "error en parámetros"
  end


  #############################
  ##TEST PARA RESPUESTA DEL JSON:
  #############################
  test "validar respuesta json" do
  	require 'json'
  	url = rutaPost    
  	#el siguiente tag debería dar respuesta cero en su búsqueda
  	params = {"tag"=> "34213418457d2edw21jsjc018487xnzm873731cmc","access_token"=> access_token}
	data =  httpPostRequest(url , nil, params)
    

    #metadata = [:total => totalTags] 
    #posts = Array.new
    #cadaPost = {:tags => tagsAsociados,:username => username, :likes => likes, :url => url, :caption => caption}
    #posts.push(cadaPost)
    #render :json => {:metadata => metadata, :posts => posts, :version => version}

    assert valid_json?(data), "json no válido"
    if valid_json?(data) 
    	respuestaJson = JSON.parse(data)
    	if tokenDesactualizado(respuestaJson) == true
    		assert tokenDesactualizado(respuestaJson) == true
    	else 
    		assert tokenDesactualizado(respuestaJson) == false

    		jsonErrorString = {  :meta => { :error_type => "OAuthAccessTokenException", :code => 400,
			        :error_message => "The access_token provided is invalid."  } }
			jsonError = jsonErrorString.to_json#JSON.parse(jsonErrorString)  
    		assert tokenDesactualizado(jsonError) == true

    		assert respuestaJson.count == 3, "no tiene la cantidad de elementos requeridos"
	    	#respuestaJson.each do |elemento|
	    	#	if elemento 
	    	#end    	
	    	assert 0 == respuestaJson["metadata"]["total"], "cantidad total mal obtenida"
	    	assert 1 == respuestaJson["metadata"].count, "metadata debería tener solo un elemento"
	    	#faltaría ver lo que está dentro de cada post, pero aquí no hay. Es para hacerlo en otro test sólo viendo el formato de un post existente
	    	assert 0 == respuestaJson["posts"].count, "cantidad de posts mal obtenida"
	    	if versionCommit != -11
	    	  assert versionCommit.to_s == respuestaJson["version"], "versión mal actualizada"
	    	end
    	end
    else 
    	return
    end
  end
#=end


  #############################
  ##TEST PARA MÉTODO httpGetRequest:
  #############################
  test "validar httpGetRequest" do
	require 'json'
	url = "https://api.instagram.com/v1/tags/snowy?access_token=" + access_token
	data =  httpGetRequest(url , nil)
	assert valid_json?(data), "json no válido"
  end

  #############################
  ##TEST PARA MÉTODO instagramTagMethod:
  #############################
  test "validar instagramTagMethod" do
	require 'json'
	iniciar({:total => 0}, Array.new, "")

	data = instagramTagMethod("snowy", access_token)
	if getDaError(data) == false

    	assert getDaError(data) == false, "1"
    		
		#debería devolver 1 porque está bueno
		assert data == 1, "2"
		data = instagramTagMethod("", access_token)	
		#debería devolver 0 porque está malo
		assert data == 0, "3"
		data = instagramTagMethod("snowy", "3421342")	
		#debería devolver 0 porque está malo el token
		assert data == 0, "4"
		assert getDaError(data) == true, "5"
    else 
    	assert getDaError(data) == true, "6"
    end	
  end

  #############################
  ##TEST PARA VERSIÓN DEL COMMIT GIT:
  #############################
  test "validar versión master" do	
  	if versionCommit != -11
	    assert_not -1 == versionCommit, "versión no está en número"
	    assert -1 == convertirStringInt("versiónSinNúmero"), "no se puede parsear a int"
	    assert 1 == convertirStringInt("versiónConNúmero1"), "error al convertir"
	    assert 437 == convertirStringInt("versiónConNúmero437"), "error al convertir más de un dígito"
	end
  end

  #############################
  ##TEST PARA VALIDAR JSON:
  #############################
  test "validar json" do	
    assert valid_json?("asdas") == false, "json no válido"
  end
end
