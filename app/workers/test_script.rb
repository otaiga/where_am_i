require 'httparty'
require 'json'
require 'bluevia'
include Bluevia

  CLIENT_ID = ENV['CLIENT_ID']
  CLIENT_SECRET = ENV['CLIENT_SECRET']
  CONSUMER_KEY = ENV['BLUEVIA_KEY']
  CONSUMER_SECRET = ENV['BLUEVIA_SECRET']
  AUTH_SERVER = "https://hashblue.com"
  API_SERVER = "https://api.hashblue.com"

def geonames
       #Geo-names bit

           places_nearby = Geonames::WebService.find_nearby_place_name @lat, @lon
            
            @here = places_nearby.first.name
            @here2 = places_nearby.first.country_name
            puts @here
            $location = @here
            return
  end



    def get_with_access_token(path)

      puts "this is the timestamp = #{$timestamp}"
      if $timestamp == nil
         $timestamp = Time.now.strftime("%Y-%m-%dT%H:%M:%SZ")
         end
         HTTParty.get(API_SERVER + path, :query => {:oauth_token => $access_token, :since => $timestamp })
      end




def send_message
  puts "should send the message from here"
  puts "around here somewhere #{$location}"
  puts "#{@contact}"
  puts "END"
  path = "/messages"
  HTTParty.post(API_SERVER + path, :query => {:oauth_token => $access_token, :message => {:phone_number => @contact , :content => $location }})
end




def bluevia_check
    puts "RUNNING BLUEVIA_CHECK!!!!"
     @bc = BlueviaClient.new(
               { :consumer_key   => CONSUMER_KEY,
                 :consumer_secret=> CONSUMER_SECRET,
                 :token          => $token,
                 :token_secret   => $token_secret,
                 :uri            => "https://api.bluevia.com"
               })
   
       @bc.set_commercial
   
     @service = @bc.get_service(:Location)
     location = @service.get_location
     # case @service.code
     #  when 200

   
     if latlong = location['terminalLocation']['currentLocation']['coordinates']
   
     @lat = latlong['latitude']
     @lon = latlong['longitude']
     # @contact = session[:contact]
     # @timestamp = session[:timestamp]
     puts "this is the contact #{@contact}"
     puts "this is the timestamp #{@timestamp}"
     puts @lat
     puts @lon
     
     # session[:lat] = @lat
     # session[:lon] = @lon

      geonames

     puts "bluevia DONE!"
     puts "location = #{$location}"
     send_message
    # redirect_to hasblue_send_message_path
  # else 
  #   puts "issue"
  # end
   else 
    # redirect_to root_path 
    puts "should redirect"
  end
   end



loop do
  #Needs a new model in order to have user token for b=Auth.where("run_flag" => true)bluevia and hashblue
    puts "Running script"
    users=Auth.where("run_flag" => true)  #This is pretty bad code.. add to model and scope it.
    if users != []
    users.each {|users| puts "User ID  = #{users.user_id}" 
    $access_token = users.hb_token
    $token = users.bluevia_token
    $token_secret = users.bluevia_secret
    $timestamp = users.last_time
    # puts "Hashblue token = #{$access_token}"
    # puts "bluevia Token = #{$token}"
    # puts "bluevia Secret = #{$token_secret}"
    @messages_response = get_with_access_token("/messages.json")

    case @messages_response.code
                   when 200
          @messages = @messages_response["messages"]
          
          unless @messages == []
             @messages.each {|message| 
              @user = User.find(users.user_id)
               whitelist = @user.whitelists.all

               if message["content"].last(10) == "Where r u?"
                puts message["sent"]
               whitelist.each { |whitelist| 
                puts whitelist.number
                 if message["contact"]["msisdn"] == whitelist.number 
                  puts "this is the message sent!!! #{message["sent"]}"

                   if message["sent"] == false
               @contact = message["contact"]["msisdn"]
               @timestamp = message["timestamp"]
               @auth = @user.auths.first
               @auth.update_attributes(:last_time => @timestamp)  #added for each user?..
               puts "This is the users TIMESTAMP #{$timestamp}"
               # session[:contact] = @contact
               # session[:timestamp] = @timestamp
               # bluevia
               puts "FOUND A MATCH!!!"

               #bluevia bit....

               bluevia_check
               sleep 5
               $timestamp = @timestamp
             else 
                puts "is sent"
              end
             else
              puts "#{message["contact"]["msisdn"]} Does not match #{whitelist.number}"
            end
          }

                 else
              @contact ="No location requests as of"
              puts "MESSAGE TIMESTAMP #{message["timestamp"]}"
              new_timestamp = message["timestamp"]
              puts "No location requests as of #{new_timestamp}"
              @auth = @user.auths.first
              @auth.update_attributes(:last_time => new_timestamp)  #added for each user?..
         end
         }
       else 
        puts "no new messages"
        @contact ="No location requests as of"
      end

		else
        # No Access token therefore authorize this application and request an access token
        puts "ERROR TOKEN #{CLIENT_SECRET}"
    end
  }
else 
  puts "no one has turned on the flag!!"
end
    sleep 3
  end

