class TestRunWorker < SimpleWorker::Base

require 'httparty'
require 'json'

CLIENT_ID = ENV['CLIENT_ID']
CLIENT_SECRET = ENV['CLIENT_SECRET']

 AUTH_SERVER = "https://hashblue.com"
 API_SERVER = "https://api.hashblue.com"


    def get_with_access_token(path)

      puts "!!!!!!!!!!!!!!!!!!!!!!this is the timestamp = #{$timestamp}"
      if $timestamp == nil
         $timestamp ="2011-09-29T23:00Z"
         
      end
      puts "THIS IS THE NEW TIMESTAMP!!!  = #{$timestamp}"
        HTTParty.get(API_SERVER + path, :query => {:oauth_token => access_token, :since => $timestamp })
    end

    def access_token
        session[:access_token]
    end

def bluevia
  redirect_to bluevia_calllocation_path
end


 def run
       loop do
        @messages_response = get_with_access_token("/messages.json")

        case @messages_response.code
                   when 200
          @messages = @messages_response["messages"]
          
          unless @messages == []
             @messages.each {|message| 
              puts message
               if message["content"].last(10) == "Where r u?" 
               @contact = message["contact"]["msisdn"]
               @timestamp = message["timestamp"]
               $timestamp = @timestamp
               session[:contact] = @contact
               session[:timestamp] = @timestamp
               bluevia
               return
             else
              @contact ="No location requests as of"
              @timestamp = $timestamp
              puts "No location requests as of #{$timestamp}"
              # redirect_to main_index_path
              # return
         end
         }
       else 
        puts "no new messages"
        @contact ="No location requests as of"
        @timestamp = $timestamp
      end

        else
          return
        end
        sleep 5
      end
      else
        # No Access token therefore authorize this application and request an access token
        puts "ERROR TOKEN #{CLIENT_SECRET}"
        return
       end
    end
end
end

