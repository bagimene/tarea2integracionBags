class ApiController < ApplicationController

  include	ApplicationHelper
  #include ReceiveOrdersHelper
  #include PagosHelper
  #include FacturarHelper
  #include InventarioHelper

  
  layout false

  ## Endpoint de /instagram/tag/buscar
  def instagramTag
    require 'json'

    begin  

      tag = params[:tag]
      token = params[:access_token]
      if tag.nil? || token.nil?
        render :nothing => true, :status => 400
        #render :json => {:error => "error 400 por parámetros malos"}  
        return
      end

    rescue Exception => e  
      render :nothing => true, :status => 400 
      return
    end  
        
    url = "https://api.instagram.com/v1/tags/" + tag.to_s + "/media/recent?access_token="  + token.to_s

    #url = "https://api.instagram.com/v1/tags/" + tag.to_s + "?access_token="  + token.to_s
    #totalTags = consultaTags["data"]["media_count"]
    #metadata = [:total => totalTags] 
    #url = "https://api.instagram.com/v1/tags/search?q=" + tag.to_s + "&access_token="  + token.to_s
    data =  httpGetRequest(url , nil )
    consultaTags = JSON.parse(data)

    totalTags = consultaTags["data"].count   #si se quiere el verdadero total, arriba se saca
    metadata = [:total => totalTags] 

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
      cadaPost = [:tags => tagsAsociados,:username => username, :likes => likes, :url => url, :caption => caption]
      posts.push(cadaPost)  
    end    

    version = ""    
    render :json => {:metadata => metadata, :posts => posts, :version => version}  
  end











  ## Endpoint de /api/facturas/recibir/:id
  def facturarRecibir
    id = params[:id]
    result = analizarFactura(id)
    render :json => {:validado => result, :idfactura => id}    
  end

  ## Endpoint de /api/pagos/recibir/:id?idfactura=xxxxx
  def pagoRecibir
      Rails.logger.debug("debug:: transferencia recibida")
    idPago = params[:id]
    idFactura = params[:idfactura]
    result = analizarPago(idPago,idFactura)
    Thread.new do
      Rails.logger.debug("debug:: intentamos despachar")
      ## Gatillamos el envio desde aqui si es posible?
      if result == true
        res = verSiEnviar(idFactura)
      end
      nOtroGrupo = Grupo.find_by(factura: idFactura)["nGrupo"]
      #url = "http://localhost/api/despacho/recibir/" + fact["_id"]
      url = "http://integra" + nOtroGrupo.to_s + ".ing.puc.cl/api/despacho/recibir/" + idFactura
      ans = httpGetRequest(url ,nil)
      Rails.logger.debug("debug:: le avisamos al otro grupo")


    end
    render :json => {:validado => result, :idtrx => idPago}
  end

  ## Endpoint de /api/oc/recibir/:id Debe comprobar la oc antes de enviar al metodo compartido con los ftp
  def ocRecibir
    id = params[:id]

    oc = JSON.parse(obtenerOrdenDeCompra(id))
    if oc[0] == nil
      render :json => {:aceptado => false, :idoc => id} 
      return
    end
    if oc[0]["param"] == "id"
      render :json => {:aceptado => false, :idoc => id} 
      return
    end
    ocDB = Oc.find_by(oc: id)   
    if ocDB != nil
      render :json => {:aceptado => false, :idoc => id} 
      return

    end
    result = analizarOC(id)      
    render :json => {:aceptado => result, :idoc => id} 
    
    Thread.new do
      fact = JSON.parse(emitirFactura(id))
      ocBD = Oc.find_by(oc: id)
      ocBD.update(factura: fact["_id"])
      nOtroGrupo = Grupo.find_by(idGrupo: oc[0]["cliente"])["nGrupo"]
      #url = "http://localhost/api/facturas/recibir/" + fact["_id"]
      url = "http://integra" + nOtroGrupo.to_s + ".ing.puc.cl/api/facturas/recibir/"  + fact["_id"]

      ans = httpGetRequest(url ,nil)
    end
    
  end
  
  ## Endpoint de /api/despacho/recibir/:id Debe comprobar la oc antes de enviar al metodo compartido con los ftp
  def despachoRecibir
    idFactura = params[:id]
    
    ocBD = Oc.findBy(factura: idFactura)
    
    if ocBD == nil
      render :json => {:validado => false} 
      return
    end
    
    ## Gatilla el recibir los productos
    ####################################
    
    if ans > ocBD.cantidad
      render :json => {:validado => true} 
      return
    end
    render :json => {:validado => false} 
  end
end
