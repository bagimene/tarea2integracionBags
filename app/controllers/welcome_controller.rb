class WelcomeController < ApplicationController
  include ApplicationHelper
  #include
  def index
  	#@popular = Instagram.media_popular
  	@show = versionCommit
  	#@show = httpGetRequest("https://api.instagram.com/v1/tags/snowy/media/recent?access_token=2019746130.59a3f2b.86a0135240404ed5b908a14c0a2d9402" , nil )
  	#@show = httpPostRequest(rutaPost, nil, {"tag"=> "snowy", "extra"=> "de más", "access_token"=> access_token} )
    #@show = convertirStringInt("versiónSinNúmero437")
  end
end
