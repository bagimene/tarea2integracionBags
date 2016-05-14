require 'test_helper'
include	ApplicationHelper

class ApiControllerTest < ActionController::TestCase
=begin  
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
    	assert respuestaJson.count == 3, "no tiene la cantidad de elementos requeridos"
    	#respuestaJson.each do |elemento|
    	#	if elemento 
    	#end    	
    	assert 0 == respuestaJson["metadata"]["total"], "cantidad total mal obtenida"
    	assert 1 == respuestaJson["metadata"].count, "metadata debería tener solo un elemento"
    	#faltaría ver lo que está dentro de cada post, pero aquí no hay. Es para hacerlo en otro test sólo viendo el formato de un post existente
    	assert 0 == respuestaJson["posts"].count, "cantidad de posts mal obtenida"
    	assert "" == respuestaJson["version"], "versión mal actualizada"

    else 
    	return
    end
  end
=end


  #############################
  ##TEST PARA ... :
  #############################


end
