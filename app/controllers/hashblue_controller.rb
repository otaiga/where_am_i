class HashblueController < ApplicationController

require 'httparty'
require 'json'

  CLIENT_ID = ENV['CLIENT_ID']
  CLIENT_SECRET = ENV['CLIENT_SECRET']

 AUTH_SERVER = "https://hashblue.com"
 API_SERVER = "https://api.hashblue.com"


    def redirect_uri
      "http://" + request.host_with_port + "/callback"
    end

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

    def authorize_url
        AUTH_SERVER + "/oauth/authorize?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&redirect_uri=#{redirect_uri}"
    end

    def access_token_url
        AUTH_SERVER + "/oauth/access_token"
    end


def index
if user_signed_in?
if session[:access_token]
        # authorized so request the messages from #blue)
        @messages_response = get_with_access_token("/messages.json")

        case @messages_response.code
                   when 200
          @messages = @messages_response["messages"]
          
             @messages.each {|message| 
               if message["content"].last(10) == "Where r u?" 
               @contact = message["contact"]["msisdn"]
               @timestamp = message["timestamp"]
               return
             else
              @contact ="No location requests as of yet"
              @timestamp = ""
     
         end
         }
                             
        when 401
         redirect_to AUTH_SERVER + "/oauth/authorize?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&redirect_uri=http://" + request.host_with_port + "/callback"
        else
          "Got an error from the server (#{@messages_response.code.inspect}): #{CGI.escapeHTML(@messages_response.inspect)}"
        end
      else
        # No Access token therefore authorize this application and request an access token
        redirect_to "https://hashblue.com/oauth/authorize?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&redirect_uri=http://" + request.host_with_port + "/callback"
        puts "ERROR TOKEN #{CLIENT_SECRET}"
       end
    end
   end

  
    def callback
        # assuming access is granted
        # Call server to get an access token
        response = HTTParty.post(access_token_url, :body => {
          :client_id => CLIENT_ID,
          :client_secret => CLIENT_SECRET,
          :redirect_uri => redirect_uri,
          :code => params["code"],
          :grant_type => 'authorization_code'}
        )
      
        session[:access_token] = response["access_token"]
        # $access_token = response["access_token"]
        redirect_to root_path

     end


def run
if user_signed_in?
if session[:access_token]
        # authorized so request the messages from #blue)
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
                             
        when 401
         redirect_to AUTH_SERVER + "/oauth/authorize?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&redirect_uri=http://" + request.host_with_port + "/callback"
        else
          "Got an error from the server (#{@messages_response.code.inspect}): #{CGI.escapeHTML(@messages_response.inspect)}"
        end
        sleep 5
      end
      else
        # No Access token therefore authorize this application and request an access token
        redirect_to "https://hashblue.com/oauth/authorize?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&redirect_uri=http://" + request.host_with_port + "/callback"
        puts "ERROR TOKEN #{CLIENT_SECRET}"
       end
    end
end


def bluevia
  redirect_to bluevia_calllocation_path
end


def send_message
  puts "should send the message from here"
  puts "around here somewhere #{session[:location]}"
  puts "#{session[:contact]}"
  @contact = session[:contact]
  @location = session[:location]
  puts "END"
  path = "/messages"
  HTTParty.post(API_SERVER + path, :query => {:oauth_token => access_token, :message => {:phone_number => @contact , :content => @location }})
  redirect_to root_path
end



end
