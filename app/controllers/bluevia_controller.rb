class BlueviaController < ApplicationController

 CONSUMER_KEY = ENV['BLUEVIA_KEY']
 CONSUMER_SECRET = ENV['BLUEVIA_SECRET']

require 'bluevia'
require 'open-uri'
require 'json'
require 'httparty'
include Bluevia



def geonames
       #Geo-names bit

           places_nearby = Geonames::WebService.find_nearby_place_name @lat, @lon
            
            @here = places_nearby.first.name
            @here2 = places_nearby.first.country_name
            puts @here
            session[:location] = @here
            return
  end


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
          
       $request_token = token
       $request_secret = secret
      
      redirect_to url 
  end


    def callbackblue
    oauth_verifier = params[:oauth_verifier]

      @bc = BlueviaClient.new(
               { :consumer_key   => CONSUMER_KEY,
                 :consumer_secret=> CONSUMER_SECRET
               })

       @bc.set_commercial

      @service = @bc.get_service(:oAuth)
      @token, @token_secret = @service.get_access_token($request_token, $request_secret, oauth_verifier)
      
      session[:token] = @token
      session[:token_secret] = @token_secret

      @token = session[:token]
      @token_secret = session[:token_secret]

       @user = User.find(current_user.id)
        if @user.auths == []
        @user.auths.create(:bluevia_token => "#{@token}", :bluevia_secret => "#{@token_secret}")
      else
        mod=@user.auths.first
        mod.update_attributes(:bluevia_token => "#{@token}", :bluevia_secret => "#{@token_secret}")
      end
      # puts session[:token]
      # puts session[:token_secret]

      puts "this is the token???? #{$token}"
      puts "this is the secret???? #{$token_secret}"
      
      redirect_to root_path
    end


   def calllocation

     @bc = BlueviaClient.new(
               { :consumer_key   => CONSUMER_KEY,
                 :consumer_secret=> CONSUMER_SECRET,
                 # :token          => session[:token],
                 # :token_secret   => session[:token_secret],
                 :token          => $token,
                 :token_secret   => $token_secret,
                 :uri            => "https://api.bluevia.com"
               })
   
       @bc.set_commercial
   
     @service = @bc.get_service(:Location)
     location = @service.get_location
   
     if latlong = location['terminalLocation']['currentLocation']['coordinates']
   
     @lat = latlong['latitude']
     @lon = latlong['longitude']
     @contact = session[:contact]
     @timestamp = session[:timestamp]
     puts "this is the contact #{@contact}"
     puts "this is the timestamp #{@timestamp}"
     puts @lat
     puts @lon
     
     session[:lat] = @lat
     session[:lon] = @lon

     geonames

     puts "bluevia DONE!"
     puts "#{session[:location]}"

    redirect_to hasblue_send_message_path
   else 
    redirect_to root_path 
  end
   end


end
