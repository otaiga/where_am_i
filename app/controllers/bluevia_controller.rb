class BlueviaController < ApplicationController

 CONSUMER_KEY = ENV['BLUEVIA_KEY']
 CONSUMER_SECRET = ENV['BLUEVIA_SECRET']


  def auth
puts "key =" + CONSUMER_KEY
     puts "secret =" + CONSUMER_SECRET
     
     bc = BlueviaClient.new(
               { :consumer_key   => CONSUMER_KEY,
                 :consumer_secret=> CONSUMER_SECRET,
                 :uri            => "https://api.bluevia.com"
               })
               
                 
     service = bc.get_service(:oAuth)
     token, secret, url = service.get_request_token({:callback =>"http://" + request.host_with_port + "/callbackblue"})
     
      puts "Token= " +token 
      puts "Secrect =" +secret
      puts "url = " + url
          
      response.set_cookie(:token, "#{token}|#{secret}")
      
      redirect_to url 
  end


    def callbackblue
    oauth_verifier = params[:oauth_verifier]
      get_token_from_cookie

      @bc = BlueviaClient.new(
               { :consumer_key   => CONSUMER_KEY,
                 :consumer_secret=> CONSUMER_SECRET
               })

       @bc.set_commercial

      @service = @bc.get_service(:oAuth)
      @token, @token_secret = @service.get_access_token(@request_token, @request_secret, oauth_verifier)
      
      session[:token] = @token
       session[:token_secret] = @token_secret
      
      redirect_to  'bluevia/calllocation'
    end


   def calllocation

     @bc = BlueviaClient.new(
               { :consumer_key   => CONSUMER_KEY,
                 :consumer_secret=> CONSUMER_SECRET,
                 :token          => session[:token],
                 :token_secret   => session[:token_secret],
                 :uri            => "https://api.bluevia.com"
               })
   
       @bc.set_commercial
   
     @service = @bc.get_service(:Location)
     location = @service.get_location
   
     latlong = location['terminalLocation']['currentLocation']['coordinates']
   
     @lat = latlong['latitude']
     @lon = latlong['longitude']
     
     
     puts @lat
     puts @lon
     
     session[:lat] = @lat
     session[:lon] = @lon
     
     redirect_to root_path 
   end


      def get_token_from_cookie

      cookie_token = request.cookies['token']
      cookie_token = cookie_token.split("|")
      if cookie_token.size != 2
           raise SyntaxError, "The cookie is not valid"
         end     
       @request_token = cookie_token[0]
       @request_secret = cookie_token[1]

    end


end
